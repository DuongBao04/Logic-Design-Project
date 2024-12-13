`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/24/2024 02:19:33 PM
// Design Name: 
// Module Name: Count_Up
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


module count_up(
    input clk,             
    input start,            
    input reset,
    input save_time_signal,
    input load_time_signal,
    input [1:0] slot,
    output reg [6:0] hour,
    output reg [6:0] minute,
    output reg [6:0] second,
    output reg [6:0] hundredth         
);
    reg start_sync;
    reg [29:0] count;
    reg [6:0] stored_hour[2:0];  
    reg [6:0] stored_minute[2:0];    
    reg [6:0] stored_second[2:0];     
    reg [6:0] stored_hundredth[2:0]; 
    
    always @(posedge clk) begin
        if (save_time_signal) start_sync <= 0;
        else if (load_time_signal) start_sync <= 0;
        else 
            start_sync <= start;
    end 
     
    always @(posedge clk) begin
        if (reset) begin
            hour <= 7'd0;
            minute <= 7'd0;
            second <= 7'd0;
            hundredth <= 7'd0;
            count <= 30'd0;
        end else begin
            if (save_time_signal) begin
                stored_hour[slot] <= hour;
                stored_minute[slot] <= minute;
                stored_second[slot] <= second;
                stored_hundredth[slot] <= hundredth;
            end
            if (load_time_signal) begin
                hour <= stored_hour[slot];
                minute <= stored_minute[slot];
                second <= stored_second[slot];
                hundredth <= stored_hundredth[slot];
            end
            if (start_sync) begin
                if (count == 1250000) begin // 1250000 ticks ~ 0.01s at 125 MHz clock
                    count <= 0;
                    if (hundredth == 7'd99) begin
                        hundredth <= 7'd0;
                        if (second == 7'd59) begin
                            second <= 0;
                            if(minute == 7'd59) begin
                                minute <= 0;
                                if(hour == 7'd23) begin
                                    hour <= 0;
                                    
                                end
                                else hour <= hour + 1;
                            end
                            else minute <= minute + 1;
                        end
                        else second <= second + 1;
                    end 
                    else hundredth <= hundredth + 1;
                end 
                else count <= count + 1;  
            end
        end
    end
endmodule
