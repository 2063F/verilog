module VGA_counter(
    input wire clk,
    output reg [10:0] hcount,
    input wire reset,
    output reg [9:0] vcount,
    output reg h_visible_area,
    output reg h_front_porch,
    output reg h_sync_pulse,
    output reg h_back_porch,
    output reg v_visible_area,
    output reg v_front_porch,
    output reg v_sync_pulse,
    output reg v_back_porch,
    output reg display_on
);
    always @(posedge clk) begin
        if (reset == 1) begin
            hcount <= 0;
        end else begin
            hcount <= hcount + 11'd0001;
        end
        if (hcount == 11'd1056) begin
            vcount <= vcount + 11'd0001;
        end
        h_visible_area <= (hcount >= 11'd000 && hcount <= 11'd800);
        h_front_porch <= (hcount >= 11'd800 && hcount <= 11'd840);
        h_sync_pulse <= (hcount >= 11'd840 && hcount <= 11'd968);
        h_back_porch <= (hcount >= 11'd968 && hcount <= 11'd1056);
        if (reset == 1) begin
            vcount <= 0;
        end
        if (vcount == 10'd0628) begin
            vcount <= 0;
        end
        v_visible_area <= (vcount >= 10'd000 && vcount <= 10'd0600);
        v_front_porch <= (vcount >= 10'd0600 && vcount <= 10'd0601);
        v_sync_pulse <= (vcount >= 10'd0601 && vcount <= 10'd0605);
        v_back_porch <= (vcount >= 10'd0605 && vcount <= 10'd0628);
if (vcount < 11'd800 && vcount < 10'd600) begin
display_on <= 1;
end else begin
display_on <= 0;
end
end
endmodule
    