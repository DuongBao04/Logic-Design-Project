`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2024 08:49:16 PM
// Design Name: 
// Module Name: Seven_Segment
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


module Seven_Segment(
    input wire [3:0] number,
    output reg [6:0] segment
    );
always@*
    case(number)
        4'd0: segment = 7'b0000001;
        4'd1: segment = 7'b1001111;
        4'd2: segment = 7'b0010010;
        4'd3: segment = 7'b0000110;
        4'd4: segment = 7'b1001100;
        4'd5: segment = 7'b0100100;
        4'd6: segment = 7'b0100000;
        4'd7: segment = 7'b0001111;
        4'd8: segment = 7'b0000000;
        4'd9: segment = 7'b0000100;   
    endcase
endmodule
