module problem5
input [15:0] i_data_0 ,
input [15:0] i_data_1 ,
input [15:0] i_data_2 ,
input [15:0] i_data_3 ,
input [1:0] i_ctrl ,
input i_clk,
output reg [15:0] o_data ,
always @(posedge i_clk)begin
    case(i_ctrl)
    2b'0 : o_data <= i_data_0;
    2b'1 : o_data <= i_data_1;
    2b'2 : o_data <= i_data_2;
    2b'3 : o_data <= i_data_3;
    endcase
end
endmodule
