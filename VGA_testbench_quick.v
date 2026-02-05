<<<<<<< HEAD
// VGAモジュールの超軽量テストベンチ
// 最小限の動作確認用（VCDファイルが非常に小さい）
`timescale 1ns/1ps

module VGA_testbench_quick;

    reg clk;
    reg reset;
    wire hsync;
    wire vsync;
    wire video;

    // クロック生成（25MHz = 40ns周期）
    initial begin
        clk = 0;
        forever #20 clk = ~clk;  // 40ns周期 = 25MHz
    end

    // VGAモジュールのインスタンス化
    VGA_BW_simple uut (
        .clk_25mhz(clk),
        .reset(reset),
        .hsync(hsync),
        .vsync(vsync),
        .video(video)
    );

    // テストシーケンス
    initial begin
        // 波形ダンプ（必要最小限の信号のみ）
        $dumpfile("vga_test_quick.vcd");
        $dumpvars(1, VGA_testbench_quick);
        $dumpvars(0, VGA_testbench_quick.uut.h_count);
        $dumpvars(0, VGA_testbench_quick.uut.v_count);

        // リセット
        reset = 1;
        #200;
        reset = 0;

        // 2ライン分のみ実行（約32μs × 2 = 64μs）
        // HSYNCの基本動作確認用
        #65_000;  // 65μs（超軽量！）

        $display("クイックテスト完了");
        $display("シミュレーション時間: 65us（約2ライン分）");
        $display("h_count範囲: 0-799が確認できればOK");
        $display("hsync動作: h_count=656-751でhsync=1を確認");
        $finish;
    end

endmodule
=======
// VGAモジュールの超軽量テストベンチ
// 最小限の動作確認用（VCDファイルが非常に小さい）
`timescale 1ns/1ps

module VGA_testbench_quick;

    reg clk;
    reg reset;
    wire hsync;
    wire vsync;
    wire video;

    // クロック生成（25MHz = 40ns周期）
    initial begin
        clk = 0;
        forever #20 clk = ~clk;  // 40ns周期 = 25MHz
    end

    // VGAモジュールのインスタンス化
    VGA_BW_simple uut (
        .clk_25mhz(clk),
        .reset(reset),
        .hsync(hsync),
        .vsync(vsync),
        .video(video)
    );

    // テストシーケンス
    initial begin
        // 波形ダンプ（必要最小限の信号のみ）
        $dumpfile("vga_test_quick.vcd");
        $dumpvars(1, VGA_testbench_quick);
        $dumpvars(0, VGA_testbench_quick.uut.h_count);
        $dumpvars(0, VGA_testbench_quick.uut.v_count);

        // リセット
        reset = 1;
        #200;
        reset = 0;

        // 2ライン分のみ実行（約32μs × 2 = 64μs）
        // HSYNCの基本動作確認用
        #65_000;  // 65μs（超軽量！）

        $display("クイックテスト完了");
        $display("シミュレーション時間: 65us（約2ライン分）");
        $display("h_count範囲: 0-799が確認できればOK");
        $display("hsync動作: h_count=656-751でhsync=1を確認");
        $finish;
    end

endmodule
>>>>>>> 9b86ef5252bc81feb1d19c35b1a9342121c0b85e
