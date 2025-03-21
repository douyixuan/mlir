# Getting Started with MLIR

This guide walks you through the basics of MLIR (Multi-Level Intermediate Representation), an intermediate representation and compiler framework designed to address the challenges of heterogeneous hardware and specialized software stacks.

## Prerequisites

- CMake (3.13.4 or later)
- C++ compiler (supporting C++17)
- Python (for optional features)
- LLVM dependencies

## Building MLIR

### Option 1: Build as Part of LLVM

```bash
git clone https://github.com/llvm/llvm-project.git
cd llvm-project
mkdir build && cd build
cmake -G Ninja ../llvm \
    -DLLVM_ENABLE_PROJECTS=mlir \
    -DLLVM_BUILD_EXAMPLES=ON \
    -DLLVM_TARGETS_TO_BUILD="X86;NVPTX;AMDGPU" \
    -DCMAKE_BUILD_TYPE=Release \
    -DLLVM_ENABLE_ASSERTIONS=ON
ninja
```

### Option 2: Build MLIR Standalone

```bash
git clone https://github.com/llvm/llvm-project.git
cd llvm-project
mkdir build && cd build
cmake -G Ninja ../llvm -DLLVM_ENABLE_PROJECTS=mlir -DCMAKE_BUILD_TYPE=Release
ninja check-mlir
```

## Running MLIR Examples

After building MLIR, you can run the examples in the `mlir/examples` directory:

```bash
# Run the toy compiler example
cd mlir/examples/toy
./ch1_parser input.toy
```

## Learning Resources

- [MLIR Documentation](https://mlir.llvm.org/)
- [MLIR Tutorials](https://mlir.llvm.org/docs/Tutorials/)
- [Dialect Reference](https://mlir.llvm.org/docs/Dialects/)
- [MLIR GitHub Repository](https://github.com/llvm/llvm-project/tree/main/mlir)

## Core Concepts

- **Dialects**: MLIR's extensibility mechanism allowing domain-specific abstractions
- **Operations**: The core IR units in MLIR
- **Passes**: Transformations on the IR

## Common Tasks

### Creating a Simple MLIR File

[example.mlir](code/example.mlir)

```mlir
func.func @add(%a: i32, %b: i32) -> i32 {
    %0 = arith.addi %a, %b : i32
    return %0 : i32
}
```

### Running the MLIR Tools

```bash
# Print the MLIR
mlir-opt example.mlir

# Lower to LLVM dialect
mlir-opt example.mlir --convert-to-llvm -o example.opt.mlir

# Finally, Translate to LLVM IR
mlir-translate example.opt.mlir --mlir-to-llvmir
```

[example.opt.mlir](code/example.opt.mlir)

```mlir
module {
  llvm.func @add(%arg0: i32, %arg1: i32) -> i32 {
    %0 = llvm.add %arg0, %arg1 : i32
    llvm.return %0 : i32
  }
}
```

[example.opt.ll](code/example.opt.ll)

```llvm
; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

define i32 @add(i32 %0, i32 %1) {
  %3 = add i32 %0, %1
  ret i32 %3
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
```

## Getting Help

- Join the LLVM Discord server
- Subscribe to the LLVM mailing lists
- Browse the [MLIR GitHub issues](https://github.com/llvm/llvm-project/issues)