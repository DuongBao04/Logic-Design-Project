`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2024 08:52:42 PM
// Design Name: 
// Module Name: Display_Segment
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


module display_segment(
    input clk,
    input [6:0]left,[6:0]right,
    output reg [6:0]segment,
    output reg [3:0]select
    );
    
    reg [14:0]counter; // Giá trị ban đầu là [13:0]
    
    //From right to left
    wire [6:0]segment_0,segment_1,segment_2,segment_3;
    
    //mod 10 function
    function [3:0] mod_10(
        input [6:0] number
    );
        begin
            if (number >= 90) 
                mod_10 = 9;
            else if (number >= 80) 
                mod_10 = 8;
            else if (number >= 70) 
                mod_10 = 7;
            else if (number >= 60) 
                mod_10 = 6;
            else if (number >= 50) 
                mod_10 = 5;
            else if (number >= 40) 
                mod_10 = 4;
            else if (number >= 30) 
                mod_10 = 3;
            else if (number >= 20) 
                mod_10 = 2;
            else if (number >= 10) 
                mod_10 = 1;
            else 
                mod_10 = 0;
        end
    endfunction
    
    // For LSB right
    Seven_Segment LSB_right(
        .number(right - mod_10(right)*10),
        .segment(segment_0)
    );
    
    // For MSB right
    Seven_Segment MSB_right(
        .number(mod_10(right)),
        .segment(segment_1)
    );
    
    // For LSB left
    Seven_Segment LSB_left(
        .number(left - mod_10(left)*10),
        .segment(segment_2)
    );
    
    // For MSB left
    Seven_Segment MSB_left(
        .number(mod_10(left)),
        .segment(segment_3)
    );
    // Led _scanning
    
    
    always@ (posedge clk)
    begin
        counter <= counter + 1;
    end
    
    always@ (*)
    begin
        case(counter[13:12]) // Giá trị đúng là 13:12, nếu khác thì dành cho việc chạy tb
        2'b00: 
        begin
            segment <= segment_0;
            select <= 4'b0001;
        end
        2'b01: 
        begin
            segment <= segment_1;
            select <= 4'b0010;
        end
        2'b10: 
        begin
            segment <= segment_2;
            select <= 4'b0100;
        end
        2'b11: 
        begin
            segment = segment_3;
            select = 4'b1000;
        end        
        endcase
    end
endmodule
