FROM ubuntu:20.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    cmake \
    ninja-build \
    clang \
    lld \
    git \
    python3 \
    python3-pip \
    python3-dev \
    python3-setuptools \
    python3-wheel \
    build-essential \
    libedit-dev \
    libncurses5-dev \
    pkg-config \
    curl \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create a working directory
WORKDIR /workdir

# Clone LLVM project with MLIR
RUN git clone https://github.com/llvm/llvm-project.git --depth 1

# Create a build directory
RUN mkdir llvm-project/build

# Configure and build LLVM with MLIR
WORKDIR /workdir/llvm-project/build
RUN cmake ../llvm \
    -G Ninja \
    -DLLVM_ENABLE_PROJECTS=mlir \
    -DLLVM_BUILD_EXAMPLES=ON \
    -DLLVM_TARGETS_TO_BUILD="X86;NVPTX;AMDGPU" \
    -DCMAKE_BUILD_TYPE=Release \
    -DLLVM_ENABLE_ASSERTIONS=ON \
    -DLLVM_INSTALL_UTILS=ON \
    && ninja

# Set environment variables
ENV PATH="/workdir/llvm-project/build/bin:${PATH}"
ENV PYTHONPATH="/workdir/llvm-project/build/tools/mlir/python_packages/mlir_core:${PYTHONPATH}"

WORKDIR /workdir
CMD ["/bin/bash"]