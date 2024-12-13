`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2024 08:09:07 AM
// Design Name: 
// Module Name: signal_controller
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


module signal_controller(
    input clk,
    input start,              
    input reset,              
    input [2:1] button,       
    input [3:0] state,        
    output reg start_countup, reset_countup, btn2_countup, btn1_countup,
    output reg start_countdown, reset_countdown, btn2_countdown, btn1_countdown,
    output reg start_alarm, reset_alarm, btn2_alarm, btn1_alarm,
    output reg start_setup, reset_setup, btn2_setup, btn1_setup,
    output reg reset_clock
);

    always @(posedge clk) begin
        start_countup <= 0; reset_countup <= 0; btn2_countup <= 0; btn1_countup <= 0;
        start_countdown <= 0; reset_countdown <= 0; btn2_countdown <= 0; btn1_countdown <= 0;
        start_alarm <= 0; reset_alarm <= 0; btn2_alarm <= 0; btn1_alarm <= 0;
        start_setup <= 0; reset_setup <= 0; btn2_setup <= 0; btn1_setup <= 0;

        case (state)
            4'b0000: begin
                reset_clock <= reset;
            end
            4'b1000: begin // Trạng thái COUNTUP
                start_countup <= start;
                reset_countup <= reset;
                btn2_countup <= button[2];
                btn1_countup <= button[1];
            end
            4'b0100: begin // Trạng thái COUNTDOWN
                start_countdown <= start;
                reset_countdown <= reset;
                btn2_countdown <= button[2];
                btn1_countdown <= button[1];
            end
            4'b0010: begin // Trạng thái ALARM
                start_alarm <= start;
                reset_alarm <= reset;
                btn2_alarm <= button[2];
                btn1_alarm <= button[1];
            end
            4'b0001: begin // Trạng thái SETUP
                start_setup <= start;
                reset_setup <= reset;
                btn2_setup <= button[2];
                btn1_setup <= button[1];
            end
            default: begin
                // Giữ tất cả tín hiệu ở 0 khi không ở trạng thái nào
                start_countup <= 0; reset_countup <= 0; btn2_countup <= 0; btn1_countup <= 0;
                start_countdown <= 0; reset_countdown <= 0; btn2_countdown <= 0; btn1_countdown <= 0;
                start_alarm <= 0; reset_alarm <= 0; btn2_alarm <= 0; btn1_alarm <= 0;
                start_setup <= 0; reset_setup <= 0; btn2_setup <= 0; btn1_setup <= 0;
            end
        endcase
    end

endmodule
