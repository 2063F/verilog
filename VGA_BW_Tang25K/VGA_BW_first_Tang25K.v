// Tang Primer 25K 用 VGA トップモジュール
// クロック: 50MHz (GW5A-LV25MG121 オンボード)
module VGA_BW_top(
    input wire clk,            // 50MHz クロック (Pin E2)
    input wire reset_btn,      // リセットボタン (Pin K10, 押すと0)
    output wire vga_hsync,     // VGA水平同期
    output wire vga_vsync,     // VGA垂直同期
    output wire vga_r,         // VGA赤信号
    output wire vga_g,         // VGA緑信号
    output wire vga_b,         // VGA青信号
    output wire led            // 動作確認用LED (Pin D10)
);

    // リセット信号を反転 (プルアップ環境でボタンを押すと0[リセット])
    wire sys_reset = !reset_btn; 

    // クロック
    // VGA 640x480には25MHz~25.175MHzが必要
    // 50MHzを2分周して25MHzを生成
    reg clk_25mhz = 0;
    always @(posedge clk) clk_25mhz <= ~clk_25mhz;

    // ハートビート (50MHz動作確認)
    reg [24:0] heartbeat_cnt = 0;
    always @(posedge clk) heartbeat_cnt <= heartbeat_cnt + 1'b1;
    assign led = heartbeat_cnt[24]; // 約0.6秒周期で点滅

    // VGA信号生成
    wire video_signal;
    
    VGA_BW_simple vga_core (
        .clk_25mhz(clk_25mhz),
        .reset(sys_reset),
        .hsync(vga_hsync),
        .vsync(vga_vsync),
        .video(video_signal)
    );

    // 映像信号接続
    assign vga_r = video_signal;
    assign vga_g = video_signal;
    assign vga_b = video_signal;

endmodule
