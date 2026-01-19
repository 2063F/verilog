module problem4(
    input [15:0] i_rst,
    input [15:0] i_clk,
    output reg [15:0] o_p
);
always @(posedge i_clk) begin
      if (i_rst) begin
        o_p <= 16'h0000;
      end else begin
        o_p <= o_p + 16'h0001;
      end
    end

endmodule