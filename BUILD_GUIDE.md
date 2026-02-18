# Gowin EDA プロジェクトビルド完全ガイド

## 🚨 現在の問題

**プロジェクトがまだ一度もビルドされていません**

VGAプログラムをFPGAに書き込むには、まず**Gowin EDA**でプロジェクトをビルドする必要があります。

---

## 📝 ステップバイステップガイド

### Step 1: Gowin EDAを起動

1. Gowin EDA を起動
2. `File` → `Open` → `Project...`
3. 以下を選択：
   ```
   c:\Users\asami\Documents\verilog\VGA_BW_Tang25K\VGA_BW_Tang25K.gprj
   ```
4. `Open` をクリック

---

### Step 2: プロジェクトファイルを追加

**現在足りないファイル**：
- PLLモジュールファイル

#### PLLファイルを追加する手順

1. **Designタブ**（左側）で空白部分を右クリック
2. `Add File...` を選択
3. 以下のファイルを**1つずつ**追加：

```
✓ c:\Users\asami\Documents\verilog\src\gowin_pll\gowin_pll.v
✓ c:\Users\asami\Documents\verilog\src\gowin_pll\gowin_pll_mod.v
✓ c:\Users\asami\Documents\verilog\pll_init.v
```

#### すでに追加されているはずのファイル

```
✓ VGA_BW_simple.v
✓ VGA_BW_top_Tang25K.v
✓ Tang_Primer_25K_VGA.cst
```

---

### Step 3: トップモジュールを設定

1. **Designタブ**で `VGA_BW_top_Tang25K.v` を探す
2. **右クリック**
3. `Set as Top Module` を選択
4. ファイル名が**太字**になればOK

---

### Step 4: Synthesize（合成）

1. ツールバーの**緑のチェックマーク**アイコンをクリック
   - または `Process` → `Synthesize`

2. **Consoleタブ**（下部）で進捗を確認

3. 完了すると：
   ```
   Synthesize complete successfully
   ```

#### エラーが出た場合

**よくあるエラー**：

```
ERROR (CR0009): Module 'Gowin_PLL' not found
```
→ **対処**: PLLファイルを追加してください（Step 2参照）

```
ERROR (CR0001): Syntax error
```
→ **対処**: エラーの詳細をお知らせください

---

### Step 5: Place & Route（配置配線）

1. Synthesize成功後、ツールバーの**青い基板**アイコンをクリック
   - または `Process` → `Place & Route`

2. **数分かかります**（3-5分程度）

3. 完了すると：
   ```
   Place & Route complete successfully
   ```

4. **ビルドファイルが生成される**：
   ```
   VGA_BW_Tang25K/
   └── impl/
       └── pnr/
           └── VGA_BW_Tang25K.fs  ← これが書き込みファイル
   ```

---

### Step 6: FPGAに書き込み

1. `Tools` → `Programmer`

2. **設定を確認**：
   - Device: `GW5A-25` が表示されている
   - File: `impl/pnr/VGA_BW_Tang25K.fs`

3. **書き込み実行**：
   - `Program/Configure` ボタンをクリック

4. **成功確認**：
   ```
   Operation "SRAM Program" for device1...
   ...
   finished
   Cost X.XX second(s)
   ```

---

### Step 7: 動作確認

1. **Tang Primer 25Kを再起動**
   - USBケーブルを抜いて、10秒待ってから再接続

2. **VGAモニターを接続**

3. **オシロスコープで確認**
   - HSYNC (VGA Pin 13) に信号が来ているか
   - VSYNC (VGA Pin 14) に信号が来ているか

---

## ✅ ビルド成功のチェックリスト

- [ ] Gowin EDAでプロジェクトを開いた
- [ ] PLLファイル3つを追加した
- [ ] VGA_BW_top_Tang25K.vが太字（トップモジュール）
- [ ] Synthesize成功（緑）
- [ ] Place & Route成功（青）
- [ ] `impl/pnr/VGA_BW_Tang25K.fs` が存在
- [ ] Programmerで書き込み完了（"finished"表示）
- [ ] Tang Primer 25K再起動
- [ ] オシロスコープで信号確認

---

## 🐛 トラブルシューティング

### Q: Synthesizeでエラーが出る

**A**: エラーメッセージの全文を確認してください。

よくあるエラー：
- `Module 'Gowin_PLL' not found` → PLLファイル未追加
- `Port mismatch` → トップモジュールのポート名が間違っている

### Q: Place & Routeで止まる

**A**: 
- 数分（3-5分）待ってください
- 15分以上経っても終わらない場合、一度キャンセルして再実行

### Q: Programmerでデバイスが見つからない

**A**:
1. USBドライバ再インストール
2. Tang Primer 25K再接続
3. 別のUSBポート使用

---

## 📞 サポート

ビルド中にエラーが出たら：

1. **Consoleタブのエラーメッセージを全てコピー**
2. エラー内容をお知らせください

具体的なエラーがあれば、すぐに解決できます！

---

**作成日**: 2026-02-16  
**対象**: Tang Primer 25K VGAプロジェクト  
**必須**: Gowin EDA でのビルド実行
