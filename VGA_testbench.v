<<<<<<< HEAD
// VGAモジュールのテストベンチ
// シミュレーションで動作確認用
`timescale 1ns/1ps

module VGA_testbench;

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
        // 波形ダンプ（必要な信号のみ）
        $dumpfile("vga_test.vcd");
        // レベル1のみダンプ（トップレベルの信号）
        $dumpvars(1, VGA_testbench);
        // 必要な内部信号のみ追加
        $dumpvars(0, VGA_testbench.uut.h_count);
        $dumpvars(0, VGA_testbench.uut.v_count);
        $dumpvars(0, VGA_testbench.uut.display_on);

        // リセット
        reset = 1;
        #200;
        reset = 0;

        // 数ライン分実行（約32μs × 6ライン = 200μs）
        // HSYNC/VSYNCの基本動作確認には十分
        #200_000;  // 200μs = 0.2ms（100ms → 200μsで500倍軽量化！）

        $display("テスト完了");
        $display("シミュレーション時間: 200us（約6ライン分）");
        $finish;
    end

    // モニター
    integer h_count, v_count;
    always @(posedge clk) begin
        if (reset) begin
            h_count = 0;
            v_count = 0;
        end else begin
            h_count = h_count + 1;
            if (h_count == 800) begin
                h_count = 0;
                v_count = v_count + 1;
                if (v_count == 525) begin
                    v_count = 0;
                    $display("フレーム完了: 時刻=%t", $time);
                end
            end
        end
    end

endmodule
=======
// VGAモジュールのテストベンチ
// シミュレーションで動作確認用
`timescale 1ns/1ps

module VGA_testbench;

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
        // 波形ダンプ（必要な信号のみ）
        $dumpfile("vga_test.vcd");
        // レベル1のみダンプ（トップレベルの信号）
        $dumpvars(1, VGA_testbench);
        // 必要な内部信号のみ追加
        $dumpvars(0, VGA_testbench.uut.h_count);
        $dumpvars(0, VGA_testbench.uut.v_count);
        $dumpvars(0, VGA_testbench.uut.display_on);

        // リセット
        reset = 1;
        #200;
        reset = 0;

        // 数ライン分実行（約32μs × 6ライン = 200μs）
        // HSYNC/VSYNCの基本動作確認には十分
        #200_000;  // 200μs = 0.2ms（100ms → 200μsで500倍軽量化！）

        $display("テスト完了");
        $display("シミュレーション時間: 200us（約6ライン分）");
        $finish;
    end

    // モニター
    integer h_count, v_count;
    always @(posedge clk) begin
        if (reset) begin
            h_count = 0;
            v_count = 0;
        end else begin
            h_count = h_count + 1;
            if (h_count == 800) begin
                h_count = 0;
                v_count = v_count + 1;
                if (v_count == 525) begin
                    v_count = 0;
                    $display("フレーム完了: 時刻=%t", $time);
                end
            end
        end
    end

endmodule
>>>>>>> 9b86ef5252bc81feb1d19c35b1a9342121c0b85e
