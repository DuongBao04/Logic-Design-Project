`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2024 10:14:02 PM
// Design Name: 
// Module Name: Clock
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

module clock(
    input clk,
    input reset,
    input alarm_ready,
    input setup_ready,
    input [6:0] alarm_hour,
    input [6:0] alarm_minute,
    input [6:0] setup_hour,
    input [6:0] setup_minute,
    output reg [6:0] hour,
    output reg [6:0] minute,
    output reg [6:0] second,
    output reg [6:0] hundredth,
    output reg alarm_ring
);
    reg [29:0] count = 30'd0;
    reg setup_ready_sync, alarm_ready_sync;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            setup_ready_sync <= 0;
            alarm_ready_sync <= 0;
        end else begin
            setup_ready_sync <= setup_ready;
            alarm_ready_sync <= alarm_ready;
        end
    end

    // Khối kiểm tra alarm
    always @(posedge clk) begin
        if (reset) 
            alarm_ring <= 0;
        else if (alarm_ready_sync && (hour == alarm_hour) && (minute == alarm_minute))
            alarm_ring <= 1;
        else 
            alarm_ring <= 0;
    end

    // Khối xử lý thời gian
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            hour <= 7'd0;
            minute <= 7'd0;
            second <= 7'd0;
            hundredth <= 7'd0;
            count <= 30'd0;
        end else if (setup_ready_sync) begin
            hour <= setup_hour;
            minute <= setup_minute;
            second <= 7'd0;
            hundredth <= 7'd0;
            count <= 30'd0;
        end else begin
            if (count == 1250000) begin
                count <= 0;
                if (hundredth == 7'd99) begin
                    hundredth <= 7'd0;
                    if (second == 7'd59) begin
                        second <= 0;
                        if (minute == 7'd59) begin
                            minute <= 0;
                            if (hour == 7'd23) 
                                hour <= 0;
                            else 
                                hour <= hour + 1;
                        end else 
                            minute <= minute + 1;
                    end else 
                        second <= second + 1;
                end else 
                    hundredth <= hundredth + 1;
            end else 
                count <= count + 1; 
        end        
    end
endmodule


