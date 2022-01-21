RISCV_TUPLE ?= riscv64-unknown-elf

ifdef RISCV_TOOLS
  RISCV_PREFIX = $(RISCV_TOOLS)/bin/$(RISCV_TUPLE)
else
  RISCV_PREFIX = $(RISCV_TUPLE)
endif

CC = $(RISCV_PREFIX)-gcc -specs baremetal.specs

DHRY-LFLAGS =

DHRY-CFLAGS := -O3 -DNOENUM -Wno-implicit
DHRY-CFLAGS += -fno-common -falign-functions=4

# Borrowed from CoreMark
DHRY-CFLAGS += \
  -funroll-loops -flto -funswitch-loops \
  -falign-jumps=4 -falign-loops=4 \
  -finline-functions --param max-inline-insns-auto=20 \
  -mstrict-align

# Unhelpful:
#  -ffreestanding

#Uncomment below for FPGA run, default DHRY_ITERS is 2000 for RTL
#DHRY-CFLAGS += -DDHRY_ITERS=20000000

SRC = dhry_1.c dhry_2.c strcmp.S
HDR = dhry.h

override CFLAGS += $(DHRY-CFLAGS) $(XCFLAGS)
dhrystone: $(SRC) $(HDR)
	$(CC) $(CFLAGS) $(SRC) $(LDFLAGS) $(LOADLIBES) $(LDLIBS) -o $@

clean:
	rm -f *.i *.s *.o dhrystone dhrystone.hex

