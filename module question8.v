module question8(
    input wire a,
    input wire b,
    input wire cin,
    output wire sum,
    output wire cout
);
assign sum <= a ^ b ^ cin;
assign count = (a&b) | (b&sim) | (a&cin);
endmodule