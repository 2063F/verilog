module VGA_color(
    input wire clk,
    input wire [10:0] hcount,
    input wire [9:0] vcount,
    output reg [1:0] 
    h_r,
    output reg [1:0] h_g,
    output reg [1:0] h_b,
    output reg [1:0] v_r,
    output reg [1:0] v_g,
    output reg [1:0] v_b
);
always @(posedge clk) begin
    h_r <= 0;
    h_g <= 0;
    h_b <= 0;

    case(hcount / 32)
        0: r <= 0;
        1: r <= 1;
        2: r <= 2;
        3: r <= 3;
        4: g <= 0;
        5: g <= 1;
        6: g <= 2;
        7: g <= 3;
        8: b <= 0;
        9: b <= 1;
        10: b <= 2;
        11: b <= 3;
        default: begin 
            r <= 3; g <= 3; b <= 3; 
        end
    endcase
end
endmodule

