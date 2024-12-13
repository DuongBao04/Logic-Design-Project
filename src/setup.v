`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2024 10:16:36 AM
// Design Name: 
// Module Name: setup
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


module setup(
    input clk,
    input reset,
    input start,
    input add_hour_signal,
    input add_minute_signal,
    output reg [6:0] setup_hour,
    output reg [6:0] setup_minute,
    output reg setup_ready
    );
    
    reg add_hour_last, add_min_last;
    wire add_hour_edge = add_hour_last && (!add_hour_signal);
    wire add_min_edge = add_min_last && (!add_minute_signal);
    reg [29:0]ready_counter;
    
    // add only in posedge
    always @(posedge clk) begin
        add_hour_last <= add_hour_signal; 
        add_min_last <= add_minute_signal;
    end
    
    always @(posedge clk) begin
        if (reset) begin
            setup_hour <= 7'd0;
            setup_minute <= 7'd0;
            setup_ready <= 0;
            ready_counter <= 0;
        end else begin
            if (add_hour_edge) begin
                setup_hour <= (setup_hour == 7'd23) ? 7'd0 : setup_hour + 1;
            end
            if (add_min_edge) begin
                setup_minute <= (setup_minute == 7'd59) ? 7'd0 : setup_minute + 1;
            end

            // Turn on setup_ready and hold in 1 second
            if (start && ready_counter == 0) begin
                setup_ready <= 1;
                ready_counter <= 30'd62500000; // Hold in 1 secs
            end else if (ready_counter > 0) 
                ready_counter <= ready_counter - 1;
            else if (!start && ready_counter == 0) setup_ready <= 0;
        end
    end
endmodule

