# SparrowRV (小麻雀处理器) — Agent Guide

## Quick start

```bash
# Simulate with inst.txt (iverilog)
cd tb && python tools/tools.py sim_rtl

# Convert .bin → inst.txt, then simulate
python tools/tools.py sim_bin

# Run full RV32IM ISA test suite
python tools/tools.py all_isa

# Windows batch menu (same commands + Modelsim)
tb/工具箱.bat

# Makefile shortcuts (from tb/)
make 0   # sim_rtl
make 1   # all_isa
make 2   # tsr_bin (bin→inst.txt)
make 3   # sim_bin
make 4   # gtkwave tb.lxt
make c   # clean
```

## Simulation

- **iverilog** is the primary simulator; **Modelsim** (`vsim`) is optional.
- Must define `HDL_SIM` in compile flags (drives simulation-only logic like fast UART, trace log).
- Must define `ISA_TEST` when running ISA compliance tests.
- Program is loaded via `$readmemh("inst.txt", ...)` in `tb/tb_soc.sv:48`.
- Simulation stops when CSR `mends` is written to 1, or after 500k cycles timeout.
- UART divider is forced to 0 in sim (`SIM_UART_FAST`) — fast printf.
- Enable `SIM_TRACE_LOG` for instruction trace output to `tb/trace.log`.

## ISA test suite

Tests live in `tb/tools/isa/` (derived from [riscv-tests](https://github.com/riscv/riscv-tests)).
- Source assembly: `rv32ui/` (RV32I) and `rv32um/` (RV32M).
- Pre-built binaries in `generated/` (checked into repo).
- Convention: x26=1 signals test done, x27=1 means pass, x3 holds failing test number.
- Build with `riscv-none-embed-gcc` toolchain (expected at `tools/RISC-V_Embedded_GCC/`).
- Run: `make -C tb/tools/isa all` (needs toolchain) or `python tools/tools.py all_isa`.

## Build C programs (BSP)

Toolchain: `tools/RISC-V_Embedded_GCC/bin/riscv-none-embed-gcc` (riscv32, rv32im, ilp32).
- SDK: `bsp/bsp_app/lib/` — startup, linker script, drivers, printf, uart, spi.
- Example apps: `bsp/bsp_app/example/` (helloworld, coremark, timer, uart, spi_flash, sd_reader, etc.)
- Build an example: `cd bsp/bsp_app/example/helloworld && make`
- Output: `obj.bin` (raw binary to convert to `inst.txt` via `python tools/tools.py tsr_bin`).

## RTL architecture

- **2-stage pipeline**: IF → ID+EX+MEM+WB
- **Harvard** architecture (separate instruction fetch and data access paths).
- **Configurable ISA**: RV32I or RV32E, M extension, Zicsr, machine mode only.
- **ICB bus** (from Huani E203): 2 masters (core + JTAG), 8 slaves (iram, sram, sys_perip, plic, sdrd, 3 spare).
- **Core modules** (`rtl/core/`): `ifu.v` (fetch), `idex.v` (decode+execute), `regs.v` (register file), `csr.v` (CSRs), `div.v` (divider), `trap.v` (interrupt/exception), `sctr.v` (bus sequencer).
- **SoC peripherals** (`rtl/soc/sys_perip/`): `uart.v`, `spi.v`, `timer.v`, `fpioa.v`. Also PLIC (`plic.v`), SD reader (`sdrd/`).

## Configuration

All in `rtl/config.v`:
- `CPU_CLOCK_HZ` — must match actual FPGA clock
- `IRam_KB`, `SRam_KB` — memory sizes
- `RV32I_BASE_ISA` — define for RV32I, undefine for RV32E
- `RV32_M_ISA` — enable M extension
- `DIV_MODE` — `"HF_DIV"` (high-frequency), `"HP_DIV"`, `"SIM_DIV"`
- `SGCY_MUL` — single-cycle multiplier
- `PROG_IN_FPGA` + `PROG_FPGA_PATH` — embedded program for synthesis
- `JTAG_DBG_MODULE` — debug module (author says "broken, not recommended")

## FPGA targets (`fpga/`)

- Gowin (Tang Nano 20K, Tang Primer 20K) — primary targets
- Anlogic (SparkRoad-V) — requires `IRAM_SPRAM_W4B` and modified config.v in fpga dir
- AMD/Xilinx (Kintex-7) — modify `CPU_CLOCK_HZ` to match board
- Pango (PGL22G) — modify `CPU_CLOCK_HZ`
- Lattice (ECP5U)

## Quirks & conventions

- Chinese variable names in `tools/tools.py` (intentional, UTF-8).
- All text files are UTF-8 encoded.
- JTAG debug module is "功能残废" (crippled) — don't enable without good reason.
- Anlogic TD doesn't support inferred byte-write-enable RAMs — must define `IRAM_SPRAM_W4B`.
- FPGA-specific config.v files may exist in fpga subdirectories — modify those, not `rtl/config.v`.
- `config.v` `PROG_FPGA_PATH` must use forward slashes.
- `defines.v` is `include`d everywhere; `config.v` is `include`d by `defines.v`.
- The `tb/tools/` and `syn/` dirs are gitignored.
