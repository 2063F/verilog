module top(
    input sys_clk,     // 27MHz
    output clk_10hz
);

clk_divider_10hz u_divider(
    .clk_in(sys_clk),
    .clk_10hz(clk_10hz)
);

endmodule
```

**4. ピン割り当て（制約ファイル）**

`.cst`ファイルで物理ピンを指定します：
```
IO_LOC "sys_clk" 52;      // 27MHz入力ピン（実際のボードに合わせて変更）
IO_LOC "clk_10hz" J11;     // 出力ピン（使用するピン番号に変更）