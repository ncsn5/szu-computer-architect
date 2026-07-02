# 说明
`/fpga/`目录存放了可以直接综合并烧录的FPGA工程，都是经过上板验证的。默认编译好的IAP程序在`/bsp/`目录下，用工具箱转换成`inst.txt`即可使用。  
若需要烧录其他程序，按照[快速开始](/doc/使用手册/快速开始.md)的步骤完成程序编译，生成`inst.txt`，再使用FPGA厂商软件完成综合步骤。  
若想详细了解小麻雀处理器，可参阅[处理器文档导航页](/doc/文档导航.md)  
如果使用其他厂商的FPGA并自建工程，需要手动将`/rtl/config.v`的`PROG_FPGA_PATH`宏定义内容改为`inst.txt`的文件路径。  
如果使用高云、AMD等厂商的FPGA，仅需修改示例工程的FPGA器件型号和IO管脚约束，即可移植到其他硬件平台。`config.v`的`PROG_FPGA_PATH`已通过相对寻址的方式指向了`/tb/inst.txt`，使用示例工程无需修改此项，直接使用`工具箱.bat`生成`inst.txt`即可。  

## 高云GOWIN
目前高云`V1.9.9Beta-4 Education`教育版IDE有奇奇怪怪的bug，导致综合报错，所以只能安装旧教育版或最新商业版。  

