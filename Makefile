QEMU := qemu-system-x86_64
NASM := nasm
BUILD_DIR := build/
SRC_DIR := src/
ASM_SRC := $(SRC_DIR)main.asm
BIN_TARGET := $(BUILD_DIR)boot.bin
NASMFLAGS := -fbin -I$(SRC_DIR)

all: run

run: $(BIN_TARGET)
	$(QEMU) -drive format=raw,file=$<

$(BIN_TARGET): $(ASM_SRC) | $(BUILD_DIR)
	$(NASM) $(NASMFLAGS) $< -o $@

$(BUILD_DIR):
	mkdir -p $@

build: $(BIN_TARGET)

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all run build clean