CC      := clang
OBJCOPY := objcopy
LD      := ld.lld

CFLAGS  := -ffreestanding -fmerge-all-constants -fPIC -O3 -nostdlib -Wall -Wextra
LDFLAGS := -Ttext 0x0 --strip-all

SRC     := shellcode.c
OBJ     := $(SRC:.c=.o)
ELF     := $(SRC:.c=.elf)
BIN     := $(SRC:.c=.bin)

.PHONY: all clean dump

all: $(BIN)

$(OBJ): $(SRC)
	$(CC) $(CFLAGS) -c $< -o $@

$(ELF): $(OBJ)
	$(LD) $(LDFLAGS) $< -o $@

$(BIN): $(ELF)
	$(OBJCOPY) -O binary --only-section=.text $< $@
	@echo "[+] Raw shellcode payload generated: $@"

dump: $(BIN)
	@echo "[*] Raw Hex Payload (Pasting Format):"
	@od -tx1 -An $(BIN) | tr -d '\n' | sed 's/ /\\x/g'
	@echo ""

clean:
	rm -f $(OBJ) $(ELF) $(BIN)
