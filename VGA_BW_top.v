// トップモジュール（白黒VGA）
// FPGAボードに実装する最上位モジュール
module VGA_BW_top(
    input wire clk,            // FPGAのクロック（50MHz など）
    input wire reset_btn,      // リセットボタン
    output wire vga_hsync,     // VGA水平同期
    output wire vga_vsync,     // VGA垂直同期
    output wire vga_r,         // VGA赤信号（白黒用）
    output wire vga_g,         // VGA緑信号（白黒用）
    output wire vga_b          // VGA青信号（白黒用）
);

    // クロック分周器（50MHz → 25MHz の例）
    wire clk_25mhz;
    clock_divider #(
        .DIVISOR(2)  // 50MHz → 25MHz
    ) clk_div (
        .clk_in(clk),
        .reset(reset_btn),
        .clk_out(clk_25mhz)
    );

    // VGA信号生成
    wire video_signal;
    
    VGA_BW_simple vga_core (
        .clk_25mhz(clk_25mhz),
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
// トップモジュール（白黒VGA）
// FPGAボードに実装する最上位モジュール
module VGA_BW_top(
    input wire clk,            // FPGAのクロック（50MHz など）
    input wire reset_btn,      // リセットボタン
    output wire vga_hsync,     // VGA水平同期
    output wire vga_vsync,     // VGA垂直同期
    output wire vga_r,         // VGA赤信号（白黒用）
    output wire vga_g,         // VGA緑信号（白黒用）
    output wire vga_b          // VGA青信号（白黒用）
);

    // クロック分周器（50MHz → 25MHz の例）
    wire clk_25mhz;
    clock_divider #(
        .DIVISOR(2)  // 50MHz → 25MHz
    ) clk_div (
        .clk_in(clk),
        .reset(reset_btn),
        .clk_out(clk_25mhz)
    );

    // VGA信号生成
    wire video_signal;
    
    VGA_BW_simple vga_core (
        .clk_25mhz(clk_25mhz),
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