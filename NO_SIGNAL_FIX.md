# 信号が出ない原因の特定と解決

## 🔴 発見された問題

**ビルドファイル（.fs）が存在しません**

これは、**プロジェクトが正しくビルドされていない**ことを意味します。

---

## 🎯 原因

Programmerで"finished"と表示されていましたが、実際には：

1. **古いビットストリームを書き込んでいた**、または
2. **ビルドが失敗していた**

`.fs`ファイルがないということは、**現在のVGAプロジェクトはまだビルドされていません**。

---

## ✅ 解決手順

### Step 1: プロジェクトファイルの確認

**Gowin EDA**でプロジェクトを開き直してください：

1. `File` → `Open` → `Project...`
2. `VGA_BW_Tang25K.gprj` を開く

### Step 2: 必要なファイルがすべて追加されているか確認

**Designタブ**で以下が表示されているか：

```
✓ VGA_BW_simple.v
✓ VGA_BW_top_Tang25K.v
✓ gowin_pll.v (src/gowin_pll/)
✓ gowin_pll_mod.v (src/gowin_pll/)
✓ pll_init.v
✓ Tang_Primer_25K_VGA.cst
```

### Step 3: トップモジュールの設定

**VGA_BW_top_Tang25K.v を右クリック**
- `Set as Top Module`
- ファイル名が**太字**になればOK

### Step 4: ビルド実行

1. **Synthesize**（緑のチェックマーク）をクリック
   - Consoleで進捗確認
   - エラーがないか確認

2. **成功したら Place & Route**（青い基板マーク）
   - 数分かかります
   - 完了まで待つ

3. **ビルド成功の確認**
   ```
   impl/pnr/VGA_BW_Tang25K.fs
   ```
   このファイルが生成されたか確認

### Step 5: 書き込み

1. `Tools` → `Programmer`
2. デバイス確認（GW5A-25）
3. ファイル確認（impl/pnr/VGA_BW_Tang25K.fs）
4. `Program/Configure` をクリック

---

## 🐛 ビルド失敗の可能性

### よくあるエラー

#### エラー1: モジュールが見つからない
```
ERROR: Module 'Gowin_PLL' not found
```
→ PLLファイルが追加されていない

#### エラー2: ポートが一致しない
```
ERROR: Port 'clkout0' not found
```
→ トップモジュールのPLLインスタンス名が間違っている

#### エラー3: 制約ファイルエラー
```
ERROR: Pin 'clk' not found
```
→ .cstファイルの信号名とVerilogコードが不一致

---

## 📋 チェックリスト

完全な手順のチェックリスト：

- [ ] Gowin EDAでプロジェクトを開いた
- [ ] 全6つのVerilogファイルが追加されている
- [ ] VGA_BW_top_Tang25K.vがトップモジュール（太字）
- [ ] Synthesize成功（緑のチェック）
- [ ] Place & Route成功（青い基板）
- [ ] impl/pnr/VGA_BW_Tang25K.fs が存在
- [ ] Programmerで書き込み完了
- [ ] Tang Primer 25K再起動

---

## 🆘 次にやるべきこと

**すぐにGowin EDAでプロジェクトを開き、ビルドを実行してください**

エラーが出たら、**エラーメッセージの全文**を教えてください。

---

**作成日**: 2026-02-16  
**問題**: ビルドファイル未生成  
**対処**: プロジェクトの再ビルド
