module VGA_BW_simple(
    input wire clk_25mhz,      
    input wire reset,          
    output reg hsync,          
    output reg vsync,          
    output reg video           
);
    parameter H_DISPLAY     = 640;  
    parameter H_FRONT_PORCH = 16;   
    parameter H_SYNC_PULSE  = 96;   
    parameter H_BACK_PORCH  = 48;   
    parameter H_TOTAL       = 800;  
    parameter V_DISPLAY     = 480;  
    parameter V_FRONT_PORCH = 10;   
    parameter V_SYNC_PULSE  = 2;    
    parameter V_BACK_PORCH  = 33;   
    parameter V_TOTAL       = 525;  
    reg [9:0] h_count;  
    reg [9:0] v_count;  

    always @(posedge clk_25mhz or posedge reset) begin
        if (reset) begin
            h_count <= 0;
        end else begin
            if (h_count == H_TOTAL - 1)
                h_count <= 0;
            else
                h_count <= h_count + 1;
        end
    end

    always @(posedge clk_25mhz or posedge reset) begin
        if (reset) begin
            v_count <= 0;
        end else begin
            if (h_count == H_TOTAL - 1) begin
                if (v_count == V_TOTAL - 1)
                    v_count <= 0;
                else
                    v_count <= v_count + 1;
            end
        end
    end
    
    always @(posedge clk_25mhz) begin
        hsync <= (h_count >= (H_DISPLAY + H_FRONT_PORCH)) && 
                 (h_count < (H_DISPLAY + H_FRONT_PORCH + H_SYNC_PULSE));
        
        vsync <= (v_count >= (V_DISPLAY + V_FRONT_PORCH)) && 
                 (v_count < (V_DISPLAY + V_FRONT_PORCH + V_SYNC_PULSE));
    end

    wire display_on;
    assign display_on = (h_count < H_DISPLAY) && (v_count < V_DISPLAY);

    always @(posedge clk_25mhz) begin
        if (display_on) begin
            video <= h_count[5] ^ v_count[5];
        end else begin
            video <= 0;  
        end
    end
endmodule
