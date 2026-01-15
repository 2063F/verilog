# GTKWaveでVGA信号を確認する方法

## 📌 概要
VGAシミュレーションの波形をGTKWaveで正しく表示・確認する方法を説明します。

---

## 🔧 準備

### 1. シミュレーションの実行

```powershell
# Icarus Verilogでシミュレーション実行
cd c:\Users\asami\Documents\verilog
iverilog -o vga_sim.vvp VGA_testbench.v VGA_BW_simple.v
vvp vga_sim.vvp
```

実行後、`vga_test.vcd` ファイルが生成されます。

### 2. GTKWaveの起動

```powershell
# 設定ファイルと一緒に起動（推奨）
gtkwave vga_test.vcd vga_test.gtkw

# または、VCDファイルだけで起動
gtkwave vga_test.vcd
```

---

## 📊 GTKWaveでの正しい表示方法

### **重要な信号と表示形式**

| 信号名 | 種類 | 表示形式 | 説明 |
|--------|------|----------|------|
| `clk` | デジタル | Binary | 25MHzクロック |
| `reset` | デジタル | Binary | リセット信号 |
| `hsync` | デジタル | Binary | 水平同期（パルス確認） |
| `vsync` | デジタル | Binary | 垂直同期（パルス確認） |
| `h_count` | カウンタ | **Decimal** | 水平カウンタ（0-799）|
| `v_count` | カウンタ | **Decimal** | 垂直カウンタ（0-524）|
| `display_on` | デジタル | Binary | 表示領域フラグ |
| `video` | デジタル | Binary | 映像信号 |

---

## ⚙️ 手動で設定する場合の手順

### 1. 信号の追加

左側のツリービューから以下の順序で信号を追加：

1. **クロックとリセット**
   - `VGA_testbench.clk`
   - `VGA_testbench.reset`

2. **同期信号**
   - `VGA_testbench.hsync`
   - `VGA_testbench.vsync`

3. **カウンタ**
   - `VGA_testbench.uut.h_count[9:0]`
   - `VGA_testbench.uut.v_count[9:0]`

4. **映像信号**
   - `VGA_testbench.uut.display_on`
   - `VGA_testbench.video`

### 2. 表示形式の変更

**カウンタを10進数で表示**（重要！）：

1. 信号を右クリック → `Data Format` → `Decimal`
2. または、信号を選択して、メニューバーの `Edit` → `Data Format` → `Decimal`

**16進数で表示したい場合**：
- `Data Format` → `Hexadecimal`

### 3. 区切り線の追加

見やすくするために区切り線を追加：

1. 信号リストを右クリック → `Insert Comment`
2. コメントに `-同期信号` などと入力

---

## 🔍 確認すべきポイント

### **1. HSYNCタイミング**

```
h_count の動き:
0 → 639 (表示期間)
640 → 655 (フロントポーチ)
656 → 751 (HSYNC = 1)  ← ここを確認！
752 → 799 (バックポーチ)
→ 0 に戻る
```

**確認方法**：
- `h_count` が 656 ～ 751 の間で `hsync` が 1 になっているか確認
- GTKWaveでカーソル（縦線）を移動して数値を確認

### **2. VSYNCタイミング**

```
v_count の動き:
0 → 479 (表示期間)
480 → 489 (フロントポーチ)
490 → 491 (VSYNC = 1)  ← ここを確認！
492 → 524 (バックポーチ)
→ 0 に戻る
```

**確認方法**：
- `v_count` が 490 ～ 491 の間で `vsync` が 1 になっているか確認

### **3. 表示期間**

```
display_on が 1 になる条件:
- h_count < 640 かつ
- v_count < 480
```

**確認方法**：
- `display_on` が 1 の時に `video` 信号が変化しているか確認
- `display_on` が 0 の時に `video` が 0 であることを確認

### **4. 映像パターン**

デフォルトは市松模様：
```verilog
video <= h_count[5] ^ v_count[5];
```

- `h_count[5]` は 32ピクセルごとに反転
- `v_count[5]` は 32ラインごとに反転
- XOR演算で市松模様

---

## 🎯 推奨表示設定

### **タイムスケールの調整**

VGA信号は周期が長いので、適切なズームレベルが重要です：

| 確認内容 | 推奨タイムスケール | 操作 |
|---------|------------------|------|
| クロックパルス | 100ns～1μs | ズームイン |
| 1水平ライン | 30μs～50μs | 中程度 |
| 1フレーム全体 | 10ms～20ms | ズームアウト |

