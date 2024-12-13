`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2024 02:46:25 PM
// Design Name: 
// Module Name: debouncer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module debouncer(
    input clk,
    input [3:0] button,
    output reg [3:0] debounced_button
    );
    reg [30:0] count0;
    reg [30:0] count1;
    reg [30:0] count2;
    reg [30:0] count3;

    always @(posedge clk) begin
        if (button [0]) begin
            count0 <= count0 + 1;
            if (count0 == 12500000) begin  //125MHz / 10
                debounced_button[0] <= 1;
            end
        end else begin
            count0 <= 0;
            debounced_button[0] <= 0;
        end
        
        if (button [1]) begin
            count1 <= count1 + 1;
            if (count1 == 12500000) begin  //125MHz / 10
                debounced_button[1] <= 1;
            end
        end else begin
            count1 <= 0;
            debounced_button[1] <= 0;
        end
        
        if (button [2]) begin
            count2 <= count2 + 1;
            if (count2 == 12500000) begin  //125MHz / 10
                debounced_button[2] <= 1;
            end
        end else begin
            count2 <= 0;
            debounced_button[2] <= 0;
        end
        
        if (button [3]) begin
            count3 <= count3 + 1;
            if (count3 == 12500000) begin  //125MHz / 10
                debounced_button[3] <= 1;
            end
        end else begin
            count3 <= 0;
            debounced_button[3] <= 0;
        end
        
    end

endmodule
