`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/26/2024 10:35:17 PM
// Design Name: 
// Module Name: alarm
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

module alarm(
    input clk,
    input reset,
    input start,
    input add_hour_signal,
    input add_minute_signal,
    output reg [6:0] alarm_hour,
    output reg [6:0] alarm_minute,
    output reg alarm_set
);
    reg add_hour_last, add_min_last;
    wire add_hour_edge = add_hour_last && (!add_hour_signal);
    wire add_min_edge = add_min_last && (!add_minute_signal);

    // add only in posedge
    always @(posedge clk) begin
        add_hour_last <= add_hour_signal; 
        add_min_last <= add_minute_signal;
    end
    
    // Set start 
    always @(posedge clk) begin
        if (reset) begin
            alarm_hour <= 7'd0;
            alarm_minute <= 7'd0;
            alarm_set <= 0;
        end
        else if (start) begin
            alarm_set <= 1;
        end
        else if (add_hour_edge) begin
            alarm_hour <= (alarm_hour == 7'd23) ? 7'd0 : alarm_hour + 1;
        end
        else if (add_min_edge) begin
            alarm_minute <= (alarm_minute == 7'd59) ? 7'd0 : alarm_minute + 1;
        end
    end

endmodule
