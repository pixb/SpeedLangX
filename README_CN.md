# SpeedLangX

<div align="center">
  <img src="res/1769931931.png" alt="SpeedLangX Banner" width="100%">
</div>

<div align="center">

![Rust](https://img.shields.io/badge/Rust-1.87-orange?style=for-the-badge&logo=rust)
![Go](https://img.shields.io/badge/Go-1.23-blue?style=for-the-badge&logo=go)
![C](https://img.shields.io/badge/C-17-blue?style=for-the-badge&logo=c)
![C++](https://img.shields.io/badge/C%2B%2B-17-blue?style=for-the-badge&logo=c%2B%2B)
![LuaJIT](https://img.shields.io/badge/LuaJIT-2.1-blue?style=for-the-badge&logo=lua)
![Python](https://img.shields.io/badge/Python-3.12-blue?style=for-the-badge&logo=python)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20Linux%20%7C%20Windows-lightgrey?style=for-the-badge)

</div>

---

## 📖 简介

**SpeedLangX** 是一个高性能编程语言基准测试项目，专注于对比不同编程语言在相同算法下的性能表现。本项目使用 SHA256 双重哈希算法作为基准测试用例，可以直观地展示不同语言的性能差异。

### ✨ 特性

- 🔥 **高性能对比**：使用优化的编译配置，展现语言真实性能
- 📊 **美观的表格展示**：自动生成格式化的性能对比表格
- 💾 **硬件信息收集**：自动检测并记录测试环境的硬件配置
- 📝 **结果持久化**：每次测试结果自动保存到 Markdown 文件
- 🚀 **一键运行**：使用 Makefile 简化构建和测试流程
- 🎯 **跨平台支持**：支持 macOS、Linux 和 Windows
- 🌐 **多语言支持**：支持 Rust、Go、C、C++

---

## 🏗️ 项目结构

```
SpeedLangX/
├── rust/              # Rust 实现
│   ├── Cargo.toml
│   └── src/main.rs
├── go/                # Go 实现
│   └── main.go
├── c/                 # C 实现
│   └── main.c
├── cpp/               # C++ 实现
│   └── main.cpp
├── luajit/            # LuaJIT 实现
│   └── main.lua
├── python/            # Python 实现
│   └── main.py
├── benchmark.py        # 基准测试脚本
├── Makefile           # 构建脚本
├── BenchmarkResult.md  # 测试结果记录
└── README.md          # 项目文档
```

---

## 🚀 快速开始

### 前置要求

- **Rust**: 1.87 或更高版本
- **Go**: 1.23 或更高版本
- **C/C++**: GCC 或 Clang 编译器
- **LuaJIT**: 2.1 或更高版本
- **Python**: 3.12 或更高版本
- **Make**: 用于构建管理

### 安装依赖

```bash
# 安装 Python 依赖
pip3 install tabulate

# macOS
brew install openssl jansson nlohmann-json luajit

# Linux (Ubuntu/Debian)
sudo apt-get install libssl-dev libjansson-dev nlohmann-json3-dev luajit

# Linux (Fedora/CentOS)
sudo dnf install openssl-devel jansson-devel nlohmann-json-devel luajit-devel
```

### 构建项目

```bash
# 构建所有项目
make all

# 或者单独构建
make rust    # 仅构建 Rust
make go      # 仅构建 Go
make c        # 仅构建 C
make cpp      # 仅构建 C++
make luajit   # 仅构建 LuaJIT
make python   # 仅构建 Python
```

---

## 📊 运行基准测试

### 运行完整基准测试

```bash
make benchmark
```

这将：
1. 编译 Rust、Go、C、C++、LuaJIT、Python 程序
2. 收集硬件信息（OS、CPU、内存）
3. 运行性能测试
4. 显示美观的结果表格
5. 将结果保存到 [BenchmarkResult.md](./BenchmarkResult.md)

### 单独运行测试

```bash
make run-rust    # 仅运行 Rust 测试
make run-go      # 仅运行 Go 测试
make run-c       # 仅运行 C 测试
make run-cpp     # 仅运行 C++ 测试
make run-luajit  # 仅运行 LuaJIT 测试
make run-python  # 仅运行 Python 测试
make run-all     # 运行所有测试（无表格展示）
```

### 清理构建产物

```bash
make clean
```

---

## 📈 测试结果示例

### 硬件信息

| Component   | Specification   |
|-------------|-----------------|
| OS          | macOS 15.7.3    |
| CPU         | Apple M4        |
| Memory      | 16 GB           |

### 性能对比

| Language   | Time (s) | Ops/sec    | Hash                |
|------------|------------|------------|---------------------|
| Rust       | 16.91      | 11,824,273 | ef963d1220b1b5f9... |
| Go         | 25.91      | 7,717,997  | ef963d1220b1b5f9... |
| C          | 71.26      | 2,806,622  | ef963d1220b1b5f9... |
| C++        | 73.77      | 2,711,167  | ef963d1220b1b5f9... |
| LuaJIT     | 118.53     | 1,687,391  | ef963d1220b1b5f9... |
| Python     | 153.94     | 1,299,194  | ef963d1220b1b5f9... |

### 性能总结

- Rust 比 Go 快 **53.2%**
- C 比 Go 慢 **63.6%**
- C++ 比 Go 慢 **64.9%**
- LuaJIT 比 Go 慢 **78.1%**
- Python 比 Go 慢 **83.2%**
- 最终 Hash: `ef963d1220b1b5f930ef309a489eae0197dcec7537953ba96bd270808bda4144`

---

## 🔧 技术细节

### 测试算法

- **算法**: SHA256 双重哈希
- **迭代次数**: 200,000,000 次
- **数据大小**: 32 字节

### 编译优化

#### Rust
- 优化级别: `opt-level = 3`
- 链接时优化: `lto = true`
- 代码生成单元: `codegen-units = 1`
- Panic 策略: `panic = "abort"`
- 符号剥离: `strip = true`

#### Go
- 链接器标志: `-ldflags="-s -w"`
- 编译器标志: `-gcflags="-l=4"`
- 路径清理: `-trimpath`

#### C
- 优化级别: `-O3`
- 架构优化: `-march=native`
- 链接库: OpenSSL (SHA256), Jansson (JSON)

#### C++
- 优化级别: `-O3`
- 架构优化: `-march=native`
- C++ 标准: `-std=c++17`
- 链接库: OpenSSL (SHA256), nlohmann/json (JSON)

#### LuaJIT
- 使用 FFI (Foreign Function Interface) 调用 OpenSSL
- 即时编译 (JIT)
- 链接库: OpenSSL (SHA256)

#### Python
- 使用内置 `hashlib` 库
- 解释型语言（无需编译）
- 使用 `json` 模块输出

---

## 💻 硬件影响

测试性能主要受以下硬件因素影响：

### CPU（最重要）
- ✅ CPU 架构（x86/ARM）
- ✅ 指令集支持（AVX2/AVX-512/NEON）
- ✅ 单核频率（本测试为单线程）
- ✅ 缓存大小（L1/L2/L3）

### 内存（影响较小）
- ⚪ 内存带宽（数据量小，影响有限）
- ⚪ 内存延迟（数据可完全放入缓存）

### 其他因素
- 🔥 散热性能（过热会降频）
- 🔋 电源管理（省电模式限制性能）

---

## 📝 开发说明

### 添加新的编程语言

1. 在项目根目录创建新的语言目录
2. 实现相同的 SHA256 双重哈希算法
3. 输出 JSON 格式结果：
   ```json
   {
     "language": "LanguageName",
     "time": 12.34,
     "ops_per_sec": 12345678,
     "hash": "abc123..."
   }
   ```
4. 更新 Makefile 添加构建目标
5. 更新 `benchmark.py` 添加测试逻辑

### 修改测试参数

编辑各语言源文件中的循环次数：

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

```lua
-- LuaJIT
local ITERATIONS = 200000000
```

```python
# Python
ITERATIONS = 200000000
```

---

## 🤝 贡献

欢迎贡献！如果你想要：

- 🌍 添加新的编程语言
- 🐛 修复 Bug
- 📚 改进文档
- ⚡ 优化性能

请提交 Pull Request！

---

## 📄 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件

---

## 🙏 致谢

- [Rust](https://www.rust-lang.org/) - 系统编程语言
- [Go](https://golang.org/) - 简洁高效的编程语言
- [ring](https://github.com/briansmith/ring) - Rust 加密库
- [OpenSSL](https://www.openssl.org/) - C/C++ 加密库
- [Jansson](https://digip.org/jansson/) - C JSON 库
- [nlohmann/json](https://github.com/nlohmann/json) - C++ JSON 库
- [tabulate](https://github.com/astanin/python-tabulate) - Python 表格格式化库

---

<div align="center">

**如果这个项目对你有帮助，请给一个 ⭐️**

Made with ❤️ by [pixb](https://github.com/pixb)

</div>
