CC		:= clang
OBJCOPY := objcopy
LD		:= ld.lld

CFLAGS	:= -Wall -Wextra -O2 -static
LDFLAGS := -static

SHELL_CFLAGS	:= -ffreestanding -fmerge-all-constants -fPIC -O3 -nostdlib -Wall -Wextra ${MUSL_INC} -fno-stack-protector
SHELL_LDFLAGS := -Ttext 0x0 --image-base=0x0	--strip-all

SRC		:= exploit/shell.c
TEST_SRC	 := exploit/local_shellcode_runner.c
OBJ		:= $(SRC:.c=.o)
TEST_OBJ	 := $(TEST_SRC:.c=.o)
ELF		:= $(SRC:.c=.elf)
BIN		:= $(SRC:.c=.bin)
TEST_ELF := $(TEST_SRC:.c=.elf)


CTF_USER := asm
CTF_HOST := pwnable.kr
CTF_PORT := 2222


RAND_NUM := $(shell shuf -i 10000-99999 -n 1)
REMOTE_FILE := /tmp/shell_$(RAND_NUM).bin

.PHONY: all clean dump test upload

all: $(BIN)

$(TEST_SRC): $(BIN)

$(TEST_OBJ): $(TEST_SRC)
	$(CC) $(CFLAGS) -c $< -o $@

$(TEST_ELF): $(TEST_OBJ)
	$(CC) $(LDFLAGS) $< -o $@


test: $(TEST_ELF)
	@echo "[*] Executing local shellcode test runner..."
	$(TEST_ELF)


$(OBJ): $(SRC)
	$(CC) $(SHELL_CFLAGS) $(CFLAGS) -c $< -o $@

$(ELF): $(OBJ)
	$(LD) $(SHELL_LDFLAGS) $(LDFLAGS) $< -o $@

$(BIN): $(ELF)
	$(OBJCOPY) -O binary --only-section=.text  $< $@
	@echo "[+] Raw shellcode payload generated: $@"

dump: $(BIN)
	@echo "[*] Raw Hex Payload (Pasting Format):"
	@od -tx1 -An $(BIN) | tr -d '\n' | sed 's/ /\\x/g'
	@echo ""


upload:  $(BIN)
	@echo "[*] Uploading to remote server as: $(REMOTE_FILE)"
	scp -P $(CTF_PORT) $(BIN) $(CTF_USER)@$(CTF_HOST):$(REMOTE_FILE)
	@echo "[+] Done. Access your payload via SSH at: $(REMOTE_FILE)"

clean:
	rm -f $(OBJ) $(ELF) $(BIN) $(TEST_ELF) $(TEST_OBJ)
