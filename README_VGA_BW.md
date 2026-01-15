# 白黒VGAグラフィックボード 実装ガイド

## 📌 概要
FPGAとブレッドボードを使用して、白黒VGA出力（640x480@60Hz）を実現します。

---

## 🔧 必要な部品

### FPGA側
- FPGA開発ボード（50MHz以上のクロック推奨）
  - 例：Altera/Intel DE0, DE1, Cyclone II/IV/V
  - Xilinx Spartan, Artix シリーズ など
- USBプログラマ（ボード付属）

### ブレッドボード回路
- ブレッドボード × 1
- VGAコネクタ（メス） × 1
- 抵抗 270Ω × 3本（白黒の場合、1本でも可）
- ジャンパー線

### その他
- VGAケーブル
- VGAモニター（640x480対応）

---

## 🔌 配線図

```
【FPGA】              【ブレッドボード】         【VGAコネクタ】
                                               
HSYNC ピン ──────────────────────────────→ Pin 13 (HSYNC)
VSYNC ピン ──────────────────────────────→ Pin 14 (VSYNC)
VIDEO ピン ───┬─[270Ω]─────────────────→ Pin 1  (RED)
              ├─[270Ω]─────────────────→ Pin 2  (GREEN)  
              └─[270Ω]─────────────────→ Pin 3  (BLUE)
GND ──────────────────────────────────────→ Pin 5,6,7,8,10 (GND)
```

### VGAコネクタのピン配置
```
  5  4  3  2  1
   10 9  8  7  6
   15 14 13 12 11

Pin 1  = RED
Pin 2  = GREEN
Pin 3  = BLUE
Pin 5  = GND (RED)
Pin 6  = GND (RED)
Pin 7  = GND (GREEN)
Pin 8  = GND (BLUE)
Pin 10 = GND (SYNC)
Pin 13 = HSYNC
Pin 14 = VSYNC
```

---

## ⚙️ 実装手順

### 1. FPGAのクロック周波数を確認
お使いのFPGAボードのクロック周波数を確認してください。
- 50MHz の場合：`clock_divider.v` の `DIVISOR = 2`
- 100MHz の場合：`clock_divider.v` の `DIVISOR = 4`

### 2. ピン配置の設定
FPGAツール（Quartus, Vivado等）でピン配置を設定します。

**例（Quartus の場合）：**
`VGA_BW.qsf` ファイルまたは Pin Planner で設定
```
set_location_assignment PIN_XX -to clk
set_location_assignment PIN_XX -to reset_btn
set_location_assignment PIN_XX -to vga_hsync
set_location_assignment PIN_XX -to vga_vsync
set_location_assignment PIN_XX -to vga_r
set_location_assignment PIN_XX -to vga_g
set_location_assignment PIN_XX -to vga_b
```

**重要**: `PIN_XX` は実際のFPGAボードのピン番号に置き換えてください。

### 3. プロジェクトのコンパイル
1. FPGAツールで新規プロジェクトを作成
2. 以下のファイルを追加：
   - `VGA_BW_top.v`（トップモジュール）
   - `VGA_BW_simple.v`
   - `clock_divider.v`
3. トップモジュールを `VGA_BW_top` に設定
4. コンパイル実行

### 4. ブレッドボード配線
1. VGAコネクタをブレッドボードに固定
2. 抵抗（270Ω）を配線
3. FPGAの出力ピンから配線
4. GNDを必ず接続（重要！）

### 5. FPGAに書き込み
コンパイル後、FPGAに書き込みます。

### 6. モニター接続
VGAケーブルでモニターと接続し、電源を入れます。

---

## 🎨 テストパターン

`VGA_BW_simple.v` の `always @(posedge clk_25mhz)` ブロック内で、
パターンを変更できます：

```verilog
// 市松模様（デフォルト）
video <= h_count[5] ^ v_count[5];

// 全画面白
video <= 1;

// 左半分白、右半分黒
video <= (h_count < 320);

// 上半分白、下半分黒
video <= (v_count < 240);

// 縦縞
video <= h_count[4];

// 横縞
video <= v_count[4];
```

---

## 🐛 トラブルシューティング

### 画面が映らない
1. **クロック周波数を確認**
   - 25MHzになっているか確認
   - 分周比を調整

2. **ピン配置を確認**
   - HSYNC, VSYNC が正しいピンに接続されているか
   - ボード仕様書と照らし合わせる

3. **配線を確認**
   - GNDが接続されているか（最重要！）
   - 抵抗値は適切か（270Ω～470Ω）

4. **モニターの対応解像度を確認**
   - 640x480@60Hz に対応しているか

### 画面が乱れる
- クロック周波数のズレ
  - 25.175MHzが理想だが、25MHzでも動作するはず
- 配線のノイズ
  - ジャンパー線を短くする
  - GNDを確実に接続

### 色がおかしい
- 白黒なのに色が出る → 問題なし（モニターによっては色が付く）
- 暗い → 抵抗値を小さくする（270Ω → 75Ω）

---

## 📊 シミュレーション

動作確認には `VGA_testbench.v` を使用してください。

```bash
# Icarus Verilog の例
iverilog -o vga_test VGA_testbench.v VGA_BW_simple.v
vvp vga_test
gtkwave vga_test.vcd
```

波形で確認すべき点：
- HSYNC周期：31.77μs（800ピクセル @ 25MHz）
- VSYNC周期：16.68ms（525ライン）
- VIDEO信号が表示期間中だけアクティブ

---

## 🚀 次のステップ

白黒VGAが動作したら、以下にチャレンジ：

1. **カラー対応**
   - R, G, B を個別に制御
   - 各色2ビット（計8色）または3ビット（計512色）

2. **フレームバッファ**
   - FPGA内蔵メモリ（BRAM）を使用
   - 画像データを保存・表示

3. **スプライト表示**
   - キャラクタやアイコンを表示

4. **PCからの画像転送**
   - UART/SPIで画像データを送信

---

## 📖 参考資料

- [VGA Timing](http://tinyvga.com/vga-timing/640x480@60Hz)
- VGAタイミング計算機：http://www.tinyvga.com/vga-timing
- お使いのFPGAボードのユーザーマニュアル

---

**作成日**: 2026-01-14
**対象**: FPGAとブレッドボードによる白黒VGA出力