**ズーム操作**：
- ズームイン: `Ctrl` + `+` または マウスホイール上
- ズームアウト: `Ctrl` + `-` または マウスホイール下
- フィット: `Ctrl` + `F`

### **マーカーの使用**

重要なタイミングにマーカーを設置：

1. **HSYNC開始位置**（h_count = 656）
2. **VSYNC開始位置**（v_count = 490）
3. **フレーム境界**（h_count = 0, v_count = 0）

**操作方法**：
- マーカー追加: 波形上で右クリック → `Set Marker`
- または、`Alt` + 左クリック

---

## 📈 典型的な波形パターン

### **水平同期（1ライン分）**

```
時間軸: 約31.77μs（800ピクセル @ 25MHz）

clk      : ||||||||||||||||||||||||||||||||||||
h_count  : 0---639|640-655|656----751|752--799|0--
display  : ████████████░░░░░░░░░░░░░░░░░░░░░░░░░░█
hsync    : ░░░░░░░░░░░░░░░░░░████████████░░░░░░░░░
video    : ████░░██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░█
           ↑表示期間 ↑FP  ↑同期    ↑BP
```

### **垂直同期（数ライン分）**

```
フレーム周期: 約16.68ms（525ライン）

v_count  : 479|480-489|490-491|492-524|0
vsync    : ░░░░░░░░░░░░████░░░░░░░░░░░░░
```

---

## 🐛 よくある問題と解決方法

### **問題1: カウンタが2進数で読みにくい**

**症状**：
```
h_count: 0000000000
h_count: 0000000001
h_count: 0000000010  ← 読みにくい！
```

**解決方法**：
信号を右クリック → `Data Format` → `Decimal` に変更

```
h_count: 0
h_count: 1
h_count: 2  ← わかりやすい！
```

### **問題2: 信号が見つからない**

**症状**：
`uut.h_count` が見つからない

**解決方法**：
1. 左側のツリーを展開: `VGA_testbench` → `uut`
2. テストベンチで `$dumpvars(0, VGA_testbench);` が実行されているか確認

### **問題3: 波形が表示されない**

**症状**：
GTKWaveは起動するが、信号が平坦

**解決方法**：
1. VCDファイルが正しく生成されているか確認
2. シミュレーションが最後まで実行されているか確認（`$finish` まで）
3. `$dumpfile()` と `$dumpvars()` がテストベンチに記述されているか確認

### **問題4: 表示が遅い・重い**

**症状**：
GTKWaveの動作が遅い

**解決方法**：
シミュレーション時間を短縮：

```verilog
// テストベンチの実行時間を短縮
// 3フレーム（100ms）→ 1ライン分（32μs）
#1000;  // 1μs のみ実行
```

---

## 💡 高度な使い方

### **1. 特定の範囲をズーム**

1. 開始位置でマウス左ボタンを押す
2. ドラッグして終了位置まで移動
3. メニュー `Time` → `Zoom to Range`

### **2. 信号の色変更**

信号を右クリック → `Highlight` → 色を選択

### **3. 波形の比較**

複数のシミュレーション結果を比較：
1. `File` → `Reload Waveform`
2. 異なるVCDファイルを読み込む

### **4. スクリーンショット保存**

`File` → `Print to File` → PNG/PDF を選択

---

## 📖 参考コマンド

### **シミュレーション実行（Windows PowerShell）**

```powershell
# コンパイル＆実行
iverilog -o vga_sim.vvp VGA_testbench.v VGA_BW_simple.v
vvp vga_sim.vvp

# GTKWave起動（設定付き）
gtkwave vga_test.vcd vga_test.gtkw
```

### **シミュレーション実行（Linux/Mac）**

```bash
# コンパイル＆実行
iverilog -o vga_sim.vvp VGA_testbench.v VGA_BW_simple.v
vvp vga_sim.vvp

# GTKWave起動
gtkwave vga_test.vcd vga_test.gtkw &
```

---

## ✅ チェックリスト

VGA信号が正しく生成されているか確認：

- [ ] HSYNC周期が約31.77μs（800ピクセル分）
- [ ] HSYNCパルス幅が約3.84μs（96ピクセル分）
- [ ] VSYNC周期が約16.68ms（525ライン分）
- [ ] VSYNCパルス幅が約63μs（2ライン分）
- [ ] display_onが h_count<640 かつ v_count<480 で1
- [ ] display_on=0の時、videoが0
- [ ] display_on=1の時、videoがパターンに従っている

---

**作成日**: 2026-01-15  
**対象**: Icarus Verilog + GTKWave でのVGA信号確認
