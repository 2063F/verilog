module problem5_tb;
reg [15:0] i_data_0 ;
reg [15:0] i_data_1 ;
reg [15:0] i_data_2 ;
reg [15:0] i_data_3 ;
reg [1:0] i_ctrl ;
reg i_clk ;
reg [15:0] o_data ,
initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0,DUT);
end
initial begin
    
end
problem DUT(
    .i_data_0 (i_data_0),
    .i_data_1 (i_data_1),
    .i_data_2 (i_data_2),
    .i_data_3 (i_data_3),
    .i_ctrl (i_ctrl),
    .i_clk (i_clk),
    .o_data (o_data)
);
always #1 begin
    i_clk <= ~i_clk;
end