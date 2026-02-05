// 白黒VGA出力モジュール（640x480@60Hz）
// 25MHz クロックが必要
module VGA_BW_simple(
    input wire clk_25mhz,      // 25MHz クロック
    input wire reset,          // リセット信号
    output reg hsync,          // 水平同期信号
    output reg vsync,          // 垂直同期信号
    output reg video           // 白黒映像信号（1=白、0=黒）
);

    // VGAタイミングパラメータ（640x480@60Hz）
    // 水平方向
    parameter H_DISPLAY     = 640;  // 表示領域
    parameter H_FRONT_PORCH = 16;   // フロントポーチ
    parameter H_SYNC_PULSE  = 96;   // 同期パルス
    parameter H_BACK_PORCH  = 48;   // バックポーチ 
    parameter H_TOTAL       = 800;  // 合計
    
    // 垂直方向
    parameter V_DISPLAY     = 480;  // 表示領域
    parameter V_FRONT_PORCH = 10;   // フロントポーチ
    parameter V_SYNC_PULSE  = 2;    // 同期パルス
    parameter V_BACK_PORCH  = 33;   // バックポーチ
    parameter V_TOTAL       = 525;  // 合計

    // カウンタ
    reg [9:0] h_count;  // 水平カウンタ（0-799）
    reg [9:0] v_count;  // 垂直カウンタ（0-524）

    // 水平カウンタ
    always @(posedge clk_25mhz or posedge reset) begin
        if (reset) begin
            h_count <= 0;
        end else begin
            if (h_count == H_TOTAL - 1)
                h_count <= 0;
            else
                h_count <= h_count + 1;
        end
    end

    // 垂直カウンタ
    always @(posedge clk_25mhz or posedge reset) begin
        if (reset) begin
            v_count <= 0;
        end else begin
            if (h_count == H_TOTAL - 1) begin
                if (v_count == V_TOTAL - 1)
                    v_count <= 0;
                else
                    v_count <= v_count + 1;
            end
        end
    end

    // 同期信号生成
    always @(posedge clk_25mhz) begin
        // HSYNC: 負極性
        hsync <= (h_count >= (H_DISPLAY + H_FRONT_PORCH)) && 
                 (h_count < (H_DISPLAY + H_FRONT_PORCH + H_SYNC_PULSE));
        
        // VSYNC: 負極性
        vsync <= (v_count >= (V_DISPLAY + V_FRONT_PORCH)) && 
                 (v_count < (V_DISPLAY + V_FRONT_PORCH + V_SYNC_PULSE));
    end

    // 映像信号生成（テストパターン）
    wire display_on;
    assign display_on = (h_count < H_DISPLAY) && (v_count < V_DISPLAY);

    always @(posedge clk_25mhz) begin
        if (display_on) begin
            // テストパターン：市松模様
            video <= h_count[5] ^ v_count[5];
            
            // 他のパターン例：
            // video <= 1;  // 全画面白
            // video <= (h_count < 320);  // 左半分白、右半分黒
            // video <= (v_count < 240);  // 上半分白、下半分黒
        end else begin
            video <= 0;  // ブランキング期間は黒
        end
    end

endmodule
