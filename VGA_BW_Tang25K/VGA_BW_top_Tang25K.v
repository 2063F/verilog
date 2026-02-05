// Tang Primer 25K 専用 トップモジュール（白黒VGA）
// クロック: 27MHz (Tang Primer 25Kの水晶振動子)
module VGA_BW_top(
    input wire clk,            // 27MHz クロック
    input wire reset_btn,      // リセットボタン
    output wire vga_hsync,     // VGA水平同期
    output wire vga_vsync,     // VGA垂直同期
    output wire vga_r,         // VGA赤信号（白黒用）
    output wire vga_g,         // VGA緑信号（白黒用）
    output wire vga_b          // VGA青信号（白黒用）
);

    // Tang Primer 25Kは27MHzクロックを持っています
    // VGAには25MHzが必要なので、27MHzをそのまま使うと
    // 若干速くなりますが、多くのモニターで動作します
    
    // オプション1: 27MHzをそのまま使用（簡単だが若干仕様外）
    wire clk_vga;
    assign clk_vga = clk;  // 27MHzをそのまま使用
    
    // オプション2: PLLを使って正確に25.175MHzを生成（推奨）
    // Gowin PLLを使用する場合は、Gowin EDAのIPコアジェネレータで
    // PLLモジュールを生成し、ここでインスタンス化してください
    /*
    Gowin_rPLL pll_inst (
        .clkout(clk_vga),   // 25.175MHz
        .clkin(clk)         // 27MHz
    );
    */

    // VGA信号生成
    wire video_signal;
    
    VGA_BW_simple vga_core (
        .clk_25mhz(clk_vga),      // 27MHz（または25.175MHz）
        .reset(reset_btn),
        .hsync(vga_hsync),
        .vsync(vga_vsync),
        .video(video_signal)
    );

    // 白黒映像信号を3色全てに接続
    assign vga_r = video_signal;
    assign vga_g = video_signal;
    assign vga_b = video_signal;

endmodule
