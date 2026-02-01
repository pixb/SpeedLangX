.PHONY: all rust go c cpp luajit python clean run-rust run-go run-c run-cpp run-luajit run-python run-all benchmark

BUILD_DIR := build
RUST_TARGET := $(BUILD_DIR)/SpeedLangX_rust
GO_TARGET := $(BUILD_DIR)/SpeedLangX_go
C_TARGET := $(BUILD_DIR)/SpeedLangX_c
CPP_TARGET := $(BUILD_DIR)/SpeedLangX_cpp
LUAJIT_TARGET := $(BUILD_DIR)/SpeedLangX_luajit
PYTHON_TARGET := $(BUILD_DIR)/SpeedLangX_python

all: rust go c cpp luajit python

rust:
	@echo "Building Rust..."
	@cd rust && cargo build --release
	@mkdir -p $(BUILD_DIR)
	@cp rust/target/release/demo $(RUST_TARGET)
	@echo "Rust binary: $(RUST_TARGET)"

go:
	@echo "Building Go..."
	@mkdir -p $(BUILD_DIR)
	@cd go && go build -ldflags="-s -w" -gcflags="-l=4" -trimpath -o ../$(GO_TARGET) main.go
	@echo "Go binary: $(GO_TARGET)"

c:
	@echo "Building C..."
	@mkdir -p $(BUILD_DIR)
	@cd c && gcc -O3 -march=native -I/opt/homebrew/opt/openssl@3/include -I/opt/homebrew/include -o ../$(C_TARGET) main.c -L/opt/homebrew/opt/openssl@3/lib -L/opt/homebrew/lib -lcrypto -ljansson
	@echo "C binary: $(C_TARGET)"

cpp:
	@echo "Building C++..."
	@mkdir -p $(BUILD_DIR)
	@cd cpp && g++ -O3 -march=native -std=c++17 -I/opt/homebrew/opt/openssl@3/include -I/opt/homebrew/include -o ../$(CPP_TARGET) main.cpp -L/opt/homebrew/opt/openssl@3/lib -L/opt/homebrew/lib -lcrypto
	@echo "C++ binary: $(CPP_TARGET)"

luajit:
	@echo "Building LuaJIT..."
	@mkdir -p $(BUILD_DIR)
	@echo '#!/bin/bash' > $(LUAJIT_TARGET)
	@echo 'cd $$(dirname $$0)/../luajit && luajit main.lua' >> $(LUAJIT_TARGET)
	@chmod +x $(LUAJIT_TARGET)
	@echo "LuaJIT binary: $(LUAJIT_TARGET)"

python:
	@echo "Building Python..."
	@mkdir -p $(BUILD_DIR)
	@echo '#!/bin/bash' > $(PYTHON_TARGET)
	@echo 'cd $$(dirname $$0)/../python && python3 main.py' >> $(PYTHON_TARGET)
	@chmod +x $(PYTHON_TARGET)
	@echo "Python binary: $(PYTHON_TARGET)"

clean:
	@echo "Cleaning..."
	@cd rust && cargo clean
	@rm -f $(BUILD_DIR)/*
	@rm -f c/main.o
	@rm -f cpp/*.o
	@echo "Clean complete"

run-rust: rust
	@echo "Running Rust..."
	@$(RUST_TARGET)

run-go: go
	@echo "Running Go..."
	@$(GO_TARGET)

run-c: c
	@echo "Running C..."
	@$(C_TARGET)

run-cpp: cpp
	@echo "Running C++..."
	@$(CPP_TARGET)

run-luajit: luajit
	@echo "Running LuaJIT..."
	@$(LUAJIT_TARGET)

run-python: python
	@echo "Running Python..."
	@$(PYTHON_TARGET)

run-all: rust go c cpp luajit python
	@echo "Running Rust..."
	@$(RUST_TARGET)
	@echo ""
	@echo "Running Go..."
	@$(GO_TARGET)
	@echo ""
	@echo "Running C..."
	@$(C_TARGET)
	@echo ""
	@echo "Running C++..."
	@$(CPP_TARGET)
	@echo ""
	@echo "Running LuaJIT..."
	@$(LUAJIT_TARGET)
	@echo ""
	@echo "Running Python..."
	@$(PYTHON_TARGET)

benchmark: rust go c cpp luajit python
	@echo "Running benchmarks..."
	@python3 benchmark.py
