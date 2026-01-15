# Tang Primer 25K で白黒VGA出力を実現する

## 📌 Tang Primer 25K の特徴

- **FPGA**: Gowin GW5A-LV25MG121 (25K LUTs)
- **クロック**: 27MHz 水晶振動子
- **開発ツール**: Gowin EDA (Educational Edition)
- **豊富なI/O**: 拡張ヘッダー J5, J6 など

---

## 🔧 必要な部品

### ハードウェア
- Tang Primer 25K ボード × 1
- ブレッドボード × 1
- VGA コネクタ（メス、15ピン D-Sub） × 1
- 抵抗 270Ω × 3本
- ジャンパー線（オス-メス、オス-オス）
- VGA ケーブル
- VGA モニター

### ソフトウェア
- **Gowin EDA** (無料版で OK)
  - ダウンロード: https://www.gowinsemi.com/en/support/download_eda/
  - Educational Edition を選択

---

## 🔌 配線図（Tang Primer 25K 専用）

```
【Tang Primer 25K】    【ブレッドボード】      【VGA コネクタ】

J5 の GPIO ピン:
Pin XX (HSYNC) ──────────────────────→ VGA Pin 13 (HSYNC)
Pin XX (VSYNC) ──────────────────────→ VGA Pin 14 (VSYNC)
Pin XX (VIDEO) ───┬─[270Ω]──────────→ VGA Pin 1  (RED)
                  ├─[270Ω]──────────→ VGA Pin 2  (GREEN)
                  └─[270Ω]──────────→ VGA Pin 3  (BLUE)
GND ───────────────────────────────────→ VGA Pin 5,6,7,8,10
```

**重要**: Tang Primer 25K のピン配置は拡張ヘッダーを使用します。
実際のピン番号は `Tang_Primer_25K_VGA.cst` ファイルで指定します。

---

## ⚙️ 実装手順

### 1. Gowin EDA のインストール

