module VGA_color(
    input wire clk,
    input wire [10:0] hcount,
    input wire [9:0] vcount,
    output reg [1:0] r,
    output reg [1:0] g,
    output reg [1:0] b
);
always @(posedge clk) begin
    // まずデフォルト値を設定して、前の色が残らないようにします（ラッチ防止）
    r <= 0;
    g <= 0;
    b <= 0;

    case(vcount / 32)
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
            // 余白（黒）
            r <= 0; g <= 0; b <= 0; 
        end
    endcase
end
endmodule