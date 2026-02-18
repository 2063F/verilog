# VGA映像が出ない時のトラブルシューティングガイド

## 🔍 症状：電流は流れるが映像が出ない

この状態は、**VGA信号は送られているが、タイミングやレベルが合っていない**ことを示しています。

---

## ✅ チェックリスト

### 1. HSYNC/VSYNC信号の極性確認

VGA標準では、HSYNC/VSYNCは**負極性**（アクティブLow）です。

```verilog
// ✅ 正しい（VGA標準）
if (同期期間中)
    hsync <= 1'b0;  // Low
else
    hsync <= 1'b1;  // High

// ❌ 間違い
if (同期期間中)
    hsync <= 1'b1;  // High（逆！）
else
    hsync <= 1'b0;  // Low
```

**確認方法**：
- `VGA_BW_simple.v` の78-86行目と88-96行目を確認
- 同期期間中（`if`の中）が `0` になっているか

---

### 2. クロック信号の確認

**問題**: VGA_BW_top.vで`clk_vga`が未定義

```verilog
// ❌ 間違い（clk_vgaが定義されていない）
VGA_BW_simple vga_core (
    .clk_25mhz(clk_vga),  // ← clk_vgaがない！
    ...
);

// ✅ 正しい
wire clk_vga;
assign clk_vga = clk;  // クロック信号を定義

VGA_BW_simple vga_core (
    .clk_25mhz(clk_vga),
    ...
);
```

---

### 3. リセット信号の極性

Tang Primer 25Kのボタンは通常**プルアップ**されています。

```verilog
// ボタンの動作:
// - 押していない時: 1 (High)
// - 押している時:   0 (Low)

// VGA_BW_simpleは reset = High でリセット
// したがって、
```

**制約ファイル（.cst）で確認**:
```cst
IO_LOC "reset_btn" T10;
IO_PORT "reset_btn" PULL_MODE=UP;  // ← プルアップ
```

**対処法**:
1. **オプションA**: ボタンを押さないで使う（推奨）
2. **オプションB**: リセット極性を反転
   ```verilog
   .reset(!reset_btn)  // 論理反転
   ```

---

### 4. ファイルの重複確認

**問題**: `VGA_BW_top.v`にモジュールが2回定義されている

```
module VGA_BW_top(...)
    ...
endmodule
module VGA_BW_top(...)  ← 重複！
    ...
endmodule
```

**解決方法**:
- Tang Primer 25Kを使う場合は `VGA_BW_top_Tang25K.v` を使う
- `VGA_BW_top.v` は使わない（または削除）

---

## 🛠️ 修正手順

### Step 1: 正しいファイルを使用

Tang Primer 25K で作業している場合：

**使うファイル**:
- ✅ `VGA_BW_simple.v` （最新版に更新済み）
- ✅ `VGA_BW_top_Tang25K.v` （Tang Primer 25K用）
- ✅ `Tang_Primer_25K.cst` （制約ファイル）

**使わないファイル**:
- ❌ `VGA_BW_top.v` （汎用版、Tang Primer 25Kには不要）
- ❌ `clock_divider.v` （Tang Primer 25Kでは27MHzをそのまま使用）

### Step 2: Gowin EDAでプロジェクト確認

1. **Design** タブで確認
   ```
   ✓ VGA_BW_simple.v
   ✓ VGA_BW_top_Tang25K.v  ← これがTop Moduleに設定されている
   ✓ Tang_Primer_25K.cst
   ```

2. **トップモジュール確認**
   - `VGA_BW_top_Tang25K.v` が太字になっているか

3. **再ビルド**
   ```
   ① Synthesize
   ② Place & Route
   ③ Program
   ```

### Step 3: ハードウェア配線再確認

| Tang Primer 25K | 抵抗 | VGA Pin | 信号 |
|----------------|------|---------|------|
| E11 (HSYNC) | - | Pin 13 | 水平同期 |
| D11 (VSYNC) | - | Pin 14 | 垂直同期 |
| C11 (VIDEO) | 270Ω | Pin 1 | R (赤) |
| C11 (VIDEO) | 270Ω | Pin 2 | G (緑) |
| C11 (VIDEO) | 270Ω | Pin 3 | B (青) |
| GND | - | Pin 5,6,7,8,10 | グランド |

**重要**: 
- GND接続を必ず確認（テスターで導通確認）
- 抵抗値は220Ω～470Ωの範囲ならOK

---

## 🔬 デバッグ方法

### 方法1: 全画面白テストパターン

`VGA_BW_simple.v` の107行目付近を変更：

```verilog
always @(posedge clk_25mhz) begin
    if (display_on) begin
        // video <= h_count[5] ^ v_count[5];  // ← コメントアウト
        video <= 1'b1;  // ← 全画面白に変更
    end else begin
        video <= 1'b0;
    end
end
```

これで画面全体が白くなるはず。白くならない→HSYNC/VSYNCまたはタイミングの問題

### 方法2: LED デバッグ

Tang Primer 25KにLEDがある場合：

```verilog
// VGA_BW_top_Tang25K.v に追加
output wire led;
assign led = video_signal;  // 映像信号をLEDに出力
```

LEDが点滅していれば、映像信号は生成されている

### 方法3: シミュレーション確認

```powershell
cd c:\Users\asami\Documents\verilog
iverilog -o vga_sim.vvp VGA_testbench.v VGA_BW_simple.v
vvp vga_sim.vvp
gtkwave vga_test.vcd
```

GTKWaveで確認：
- `hsync` が定期的にLowになっているか
- `vsync` が定期的にLowになっているか
- `video` が表示期間中に変化しているか

---

## 📊 期待される信号波形

```
hsync: ━━━━━━┓______┏━━━━━━━━━━━━━━━━━━━━━━━━━
       (High)  (Low)  (High - 通常時)
       
vsync: ━━━━━━━━━━━━━━━━━━━━━━━━━┓__┏━━━━━━━━━━
       (High - 多くのライン)      (Low)(High)
       
video: ████░░░░████░░░░████░░░░  (表示期間中のみ変化)
```

---

## 🆘 それでも映らない場合

1. **モニターの対応解像度確認**
   - 640x480@60Hzに対応しているか
   - 古いモニターの方が対応率が高い

2. **別のモニターで試す**
   - モニターとの相性問題もある

3. **VGAケーブル確認**
   - ケーブルの断線チェック

4. **FPGAの書き込み確認**
   - "Program done"と表示されたか
   - SRAMモードは電源を切ると消える

5. **ピン配置の再確認**
   - `.cst` ファイルと実際の配線が一致しているか
   - Tang Primer 25Kの回路図と確認

---

**作成日**: 2026-02-07  
**対象**: Tang Primer 25K VGA出力トラブルシューティング