旧教育版：
[v1.9.8.11下载链接](https://cdn.gowinsemi.com.cn/Gowin_V1.9.8.11_Education_win.zip)  
开箱即用，无需lic  

最新商业版
[官方下载链接](https://www.gowinsemi.com.cn/faq.aspx)  
安装后需要输入lic。可以自行申请本地lic(Local License File)，也可以使用[Sipeed的lic服务器](http://gowinlic.sipeed.com/)(Floating License Server)  

### gowin_tang_nano_20k (优先支持)
高云GW2AR-LV18QN88C8/I7，云源软件v1.9.8.11教育版  
使用[Sipeed Tang nano 20K开发板](https://wiki.sipeed.com/hardware/zh/tang/tang-nano-20k/nano-20k.html)，时序/IO约束与此硬件匹配。  
IO分配如下：  
|IO编号|引脚名称|功能|
|---|---|---|
|4|clk|时钟输入，连接27MHz晶振|
|16|hard_rst_n|低电平复位，连接LED1|
|15|core_active|活动指示，连接LED0|
|69|fpioa\[0\]|printf>uart0_tx输出，连接USB串口|
|27|JTAG_TDI|JTAG调试接口|
|28|JTAG_TDO|JTAG调试接口|
|29|JTAG_TCK|JTAG调试接口|
|30|JTAG_TMS|JTAG调试接口|
|83|sd_clk|SD卡的SDIO_CLK|
|82|sd_cmd|SD卡的SDIO_CMD|
|84|sd_dat\[0\]|SD卡的SDIO_D0|
|85|sd_dat\[1\]|SD卡的SDIO_D1|
|80|sd_dat\[2\]|SD卡的SDIO_D2|
|81|sd_dat\[3\]|SD卡的SDIO_D3|

综合报告  
|项目|数据|
|-|-|
|Logic|7094(35%)|
|Reg|3096(20%)|
|CLS|5343(52%)|
|BSRAM|24+1(55%)|
|Fmax|48.372MHz|


### gowin_tang_primer_20k
高云GW2A-LV18PG256C8/I7，云源软件v1.9.8.09教育版  
使用[Sipeed Tang Primer 20K开发板](https://wiki.sipeed.com/hardware/zh/tang/tang-primer-20k/primer-20k.html)，时序/IO约束与此硬件匹配。  
IO分配如下：  
|IO编号|引脚名称|功能|
|---|---|---|
|H11|clk|时钟输入，连接27MHz晶振|
|T10|hard_rst_n|低电平复位，连接S0按键|
|N16|core_active|活动指示，连接LED2|
|M11|fpioa\[0\]|printf>uart0_tx输出，连接USB串口|
|N10|sd_clk|SD卡的SDIO_CLK|
|R14|sd_cmd|SD卡的SDIO_CMD|
|M8|sd_dat\[0\]|SD卡的SDIO_D0|
|M7|sd_dat\[1\]|SD卡的SDIO_D1|
|M10|sd_dat\[2\]|SD卡的SDIO_D2|
|N11|sd_dat\[3\]|SD卡的SDIO_D3|
综合结果与nano 20k基本相同  

## 安路Anlogic
必须打开宏定义`IRAM_SPRAM_W4B`  
### anlogic_sparkroad_v
安路EG4S20BG256，TD 5.0.5版本  
使用[SparkRoad-V开发板](https://gitee.com/verimake/SparkRoad-V)，时序/IO约束与此硬件匹配。  
目前TD不支持指定include路径，因此`config.v`、`define.v`已经复制到了工程目录，修改`rtl/config.v`不能起到改变配置的作用，需要修改fpga工程目录的`fpga/anlogic/config.v`。希望TD日后改进。  
需要修改`config.v`的`CPU_CLOCK_HZ`为`24_000_000`，因为板载晶振是24MHz。安路工程目录的`config.v`默认已修改。  
需要修改`config.v`的`IRAM_SPRAM_W4B`状态为打开，因为TD不支持推断字节写使能RAM。安路工程目录的`config.v`默认已修改。  

综合报告  
|项目|数据|
|-|-|
|lut|8563(43.69%)|
|reg|3175(16.20%)|
|bram|46(71.88%)|
|dsp|4(13.79%)|
|Fmax|30MHz|

## AMD/赛灵思
Vivado功能全面，就是综合太慢了  
### amd_bcjx_k7_r3
AMD XC7325T-2FFG676，Vivado 2019.2  
使用小熊猫店里的博宸精芯Kintex-7 Eco R3开发板，时序/IO约束与此硬件匹配。  
需要修改`config.v`的`CPU_CLOCK_HZ`为`50_000_000`，因为板载晶振是50MHz  
IO分配如下：  
|IO编号|引脚名称|功能|
|---|---|---|
|G22|clk|时钟输入，连接50MHz晶振|
|D26|hard_rst_n|低电平复位，连接按键KEY1|
|A23|core_active|活动指示，连接LED D1-1|
|A17|fpioa\[0\]|printf>uart0_tx输出，连接USB串口|
|H14|JTAG_TDI|JTAG调试接口|
|H11|JTAG_TDO|JTAG调试接口|
|G14|JTAG_TCK|JTAG调试接口|
|G12|JTAG_TMS|JTAG调试接口|
|E23|sd_clk|SD卡的SDIO_CLK|
|G24|sd_cmd|SD卡的SDIO_CMD|
|F23|sd_dat\[0\]|SD卡的SDIO_D0|
|F22|sd_dat\[1\]|SD卡的SDIO_D1|
|F25|sd_dat\[2\]|SD卡的SDIO_D2|
|F24|sd_dat\[3\]|SD卡的SDIO_D3|

综合报告  
|项目|数据|
|-|-|
|LUT|4612(2.26%)|
|FF|3102(0.76%)|
|BRAM|12.5(2.81%)|
|DSP|4(0.48%)|
|Fmax|63MHz|

## 紫光同创
软件挺好用的  
### pango_zdyz_pgl22g
PGL22G_6MBG324，Pango Design Suite 2022.2-SP1-Lite。  
正点原子`ATK-DFPGL22G`开发板。  
需要修改`config.v`的`CPU_CLOCK_HZ`为`50_000_000`，因为板载晶振是50MHz  
综合报告  
|项目|数据|
|-|-|
|CLMA|1607(50%)|
|CLMS|544(50%)|
|DRM|24.5(52%)|
|APM|4(14%)|
|Fmax|55.1MHz|

## Intel
不好用，一边去

## Lattice
Lattice的产品线和IDE过于混乱，这里仅针对ECP5系列的Diamond  
### lattice_ECP5U_25F
LFE5U-25F-6B256C，Lattice Diamond Vsrsion 3.12.0.240.2(Synplify Pro 2020.03L-SP1)  
自制开发板  
综合报告  
|项目|数据|
|-|-|
|SLICE|4292(35%)|
|EBR|25(44%)|
|MULT18|6(21%)|
|ALU54|3(21%)|
|Fmax|47MHz|
