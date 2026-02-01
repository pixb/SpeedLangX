.PHONY: all rust go clean run-rust run-go run-all benchmark

BUILD_DIR := build
RUST_TARGET := $(BUILD_DIR)/SpeedLangX_rust
GO_TARGET := $(BUILD_DIR)/SpeedLangX_go

all: rust go

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

clean:
	@echo "Cleaning..."
	@cd rust && cargo clean
	@rm -f $(BUILD_DIR)/*
	@echo "Clean complete"

run-rust: rust
	@echo "Running Rust..."
	@$(RUST_TARGET)

run-go: go
	@echo "Running Go..."
	@$(GO_TARGET)

run-all: rust go
	@echo "Running Rust..."
	@$(RUST_TARGET)
	@echo ""
	@echo "Running Go..."
	@$(GO_TARGET)

benchmark: rust go
	@echo "Running benchmarks..."
	@python3 benchmark.py
