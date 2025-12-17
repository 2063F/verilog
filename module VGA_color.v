module VGA_color(
    input wire clk,
    input wire [10:0] hcount,
    input wire [9:0] vcount,
    output reg [1:0] r,
    output reg [1:0] g,
    output reg [1:0] b
);
