//=====================================
// Tang Primer 25K SDC制約ファイル
// タイミング制約の定義
//=====================================

// 27MHzシステムクロックの定義
// 周期 = 1/27MHz = 37.037ns
create_clock -name clk -period 37.037 -waveform {0 18.518} [get_ports {clk}]

// クロックの不確実性（スキュー）を設定
set_clock_uncertainty 0.5 [get_clocks {clk}]

// 入力/出力遅延の設定（必要に応じて調整）
set_input_delay -clock clk 5 [get_ports {reset_btn}]
set_output_delay -clock clk 5 [get_ports {vga_*}]
