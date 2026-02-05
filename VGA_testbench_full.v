<<<<<<< HEAD
// VGAモジュールの完全テストベンチ（1フレーム分）
// 完全な動作確認用（VCDファイルは大きくなります）
`timescale 1ns/1ps

module VGA_testbench_full;

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
        // 波形ダンプ
        $dumpfile("vga_test_full.vcd");
        $dumpvars(1, VGA_testbench_full);
        $dumpvars(0, VGA_testbench_full.uut.h_count);
        $dumpvars(0, VGA_testbench_full.uut.v_count);
        $dumpvars(0, VGA_testbench_full.uut.display_on);

        // リセット
        reset = 1;
        #200;
        reset = 0;

        // 1フレーム + 少し分実行（約16.68ms + α）
        #17_000_000;  // 17ms

        $display("テスト完了");
        $display("シミュレーション時間: 17ms（約1フレーム分）");
        $finish;
    end

    // フレーム完了検出
    reg [9:0] last_v_count;
    always @(posedge clk) begin
        last_v_count <= uut.v_count;
        if (last_v_count == 524 && uut.v_count == 0) begin
            $display("フレーム完了: 時刻=%t", $time);
        end
    end

endmodule
=======
// VGAモジュールの完全テストベンチ（1フレーム分）
// 完全な動作確認用（VCDファイルは大きくなります）
`timescale 1ns/1ps

module VGA_testbench_full;

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
        // 波形ダンプ
        $dumpfile("vga_test_full.vcd");
        $dumpvars(1, VGA_testbench_full);
        $dumpvars(0, VGA_testbench_full.uut.h_count);
        $dumpvars(0, VGA_testbench_full.uut.v_count);
        $dumpvars(0, VGA_testbench_full.uut.display_on);

        // リセット
        reset = 1;
        #200;
        reset = 0;

        // 1フレーム + 少し分実行（約16.68ms + α）
        #17_000_000;  // 17ms

        $display("テスト完了");
        $display("シミュレーション時間: 17ms（約1フレーム分）");
        $finish;
    end

    // フレーム完了検出
    reg [9:0] last_v_count;
    always @(posedge clk) begin
        last_v_count <= uut.v_count;
        if (last_v_count == 524 && uut.v_count == 0) begin
            $display("フレーム完了: 時刻=%t", $time);
        end
    end

endmodule
>>>>>>> 9b86ef5252bc81feb1d19c35b1a9342121c0b85e
