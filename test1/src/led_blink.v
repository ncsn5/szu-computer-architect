module led_blink(
    input wire clk,        // 系统时钟27MHz
    output reg led         // 板载LED输出
);

// 计数最大值：27MHz时钟，0.5s翻转一次 = 13500000
parameter CNT_MAX = 27'd13500000;
reg [26:0] cnt;

always @(posedge clk) begin
    if(cnt == CNT_MAX) begin
        cnt <= 27'd0;
        led <= ~led;
    end else begin
        cnt <= cnt + 1'b1;
    end
end

endmodule