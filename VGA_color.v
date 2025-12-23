module VGA_color(
    input wire clk,
    input wire [10:0] hcount,
    input wire [9:0] vcount,
    input wire display_on,
    output reg [1:0] r,
    output reg [1:0] g,
    output reg [1:0] b
);
if (display_on == 1) begin
always @(posedge clk) begin
    r <= 0;
    g <= 0;
    b <= 0;
    case(hcount [10:5])
        0: begin r <= 0 ; g <= 0 ; b <= 0; end
        1: begin r <= 1 ; g <= 0 ; b <= 0; end
        2: begin r <= 2 ; g <= 0 ; b <= 0; end
        3: begin r <= 3 ; g <= 0 ; b <= 0; end
        4: begin g <= 1 ; r <= 0 ; b <= 0; end
        5: begin g <= 2 ; r <= 0 ; b <= 0; end
        6: begin g <= 3 ; r <= 0 ; b <= 0; end
        7: begin b <= 1 ; r <= 0 ; g <= 0; end
        8: begin b <= 2 ; r <= 0 ; g <= 0; end
        9: begin b <= 3 ; r <= 0 ; g <= 0; end
        default: begin 
            r <= 3 ; g <= 3 ; b <= 3 ; 
        end
    endcase
end else begin
    r <= 0;
    g <= 0;
    b <= 0;
end
end
endmodule

