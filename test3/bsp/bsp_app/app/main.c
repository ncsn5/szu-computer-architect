#include "system.h"

//HelloWord，间隔1s循环打印
int main()
{
    init_uart0_printf(115200,0);
    while(1)
    {
        printf("%s", "Hello world SparrowRV\n");
        delay_mtime_us(1000000);
    }
}
