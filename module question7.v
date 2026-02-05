module question7(
    input wire clk,
    input wire reset,
    input wire [2:0] timer,
    output wire green,
    output wire yellow,
    output wire red
);
always @(posedge clk) begin
    if (timer == 3'b100) begin
        timer <= 3'b000;
    end else begin
        timer <= timer + 1;
end
    case(timer)
    3'b000 | 3'b001 : green <= 1 yellow <= 0 red <= 0;
    3'b010 green <= 0 : yellow <=1 red <= 0;
    default : green <=0 yellow <= 0 red <=1;
    endcase
end
endmodule
