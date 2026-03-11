# Tang Primer 25K: 8色カラーVGAの作り方

白黒（市松模様）の表示成功おめでとうございます！
現在のプロジェクトは、RGBの3つのピン（赤、緑、青）すべてに「同じ信号」を送っているため、白（全点灯）と黒（全消灯）しか表現できません。

これを**RGBそれぞれ別々の信号**として制御することで、簡単に **8色（2^3色）** のカラー表示を実現できます！

---

## 🎨 8色カラーの仕組み

VGAの各ピン（R, G, B）はデジタル信号（1 or 0）で制御します。
3つのピンの組み合わせで、以下の8色が表現できます。

| 指定 (R, G, B) | 赤 (R) | 緑 (G) | 青 (B) | 画面の色 |
| :---: | :---: | :---: | :---: | :--- |
| `3'b000` | 0 | 0 | 0 | ⬛ 黒 (Black) |
| `3'b001` | 0 | 0 | 1 | 🟦 青 (Blue) |
| `3'b010` | 0 | 1 | 0 | 🟩 緑 (Green) |
| `3'b011` | 0 | 1 | 1 | 🩵 シアン (水色) |
| `3'b100` | 1 | 0 | 0 | 🟥 赤 (Red) |
| `3'b101` | 1 | 0 | 1 | 🟪 マゼンタ (紫) |
| `3'b110` | 1 | 1 | 0 | 🟨 黄色 (Yellow) |
| `3'b111` | 1 | 1 | 1 | ⬜ 白 (White) |

※ `3'b` は「3ビットの2進数（バイナリ）」という意味のVerilogの書き方です。

---

## 🛠️ プログラムの変更手順

カラー化するためには、現在のコードの「信号を1つだけ出力する」部分を「3つ（RGB）別々に出力する」ように変更します。

### ステップ 1: コアモジュールの修正 (`VGA_BW_simple.v`)

現在の `video`（1ビット）の出力を、`video_rgb`（3ビット）に変更します。

#### 【変更前】
```verilog
    output reg video           // 白黒映像信号（1=白、0=黒）
```

#### 【変更後】
```verilog
    output reg [2:0] video_rgb // カラー映像信号（[2]=R, [1]=G, [0]=B）
```

そして、下の方にある映像生成ロジックをカラーパターンに書き換えます。ここでは綺麗に見える **「8色の縦のカラーバー」** を作ってみましょう。

#### 【映像ロジックの書き換え】
```verilog
    always @(posedge clk_25mhz) begin
        if (display_on) begin
            // 画面を横幅(640)で8等分(80ピクセルごと)して色を変える
            if      (h_count < 80)  video_rgb <= 3'b111; // 白
            else if (h_count < 160) video_rgb <= 3'b110; // 黄
            else if (h_count < 240) video_rgb <= 3'b011; // シアン
            else if (h_count < 320) video_rgb <= 3'b010; // 緑
            else if (h_count < 400) video_rgb <= 3'b101; // マゼンタ
            else if (h_count < 480) video_rgb <= 3'b100; // 赤
            else if (h_count < 560) video_rgb <= 3'b001; // 青
            else                    video_rgb <= 3'b000; // 黒
        end else begin
            video_rgb <= 3'b000;  // ブランキング期間は必ず黒！
        end
    end
```

---

### ステップ 2: トップモジュールの修正 (`VGA_BW_first_Tang25K.v`)

コアモジュールが3ビットのカラーを出力するようになったので、トップモジュール側でそれを受け取り、R, G, Bの各ピンに振り分けます。

#### 【モジュール呼び出しの変更】
```verilog
    wire [2:0] color_signal; // 3ビットのカラー信号を受け取るためのワイヤー
    
    // （元の VGA_BW_simple の .video(video_signal) の部分を書き換え）
    VGA_BW_simple vga_core (
        .clk_25mhz(clk_25mhz),
        .reset(sys_reset),
        .hsync(vga_hsync),
        .vsync(vga_vsync),
        .video_rgb(color_signal) // ここを変更！
    );
```

#### 【ピンへの割り当て変更】
白黒の時は `assign vga_r = video_signal;` と全て同じ信号を繋いでいましたが、カラー信号の各ビット（[2], [1], [0]）をそれぞれの色に割り当てます。

```verilog
    // 3ビットの信号をR,G,Bのピンに振り分ける
    assign vga_r = color_signal[2]; // 3ビット目(最上位)を赤へ
    assign vga_g = color_signal[1]; // 2ビット目を緑へ
    assign vga_b = color_signal[0]; // 1ビット目(最下位)を青へ
```

---

## 🚀 ビルドと確認

1. 上記の2つのファイルを編集して保存します。
2. Gowin EDAの左画面（Designタブ）でファイルにエラーマークがついていないか確認します。
3. これまでと同じように **Process → Rebuild All** を実行します！
4. 出来上がった `.fs` ファイルを書き込みます。

うまくいけば、モニターに**美しい8色の縦縞カラーバー**が表示されるはずです！

> **Tips: アートプログラミングの第一歩！**
> 慣れてきたら、`VGA_BW_simple.v`の中の `video_rgb <= ...` の部分を数式に変えて遊んでみましょう。
> 例：`video_rgb <= {h_count[5], v_count[5], h_count[6]};` （とてもサイケデリックな模様になります🎨）
