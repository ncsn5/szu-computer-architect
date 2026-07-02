# Coremark跑分
**系统配置**  
- 单周期乘法
- DIV_MODE "HF_DIV"
- RV32IM
- GCC12.2.0

```
2K performance run parameters for coremark.
CoreMark Size    : 666
Total ticks      : 698701493
Total time (secs): 25.87801
Iterations/Sec   : 77.28569
Iterations       : 2000
Compiler version : GCC12.2.0
Compiler flags   : -O2 -fno-common -funroll-loops -finline-functions --param max-inline-insns-auto=20 -falign-functions=4 -falign-jumps=4 -falign-loops=4
Memory location  : STATIC
seedcrc          : 0xe9f5
[0]crclist       : 0xe714
[0]crcmatrix     : 0x1fd7
[0]crcstate      : 0x8e3a
[0]crcfinal      : 0x4983
Correct operation validated. See readme.txt for run and reporting rules.
CoreMark 1.0 : 77.28569 / GCC12.2.0 -O2 -fno-common -funroll-loops -finline-functions --param max-inline-insns-auto=20 -falign-functions=4 -falign-jumps=4 -falign-loops=4 / STATIC
SparrowRV Coremark = 2.86243 CoreMark/MHz
```
