module question6(
    input wire clk ,
    input wire reset ,
    input wire serial_in ,
    input wire shift_enable ,
    output wire parallel_out ,
    wire [7:0] a
)
if (shift_enable = 1) begin
always @(posedge i_clk) begin
     a =
end