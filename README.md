# SpeedLangX

<div align="center">
  <img src="res/1769931931.png" alt="SpeedLangX Banner" width="100%">
</div>

<div align="center">

![Rust](https://img.shields.io/badge/Rust-1.87-orange?style=for-the-badge&logo=rust)
![Go](https://img.shields.io/badge/Go-1.23-blue?style=for-the-badge&logo=go)
![C](https://img.shields.io/badge/C-17-blue?style=for-the-badge&logo=c)
![C++](https://img.shields.io/badge/C%2B%2B-17-blue?style=for-the-badge&logo=c%2B%2B)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20Linux%20%7C%20Windows-lightgrey?style=for-the-badge)

</div>

---

## 📖 About

**SpeedLangX** is a high-performance programming language benchmark project focused on comparing the performance of different programming languages under identical algorithms. This project uses SHA256 double hashing as a benchmark test case to intuitively demonstrate performance differences between languages.

### ✨ Features

- 🔥 **High-performance comparison**: Uses optimized compilation settings to showcase true language performance
- 📊 **Beautiful table display**: Automatically generates formatted performance comparison tables
- 💾 **Hardware info collection**: Automatically detects and records test environment hardware configuration
- 📝 **Result persistence**: Automatically saves each test result to a Markdown file
- 🚀 **One-click execution**: Uses Makefile to simplify build and test workflows
- 🎯 **Cross-platform support**: Supports macOS, Linux, and Windows
- 🌐 **Multi-language support**: Supports Rust, Go, C, and C++

---

## 🏗️ Project Structure

```
SpeedLangX/
├── rust/              # Rust implementation
│   ├── Cargo.toml
│   └── src/main.rs
├── go/                # Go implementation
│   └── main.go
├── c/                 # C implementation
│   └── main.c
├── cpp/               # C++ implementation
│   └── main.cpp
├── benchmark.py        # Benchmark script
├── Makefile           # Build script
├── BenchmarkResult.md  # Test result log
└── README.md          # Project documentation
```

---

## 🚀 Quick Start

### Prerequisites

- **Rust**: 1.87 or higher
- **Go**: 1.23 or higher
- **C/C++**: GCC or Clang compiler
- **Python**: 3.x (for running benchmark scripts)
- **Make**: For build management

### Install Dependencies

```bash
# Install Python dependencies
pip3 install tabulate

# macOS
brew install openssl jansson nlohmann-json

# Linux (Ubuntu/Debian)
sudo apt-get install libssl-dev libjansson-dev nlohmann-json3-dev

# Linux (Fedora/CentOS)
sudo dnf install openssl-devel jansson-devel nlohmann-json-devel
```

### Build Project

```bash
# Build all projects
make all

# Or build individually
make rust    # Build Rust only
make go      # Build Go only
make c        # Build C only
make cpp      # Build C++ only
```

---

## 📊 Running Benchmarks

### Run Full Benchmark

```bash
make benchmark
```

This will:
1. Compile Rust, Go, C, and C++ programs
2. Collect hardware information (OS, CPU, Memory)
3. Run performance tests
4. Display beautiful result tables
5. Save results to [BenchmarkResult.md](./BenchmarkResult.md)

### Run Individual Tests

```bash
make run-rust    # Run Rust test only
make run-go      # Run Go test only
make run-c       # Run C test only
make run-cpp     # Run C++ test only
make run-all     # Run all tests (without table display)
```

### Clean Build Artifacts

```bash
make clean
```

---

## 📈 Test Result Example

### Hardware Information

| Component   | Specification   |
|-------------|-----------------|
| OS          | macOS 15.7.3    |
| CPU         | Apple M4        |
| Memory      | 16 GB           |

### Performance Comparison

| Language   | Time (s) | Ops/sec    | Hash                |
|------------|------------|------------|---------------------|
| Rust       | 16.4       | 12,194,527 | ef963d1220b1b5f9... |
| Go         | 25.18      | 7,944,228  | ef963d1220b1b5f9... |
| C          | 69.58      | 2,874,579  | ef963d1220b1b5f9... |
| C++        | 72.23      | 2,768,962  | ef963d1220b1b5f9... |

### Performance Summary

- Rust is **53.5%** faster than Go
- C is **63.8%** slower than Go
- C++ is **65.1%** slower than Go
- Final Hash: `ef963d1220b1b5f930ef309a489eae0197dcec7537953ba96bd270808bda4144`

---

## 🔧 Technical Details

### Test Algorithm

- **Algorithm**: SHA256 double hashing
- **Iterations**: 200,000,000 times
- **Data Size**: 32 bytes

### Compilation Optimizations

#### Rust
- Optimization level: `opt-level = 3`
- Link-time optimization: `lto = true`
- Codegen units: `codegen-units = 1`
- Panic strategy: `panic = "abort"`
- Strip symbols: `strip = true`

#### Go
- Linker flags: `-ldflags="-s -w"`
- Compiler flags: `-gcflags="-l=4"`
- Trim paths: `-trimpath`

#### C
- Optimization level: `-O3`
- Architecture optimization: `-march=native`
- Linked libraries: OpenSSL (SHA256), Jansson (JSON)

#### C++
- Optimization level: `-O3`
- Architecture optimization: `-march=native`
- C++ standard: `-std=c++17`
- Linked libraries: OpenSSL (SHA256), nlohmann/json (JSON)

---

## 💻 Hardware Impact

Test performance is mainly affected by the following hardware factors:

### CPU (Most Important)
- ✅ CPU architecture (x86/ARM)
- ✅ Instruction set support (AVX2/AVX-512/NEON)
- ✅ Single-core frequency (this test is single-threaded)
- ✅ Cache size (L1/L2/L3)

### Memory (Less Impact)
- ⚪ Memory bandwidth (small data size, limited impact)
- ⚪ Memory latency (data can fit entirely in cache)

### Other Factors
- 🔥 Thermal performance (overheating causes throttling)
- 🔋 Power management (power-saving mode limits performance)

---

## 📝 Development Guide

### Adding a New Programming Language

1. Create a new language directory in the project root
2. Implement the same SHA256 double hashing algorithm
3. Output results in JSON format:
   ```json
   {
     "language": "LanguageName",
     "time": 12.34,
     "ops_per_sec": 12345678,
     "hash": "abc123..."
   }
   ```
4. Update Makefile to add build targets
5. Update `benchmark.py` to add test logic

### Modifying Test Parameters

Edit the loop count in each language's source file:

```rust
// Rust
while count < 200_000_000u64 {
```

```go
// Go
for count < 200_000_000 {
```

```c
// C
#define ITERATIONS 200000000
```

```cpp
// C++
#define ITERATIONS 200000000
```

---

## 🤝 Contributing

Contributions are welcome! If you want to:

- 🌍 Add new programming languages
- 🐛 Fix bugs
- 📚 Improve documentation
- ⚡ Optimize performance

Please submit a Pull Request!

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

---

## 🙏 Acknowledgments

- [Rust](https://www.rust-lang.org/) - Systems programming language
- [Go](https://golang.org/) - Simple and efficient programming language
- [ring](https://github.com/briansmith/ring) - Rust cryptography library
- [OpenSSL](https://www.openssl.org/) - C/C++ cryptography library
- [Jansson](https://digip.org/jansson/) - C JSON library
- [nlohmann/json](https://github.com/nlohmann/json) - C++ JSON library
- [tabulate](https://github.com/astanin/python-tabulate) - Python table formatting library

---

<div align="center">

**If this project helps you, please give it a ⭐️**

Made with ❤️ by [pixb](https://github.com/pixb)

</div>
