module problem1(
  input       [7:0] i_p0,
  input       [7:0] i_p1,
  input       [7:0] i_p2,
  output wire [7:0] o_p
);

  wire [7:0] w_p;

  assign w_p = i_p0 & i_p1;
  assign o_p = w_p | i_p2;

endmodule