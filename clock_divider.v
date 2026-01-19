// クロック分周器
// FPGAの内部クロックを25MHzに分周
module clock_divider(
    input wire clk_in,      // 入力クロック（例：50MHz）
    input wire reset,
    output reg clk_out      // 出力クロック（25MHz）
);

    // 50MHz → 25MHz の場合は2分周
    // 100MHz → 25MHz の場合は4分周
    // FPGAのクロック周波数に応じて調整してください
    
    parameter DIVISOR = 2;  // 分周比（2 = 50MHz→25MHz）
    
    reg [$clog2(DIVISOR)-1:0] counter;

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            counter <= 0;
            clk_out <= 0;
        end else begin
            if (counter == DIVISOR - 1) begin
                counter <= 0;
                clk_out <= ~clk_out;
            end else begin
                counter <= counter + 1;
            end
        end
    end

endmodule
