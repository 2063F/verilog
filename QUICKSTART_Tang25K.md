# Tang Primer 25K VGA クイックスタートガイド

## ⚡ 最速セットアップ (5ステップ)

### 1. Gowin EDA を開く


### 2. 新規プロジェクト作成
```
File → New → Project
  Project Name: VGA_BW_Tang25K
  Device: GW5A-LV25MG121
  Package: MG121
  Speed: C8/I7
```

### 3. ファイルを追加
```
プロジェクトで右クリック → Add File
  ✓ VGA_BW_simple.v
  ✓ VGA_BW_top_Tang25K.v
  ✓ Tang_Primer_25K.cst

VGA_BW_top_Tang25K.v を右クリック → Set as Top Module
```

### 4. ビルド
```
① 緑のチェックマーク (Synthesize)
② 青い基板マーク (Place & Route)
```

### 5. 書き込み
```
Tools → Programmer
  Device: GW5A-25
  Operation: SRAM Program
  File: impl/pnr/VGA_BW_Tang25K.fs
  
→ Program/Configure ボタンをクリック
```

---

## 🔧 ハードウェア接続

### 最小構成
```
Tang Primer 25K J5    →  VGA コネクタ
─────────────────────────────────────
HSYNC (E11)          →  Pin 13
VSYNC (D11)          →  Pin 14
VIDEO (C11)  [270Ω]  →  Pin 1,2,3
GND                  →  Pin 5,6,7,8,10
```

**抵抗**: 270Ω × 3本 (R/G/B用)

---

## ❗ よくあるトラブル

| 症状 | 原因 | 解決方法 |
|------|------|---------|
| 画面真っ暗 | GND未接続 | VGA GNDとFPGA GNDを接続 |
| 合成エラー | ファイル未追加 | 3つのファイルすべて追加 |
| デバイス検出失敗 | ドライバ未インストール | `C:\Gowin_V1.9.x\Programmer\driver\install.bat` 実行 |
| 画面が流れる | クロック不一致 | PLLを使って25.175MHzに変更 |
| ライセンスエラー | ライセンス未設定 | Tools → License Configuration |

---

## 📋 チェックリスト

### ソフトウェア
- []  Gowin EDA インストール済み
- [ ] ライセンス設定完了
- [ ] USBドライバインストール済み

### プロジェクト
- [ ] 3つのファイルを追加済み
- [ ] Top Module 設定済み
- [ ] Synthesize 成功
- [ ] Place & Route 成功

### ハードウェア
- [ ] Tang Primer 25K 接続
- [ ] VGA配線完了
- [ ] GND接続確認
- [ ] モニター接続

### 期待される結果
- [ ] 市松模様が表示される

---

## 📖 詳細ガイド

詳しい説明は **README_Tang_Primer_25K.md** を参照してください。

---

**最終更新**: 2026-02-05
