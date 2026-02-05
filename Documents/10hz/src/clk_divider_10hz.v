module clk_divider_10hz(
    input clk_in,      // 27MHz入力
    output clk_10hz    // 10Hz出力
);

reg [21:0] counter;
reg clk_out;

assign clk_10hz = clk_out;

always @(posedge clk_in) begin
    if (counter == 22'd1349999) begin
        counter <= 22'd0;
        clk_out <= ~clk_out;
    end else begin
        counter <= counter + 1;
    end
end

endmodule