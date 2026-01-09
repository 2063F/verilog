module top (
    input wire reset;
    output wire vga_vt;
    output wire vga_vh;
    output wire[1:0] r;
    output wire[1:0] g;
    output wire[1:0] b;
    wire pixel_clk;
    wire pull_clk;
    wire [10:0] hcount;
    wire [9:0] vcount;
    wire h_visible_area;
    wire h_front_porch;
    wire h_sync_pulse;
    wire h_back_porch;
    wire v_visible_area;
    wire v_front_porch;
    wire v_sync_pulse;
    wire v_back_porch;
    wire display_on;
    VGA_counter vga_counter (
        .clk(pull_clk),
        .reset(reset),
        .hcount(hcount),
        .vcount(vcount),
        .h_visible_area(h_visible_area),
        .h_front_porch(h_front_porch),
        .h_sync_pulse(h_sync_pulse),
        .h_back_porch(h_back_porch),
        .v_visible_area(v_visible_area),
        .v_front_porch(v_front_porch),
        .v_sync_pulse(v_sync_pulse),
        .v_back_porch(v_back_porch),
        .display_on(display_on)
    );

    VGA_color vga_color (
        .clk(pixel_clk),
        .hcount(hcount),
        .vcount(vcount),
        .display_on(display_on),
        .r(r),
        .g(g),
        .b(b)
    );
    
);
    
endmodule