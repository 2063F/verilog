# VGAテストベンチのバリエーション

VCDファイルのサイズを目的に応じて最適化するため、3種類のテストベンチを用意しています。

---

## 📊 テストベンチの比較

| ファイル名 | シミュレーション時間 | VCDサイズ目安 | 用途 | 確認できる内容 |
|-----------|-------------------|-------------|------|-------------|
| **VGA_testbench_quick.v** | 65μs（2ライン） | **超小**（数百KB） | 基本動作確認 | HSYNCタイミング |
| **VGA_testbench.v** | 200μs（6ライン） | **小**（数MB） | 通常確認 | HSYNC/VSYNC |
| **VGA_testbench_full.v** | 17ms（1フレーム） | **大**（数十MB） | 完全確認 | 全フレーム動作 |

---

## 🎯 推奨：通常はVGA_testbench.v（デフォルト）

### 特徴
- **シミュレーション時間**: 200μs（約6ライン分）
- **VCDファイルサイズ**: 数MB程度
- **実行時間**: 数秒
- **確認内容**: HSYNC/VSYNCの基本タイミング

### 使い方

```powershell
# コンパイル＆実行
iverilog -o vga_sim.vvp VGA_testbench.v VGA_BW_simple.v
vvp vga_sim.vvp

# GTKWaveで確認
gtkwave vga_test.vcd vga_test.gtkw
```

### 確認できること
- ✅ h_countが0→799まで正しくカウント
- ✅ HSYNCがh_count=656-751で1になる
- ✅ v_countがインクリメントされる
- ✅ display_on信号の動作
- ✅ video信号のパターン

---

## 🚀 超軽量：VGA_testbench_quick.v

### 特徴
- **シミュレーション時間**: 65μs（約2ライン分）
- **VCDファイルサイズ**: 数百KB（超軽量！）
- **実行時間**: 1秒以下
- **確認内容**: HSYNCの基本動作のみ

### 使い方

```powershell
iverilog -o vga_quick.vvp VGA_testbench_quick.v VGA_BW_simple.v
vvp vga_quick.vvp
gtkwave vga_test_quick.vcd
```

### 用途
- コードを少し変更して、すぐに確認したい時
- HSYNCの動作だけ確認したい時
- PCのスペックが低い場合

---

## 📈 完全版：VGA_testbench_full.v

### 特徴
- **シミュレーション時間**: 17ms（約1フレーム分）
- **VCDファイルサイズ**: 数十MB～100MB
- **実行時間**: 数分
- **確認内容**: 完全な1フレームの動作

### 使い方

```powershell
iverilog -o vga_full.vvp VGA_testbench_full.v VGA_BW_simple.v
vvp vga_full.vvp
gtkwave vga_test_full.vcd
```

### 用途
- VSYNCの完全な動作を確認したい
- フレーム全体の映像パターンを確認したい
- 詳細なタイミング解析が必要な時

### 注意
- VCDファイルが大きくなるため、GTKWaveの起動に時間がかかる場合があります
- ディスク容量に注意してください

---

## 💡 VCDファイルサイズ削減のテクニック

### 1. シミュレーション時間の短縮（最も効果的）

```verilog
// ❌ 重い（100ms = 100,000,000 ns）
#100_000_000;

// ✅ 軽い（200μs = 200,000 ns）
#200_000;
```

**効果**: 500倍軽量化！

### 2. ダンプする信号を限定

```verilog
// ❌ すべての信号をダンプ（重い）
$dumpvars(0, VGA_testbench);

// ✅ 必要な信号のみダンプ（軽い）
$dumpvars(1, VGA_testbench);  // レベル1のみ
$dumpvars(0, VGA_testbench.uut.h_count);  // 必要なものを個別追加
$dumpvars(0, VGA_testbench.uut.v_count);
$dumpvars(0, VGA_testbench.uut.display_on);
```

### 3. 時間分解能の調整

```verilog
// ❌ 高精度（ファイルサイズ大）
`timescale 1ns/1ps

// ✅ 適度な精度（ファイルサイズ小）
`timescale 1ns/1ns
```

---

## 📋 各テストベンチで確認できる項目

### VGA_testbench_quick.v（超軽量）
- [x] h_count: 0→799のカウント
- [x] HSYNC: h_count=656-751で1
- [ ] v_countの複数ライン動作（1-2ラインのみ）
- [ ] VSYNCパルス（時間が短すぎて見えない）
- [x] display_on: 基本動作
- [x] video: パターンの一部

### VGA_testbench.v（通常・推奨）
- [x] h_count: 0→799のカウント
- [x] HSYNC: h_count=656-751で1
- [x] v_count: 複数ラインのカウント
- [x] VSYNC: 基本動作を確認可能
- [x] display_on: 完全確認
- [x] video: パターンの確認

### VGA_testbench_full.v（完全版）
- [x] h_count: 完全な動作
- [x] HSYNC: 完全な動作
- [x] v_count: 0→524の完全カウント
- [x] VSYNC: v_count=490-491で1
- [x] display_on: フレーム全体
- [x] video: フレーム全体のパターン

---

## 🎯 推奨ワークフロー

### 開発中（頻繁に確認）
```powershell
# 超軽量版で基本動作確認（1秒で完了）
iverilog -o vga_quick.vvp VGA_testbench_quick.v VGA_BW_simple.v
vvp vga_quick.vvp
gtkwave vga_test_quick.vcd
```

### 通常の確認
```powershell
# 通常版でHSYNC/VSYNC確認（数秒で完了）
iverilog -o vga_sim.vvp VGA_testbench.v VGA_BW_simple.v
vvp vga_sim.vvp
gtkwave vga_test.vcd vga_test.gtkw
```

### 最終確認
```powershell
# 完全版でフレーム全体を確認（数分）
iverilog -o vga_full.vvp VGA_testbench_full.v VGA_BW_simple.v
vvp vga_full.vvp
gtkwave vga_test_full.vcd
```

---

## 📁 生成されるVCDファイル

| テストベンチ | VCDファイル名 | サイズ目安 |
|-------------|--------------|----------|
| VGA_testbench_quick.v | vga_test_quick.vcd | 数百KB |
| VGA_testbench.v | vga_test.vcd | 数MB |
| VGA_testbench_full.v | vga_test_full.vcd | 数十MB |

---

## ⚠️ 注意事項

### VCDファイルの自動削除

VCDファイルは毎回上書きされます。古いファイルを保存したい場合は、別名でコピーしてください。

```powershell
# バックアップ
copy vga_test.vcd vga_test_backup.vcd
```

### GTKWaveが重い場合

1. **超軽量版を使用**
2. **ズームして表示範囲を限定**
3. **不要な信号を非表示**
4. **PCのメモリを増やす**

---

**作成日**: 2026-01-15  
**目的**: VCDファイルサイズの最適化とシミュレーション高速化
