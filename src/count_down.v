`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/24/2024 12:09:31 PM
// Design Name: 
// Module Name: CountDownTimer
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


module count_down(
    input clk,               
    input reset,
    input start,
    input add_minute_signal,
    input add_second_signal,
    output reg [6:0] hour,             
    output reg [6:0] minute,
    output reg [6:0] second,
    output reg [6:0] hundredth,
    output reg done_signal
);
    reg [29:0] count;
    reg start_sync, add_min_sync, add_sec_sync;
    reg start_first_time;
    reg add_min_last, add_sec_last;
    wire add_min_edge = add_min_sync && (!add_min_last);
    wire add_sec_edge = add_sec_sync && (!add_sec_last);

    always @(posedge clk) begin
        add_min_last <= add_min_sync; 
        add_sec_last <= add_sec_sync;
    end
        
    always @(posedge clk) begin
        if ((hour == 0) && (minute == 0) && (second == 0) && (hundredth == 0)) begin
            start_sync <= 0;   
        end else begin
            start_sync <= start; 
        end
    
        if (start_sync) begin
            add_min_sync <= 0;
            add_sec_sync <= 0; 
        end else begin
            add_min_sync <= add_minute_signal;
            add_sec_sync <= add_second_signal;
        end
    end
    
    always @(posedge clk) begin
        if (reset) begin
            hour <= 7'd0;
            minute <= 7'd0;
            second <= 7'd0;
            hundredth <= 7'd0;
            count <= 30'd0;
            done_signal <= 1'b0;
            start_first_time <= 1'b0;
        end
        else if (add_min_edge) minute <= minute + 7'd1;
        else if (add_sec_edge) second <= second + 7'd1;
        else if (start_sync) begin
            start_first_time <= 1;
            done_signal <= 0;
            if (count == 1250000) begin
                count <= 0;
                if (hundredth == 0) begin
                    hundredth <= 7'd99;
                    if (second == 0) begin
                        second <= 7'd59;
                        if (minute == 0) begin
                            minute <= 7'd59;
                            if (hour != 0) begin
                                hour <= hour - 1;
                            end
                        end else begin
                            minute <= minute - 1;
                        end
                    end else begin
                        second <= second - 1;
                    end
                end else begin
                    hundredth <= hundredth - 1;
                end
            end 
            else count <= count + 1;
        end
        else if (hour == 0 && minute == 0 && second == 0 && hundredth == 0 && start_first_time == 1) 
            done_signal <= 1;
    end
endmodule

