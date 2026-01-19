// blink.sv
// 2024/02/05 by marsee

module blink #(
    parameter COUNT_LIMINT = 32'd12500000 // 50MHz / 4
) (
    input clk,
    output led
);
    wire clk;
    logic led = 0;
    logic [31:0] count = 0;

    always_ff @( posedge clk ) begin : COUNTER
        if(count < COUNT_LIMINT-1) begin
            count <= count + 32'd1;
        end else begin
            count <= 32'd0;
        end
    end

    always_ff @( posedge clk ) begin : LED_OUTPUT
        if(count == COUNT_LIMINT-1) begin
            led <= ~led;
        end
    end
endmodule