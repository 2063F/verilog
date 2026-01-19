// blink_tb.sv
// 2024/02/05 by marsee

`timescale 1ns / 1ns

module blink_tb;
    logic clk;
    logic led;
    
    task gen_clk;
        forever begin
            #10 clk = ~clk; // 10 単位時間ごとに反転
        end
    endtask
    
    initial begin
        #10 fork
            gen_clk;
        join_none
    end

    initial begin // 一回のみ順番に実行される
        clk <= 1'b0;
        #510000000;
        $finish;
    end
    
    blink blink_inst(
        .clk(clk),
        .led(led)
    );

    // シミュレーション時に blink.vcd を出力する
    initial begin
        $dumpfile("blink.vcd");
        $dumpvars (0, blink_inst);
        #1;
    end
endmodule