1. [Gowin公式サイト](https://www.gowinsemi.com/en/support/download_eda/) からダウンロード
2. Educational Edition をインストール
3. ライセンスファイルを取得（無料、メールアドレス登録が必要）

### 2. プロジェクトの作成

#### Gowin EDA での操作:

1. **新規プロジェクト作成**
   - `File` → `New` → `Project...`
   - プロジェクト名: `VGA_BW_Tang25K`
   - パス: `c:\Users\asami\Documents\verilog\`

2. **デバイス選択**
   - Device: `GW5A-LV25MG121`
   - Package: `MG121`
   - Speed: `C8/I7`

3. **ファイルの追加**
   以下のファイルを追加してください:
   - `VGA_BW_top_Tang25K.v` （デザインファイル）
   - `VGA_BW_simple.v` （デザインファイル）
   - `Tang_Primer_25K_VGA.cst` （制約ファイル）

4. **トップモジュールの設定**
   - 右クリックで `VGA_BW_top_Tang25K.v` を「Top Module」に設定

### 3. ピン配置の確認と調整

**重要**: `Tang_Primer_25K_VGA.cst` ファイルのピン番号を確認してください。

実際に使用する拡張ヘッダーのピン番号に合わせて調整が必要です。
Tang Primer 25K の回路図を参照してください。

#### 推奨ピン配置（拡張ヘッダー J5）:
```
clk        : H11  (27MHz オンボードクロック)
reset_btn  : T10  (S1 ボタン)
vga_hsync  : E11  (J5 の任意のピン)
vga_vsync  : D11  (J5 の任意のピン)
vga_r      : C11  (J5 の任意のピン)
vga_g      : B11  (J5 の任意のピン)
vga_b      : A11  (J5 の任意のピン)
```

### 4. 合成とPlace & Route

1. **合成 (Synthesize)**
   - ツールバーの `Synthesize` ボタンをクリック
   - エラーがないことを確認

2. **Place & Route**
   - ツールバーの `Place & Route` ボタンをクリック
   - 完了まで待つ（数分）

3. **プログラミングファイル生成**
   - 自動的に `.fs` ファイルが生成されます

### 5. FPGA への書き込み

1. Tang Primer 25K を USB で PC に接続

2. **Programmer を起動**
   - `Tools` → `Programmer`

3. **書き込み設定**
   - Device: `GW5A-25` を選択
   - Operation: `SRAM Program` (テスト用) または `Flash Program` (永続化)
   - ファイル: `impl/pnr/VGA_BW_Tang25K.fs` を選択

4. **書き込み実行**
   - `Program/Configure` ボタンをクリック
   - 成功すると "Program done" と表示されます

### 6. ブレッドボード配線

1. VGAコネクタをブレッドボードに配置
2. 抵抗（270Ω）を3本配線
3. Tang Primer 25K の拡張ヘッダー J5 から配線
   - HSYNC → VGA Pin 13
   - VSYNC → VGA Pin 14
   - VIDEO → 抵抗 → VGA Pin 1, 2, 3
4. **GND を必ず接続**（Tang Primer 25K の GND ピン → VGA の GND）

### 7. 動作確認

1. VGA ケーブルでモニターと接続
2. Tang Primer 25K に USB 電源を接続
3. モニターに市松模様が表示されれば成功！

---

## 🎨 クロック周波数について

Tang Primer 25K は **27MHz** のクロックを持っていますが、
VGA 640x480@60Hz は **25.175MHz** が標準です。

### オプション1: 27MHzをそのまま使用（簡単）
- 現在のコード (`VGA_BW_top_Tang25K.v`) はこの方式
- 若干仕様外だが、ほとんどのモニターで動作する
- **初心者向け・推奨**

### オプション2: PLLで正確なクロックを生成（上級者向け）
Gowin EDA の PLL IP コアを使用：

1. `Tools` → `IP Core Generator`
2. `PLL` を選択
3. 入力: 27MHz、出力: 25.175MHz に設定
4. `Gowin_rPLL.v` ファイルが生成される
5. `VGA_BW_top_Tang25K.v` でコメントアウト部分を有効化

---

## 🐛 トラブルシューティング

### 画面が映らない

1. **ピン配置を再確認**
   - `.cst` ファイルのピン番号が実際の配線と一致しているか
   - Tang Primer 25K の回路図と照らし合わせる

2. **GND 接続を確認**
   - VGAの GND ピン (5,6,7,8,10) すべてに GND を接続
   - Tang Primer 25K の GND ピンも確認

3. **書き込みを確認**
   - Programmer で "Program done" と表示されたか
   - SRAM モードの場合、電源を切ると消えるので再書き込み

4. **モニターの対応解像度**
   - 640x480@60Hz に対応しているか確認
   - 古いモニターの方が対応している可能性が高い

### 画面が乱れる・チラつく

- **27MHz を使用している場合**
  - 仕様から約7%速いため、一部のモニターで不安定
  - PLL を使って 25.175MHz に調整することを推奨

- **配線のノイズ**
  - ジャンパー線を短くする
  - GND を確実に接続

### Gowin EDA でエラーが出る

- **ライセンスエラー**
  - ライセンスファイル (.lic) が正しく設定されているか確認
  - `Tools` → `License Configuration`

- **デバイスが見つからない**
  - USB ドライバが正しくインストールされているか確認
  - Tang Primer 25K の電源が入っているか確認

---

## 📊 テストパターンの変更

`VGA_BW_simple.v` の 68行目付近を編集：

```verilog
// 市松模様（デフォルト）
video <= h_count[5] ^ v_count[5];

// 全画面白
video <= 1;

// 左半分白、右半分黒
video <= (h_count < 320);

// 縦縞（細かい）
video <= h_count[3];

// 縦縞（太い）
video <= h_count[6];
```

編集後、再度 Synthesize → Place & Route → Program を実行してください。

---

## 🚀 次のステップ

白黒VGAが動作したら：

### 1. カラーVGAに挑戦
- R, G, B を個別に制御
- 各色 1ビット = 8色表示

### 2. テキスト表示
- フォント ROM を作成
- 文字列を画面に表示

### 3. グラフィックス描画
- 線、円、四角形などを描画
- BRAM を使用したフレームバッファ

### 4. HDMI 出力
- Tang Primer 25K は HDMI ポートを搭載
- HDMI 出力モジュールに置き換え可能

---

## 📖 参考資料

- [Tang Primer 25K 公式ページ](https://wiki.sipeed.com/hardware/en/tang/tang-primer-25k/primer-25k.html)
- [Gowin EDA マニュアル](https://www.gowinsemi.com/en/support/document/)
- [VGA タイミング](http://tinyvga.com/vga-timing/640x480@60Hz)

---

## 📝 ファイル一覧

- `VGA_BW_simple.v` - VGA コアモジュール
- `VGA_BW_top_Tang25K.v` - Tang Primer 25K 用トップモジュール
- `Tang_Primer_25K_VGA.cst` - ピン配置ファイル
- `VGA_testbench.v` - テストベンチ（シミュレーション用）

---

**作成日**: 2026-01-14  
**対象ボード**: Tang Primer 25K (GW5A-LV25MG121)
