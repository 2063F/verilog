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
        // 波形ダンプ
        $dumpfile("vga_test.vcd");
        $dumpvars(0, VGA_testbench);

        // リセット
        reset = 1;
        #200;
        reset = 0;

        // 数フレーム実行（約33ms × 3フレーム = 100ms）
        #100_000_000;

        $display("テスト完了");
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
