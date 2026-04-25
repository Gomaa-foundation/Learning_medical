# Python Internals: Study Guide (v3.13)

This guide is an updated companion to Anthony Shaw's "CPython Internals." It focuses on the significant architectural changes introduced in Python 3.11 through 3.13.

---

## 1. The 3.13 Shift

Between versions 3.11 and 3.13, the Python interpreter underwent its most significant transformation in decades:
1.  **The PEG Parser**: A more flexible and powerful way for Python to read code.
2.  **Adaptive Specialization**: A system that makes Python up to 30% faster by optimizing code as it runs.
3.  **Experimental JIT**: A Just-In-Time compiler that translates hot code into machine instructions.
4.  **No-GIL Build**: An experimental version of Python that allows true multi-core parallelism.

---

## 2. The Core Object Model

In Python, everything is an object. At the C level, this means everything is a pointer to a specific structure called `PyObject`.

### 2.1 The `PyObject` Header
Every object in Python—from an integer to a custom class—starts with the same information:
- **Reference Count**: How many variables are currently pointing to this object.
- **Type Pointer**: A link to the object's type (telling Python "this is a string" or "this is a list").

### 2.2 Memory Overhead
Because every object needs this header, Python uses more memory than languages like C. For example, a simple integer takes ~28 bytes of memory because of the administrative data required to manage it.

---

## 3. How Python Executes Code

1. **Tokenizing**: Your `.py` file is broken down into "tokens" (keywords, names, operators).
2. **Parsing**: The tokens are arranged into an **Abstract Syntax Tree (AST)** that represents the logic of your program.
3. **Compiling**: The AST is turned into **Bytecode**—simple instructions like `LOAD_FAST` or `BINARY_OP`.
4. **Interpreting**: The Virtual Machine (PVM) reads the bytecode and executes the instructions one by one.

---

## 4. Memory Management

Python manages memory for you using two main systems:
- **Reference Counting**: When no more variables point to an object, its memory is freed immediately.
- **Garbage Collection (GC)**: A background process that finds "Circular References" (where two objects point to each other) and cleans them up.

---

## 5. High-Performance Features

### 5.1 The GIL (Global Interpreter Lock)
The GIL is a safety mechanism that ensures only one thread executes Python code at a time. While this makes Python simple and stable, it limits multi-core performance for math-heavy tasks.

### 5.2 Specialization
Modern Python "specializes" code at runtime. If a loop is always adding two integers, Python replaces the generic "add" instruction with a high-speed "add integers" version, skipping many expensive checks.

---

## 6. How to Study Internals

- **Read the Source**: The `Include/` and `Objects/` directories in the CPython source code are the best place to start.
- **Use GDB**: Use a debugger to step through the C code as a simple Python script runs.
- **Benchmark**: Use the `timeit` module to see how different coding patterns affect performance.

---

**Status**: v0.1.0 · Technical Mastery Guide
