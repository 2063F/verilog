module VGA_counter(
    input wire clk,
    output reg [5:0] hcount,
    input wire reset,
    output reg [3:0] vcount,
    output reg h_visible_area,
    output reg h_front_porch,
    output reg h_sync_pulse,
    output reg h_back_porch,
    output reg v_visible_area,
    output reg v_front_porch,
    output reg v_sync_pulse,
    output reg v_back_porch

);
    always @(posedge clk) begin
        if (reset == 1) begin
            hcount <= 0;
        end else begin
            hcount <= hcount + 5'd01;
        end
        if (hcount == 5'd264) begin
            vcount <= vcount + 5'd01;
        end
        h_visible_area <= (hcount >= 5'd00 && hcount <= 5'd40);
        h_front_porch <= (hcount >= 5'd40 && hcount <= 5'd41);
        h_sync_pulse <= (hcount >= 5'd41 && hcount <= 5'd47);
        h_back_porch <= (hcount >= 5'd47 && hcount <= 5'd53);
       
      end

 always @(posedge clk) begin
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

      end
endmodule
    