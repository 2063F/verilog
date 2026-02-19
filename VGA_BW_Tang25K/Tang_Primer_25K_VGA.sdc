//=====================================
// Tang Primer 25K SDC制約ファイル
//=====================================

// 入力クロック（50MHz）の定義
// 周期 = 1/50MHz = 20ns
create_clock -name clk -period 20 -waveform {0 10} [get_ports {clk}]
