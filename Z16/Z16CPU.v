module Z16CPU(
    input wire i_clk,
    input wire i_rst
);

//プログラムカウンタ
reg  [15:0] r_pc;
wire [15:0] w_instr;
wire [15:0] w_rd_addr; //RDアドレス信号線
wire [15:0] w_rs1_addr;//RS1アドレス信号線
wire [15:0] w_imm;     //即値信号線
wire        w_rd_wen;  //レジスタ書き込み有効化信号線
wire        w_mem_wen; //メモリ書き込み有効化信号線
wire [3:0]  w_alu_ctrl;//ALU演算制御信号線

always @(posedge i_clk) begin
    if(i_rst) begin
        //リセット
        r_pc <= 16'h0000;
    end else begin
        r_pc <= r_pc + 16'h0002;
    end 
end

//命令メモリ
Z16InstrMem InstrMem(
    .i_addr      (r_pc   ),//プログラムカウンタを命令メモリに接続
    .o_instr     (w_instr)
);

Z16Decoder Decoder(
    .i_instr    (w_instr    ),
    .

//データメモリ
Z16DataMem DataMem(
    .i_clk  (),
    .i_addr (),
    .i_wen  (),
    .i_data (),
    .o_data ()
);

endmodule