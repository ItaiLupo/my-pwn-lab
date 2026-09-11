CC      := clang

CFLAGS  := -O2 -static -Wall -Wextra

SRC     := exploit.c
OUT     := exploit

.PHONY: all clean

all: $(OUT)

$(OUT): $(SRC)
	$(CC) $(CFLAGS) $< -o $@
	@echo "[+] Standalone static ELF generated: $@"

clean:
	rm -f $(OUT)
