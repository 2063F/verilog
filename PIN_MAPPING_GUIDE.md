# Tang Primer 25K ピンマッピング解説

## 重要な違い

### 基板のシルク印刷（J5ヘッダー）
```
E11, D11, C11, B11, A11 など
↑ これはヘッダーのピン名（信号名）
```

### FPGAチップの実際のピン番号
```
1～121 の数字
↑ .cstファイルで指定するのはこちら
```

---

## 🔍 Tang Primer 25Kのピンマッピング

Tang Primer 25Kでは、J5ヘッダーのピン名（E11など）は**FPGAチップの特定のボールピン**にマッピングされています。

### 一般的なマッピング例（要確認）

| ヘッダーピン名 | FPGAボールピン番号 |
|-------------|-----------------|
| H11 (CLK) | 4 |
| E11 | 86 |
| D11 | 85 |
| C11 | 84 |
| B11 | 83 |
| A11 | 82 |

**注意**: 上記は推測値です。正確な番号は回路図で確認が必要です。

---

## ✅ 推奨される対処法

### オプション1: 公式ドキュメントを確認（推奨）

Tang Primer 25Kの公式リソース：
- **Sipeed Wiki**: https://wiki.sipeed.com/hardware/en/tang/tang-primer-25k/primer-25k.html
- **回路図（Schematic）**: PDFをダウンロード
- **ピンマップ表**: 通常、回路図の最終ページにある

### オプション2: 試行錯誤で確認

1. まず推測値でビルド
2. FPGAに書き込み
3. オシロスコープで各ピンを確認
4. 信号が出ているピンを特定
5. 正しいマッピングを記録

### オプション3: とりあえずビルドを完了させる

**ピン番号エラーを回避して、まずビルドを完了させる方法**：

すべてのVGA信号を**同じ仮のピン番号**に割り当てる：
- これでビルドは通る
- .fsファイルが生成される
- 後で正しいピン番号に修正して再ビルド

---

## 🎯 今すぐできる対処法

以下の.cstファイルで**とりあえずビルド**してみてください：

```cst
# システムクロック (確実に存在する)
IO_LOC "clk" 4;
IO_PORT "clk" IO_TYPE=LVCMOS33;

# VGA信号（仮のピン番号 - 後で修正が必要）
IO_LOC "vga_hsync" 86;
IO_PORT "vga_hsync" DRIVE=8;
IO_PORT "vga_hsync" IO_TYPE=LVCMOS33;

IO_LOC "vga_vsync" 85;
IO_PORT "vga_vsync" DRIVE=8;
IO_PORT "vga_vsync" IO_TYPE=LVCMOS33;

IO_LOC "vga_r" 84;
IO_PORT "vga_r" DRIVE=8;
IO_PORT "vga_r" IO_TYPE=LVCMOS33;

IO_LOC "vga_g" 83;
IO_PORT "vga_g" DRIVE=8;
IO_PORT "vga_g" IO_TYPE=LVCMOS33;

IO_LOC "vga_b" 82;
IO_PORT "vga_b" DRIVE=8;
IO_PORT "vga_b" IO_TYPE=LVCMOS33;
```

これでビルドが通れば：
1. ✅ プロジェクトの構成は正しい
2. ✅ .fsファイルが生成される
3. ⏳ 正確なピン番号は後で確認・修正

---

## 📖 次のステップ

1. **まずビルドを完了**
2. **Sipeed Wikiで回路図を確認**
3. **正しいピンマッピングを特定**
4. **ピン番号を修正して再ビルド**

---

**まずは上記の仮のピン番号でビルドしてみましょう！**
