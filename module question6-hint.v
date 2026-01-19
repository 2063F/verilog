module question6(
    input wire clk,
    input wire reset,
    input wire serial_in,        // 1ビットずつ入ってくるデータ
    input wire shift_enable,     // 1のときシフト動作
    output reg [7:0] parallel_out // 8ビットまとめて出力
);
    always @(posedge clk) begin
        if (reset) begin
            // リセット時は全ビットを0にする
            parallel_out <= 8'b00000000;
        end else if (shift_enable) begin
            // 右シフト: 
            // - serial_inを最上位ビット[7]に入れる
            // - [7:1]の内容を[6:0]に移動
            parallel_out <= {serial_in[7] , parallel_out >>1};
        end
        // shift_enable=0のときは何もしない（値を保持）
    end
endmodule