module Z16DataMemory(
    input  wire          i_clk,  //クロック
    input  wire [15:0]   i_addr, //アドレス
    input  wire          i_wen,  //書き込み制御
    input  wire [15:0]   i_data, //書き込みデータ
    output wire [15:0]   o_data  //読み出しデータ
);

reg [15:0] mem[1023:0];

//Load
assign o_data = mem[i_addr[10:1]];

always @(posedge i_clk) begin
    //Store
    if(i_wen) begin
        mem[i_addr[10:1]] <= i_data;
    end
end
endmodule