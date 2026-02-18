//=====================================
// Tang Primer 25K SDC制約ファイル
// PLL使用時のタイミング制約
//=====================================

// 入力クロック（27MHz）の定義
// 周期 = 1/27MHz = 37.037ns
create_clock -name clk -period 37.037 -waveform {0 18.518} [get_ports {clk}]

// クロックの不確実性（スキュー）を設定
set_clock_uncertainty 0.5 [get_clocks clk]
