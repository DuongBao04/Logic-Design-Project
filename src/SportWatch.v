`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/24/2024 12:13:15 PM
// Design Name: 
// Module Name: SportWatch
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


module SportWatch(
    input clk,                                
    input [3:0] btn,
    input [1:0] sw,            
    output reg [3:0] mode_led,
    output wire cdown_done_signal,
    output wire alarm_ring,
    output wire alarm_ready,
    
    output wire [6:0] left_seg,
    output wire [3:0] left_dig,
    output wire [6:0] right_seg,
    output wire [3:0] right_dig
);
    reg [6:0] llseg,lrseg,rlseg,rrseg;
    reg [3:0] state;
    parameter   CLOCK = 4'b0000,
                SETUP = 4'b0001,
                ALARM = 4'b0010,
                COUNTDOWN = 4'b0100,
                COUNTUP = 4'b1000;
               
     
    wire [6:0] hour_clock,hour_countup,hour_countdown;
    wire [6:0] minute_clock, minute_countup, minute_countdown;
    wire [6:0] second_clock,second_countup, second_countdown;
    wire [6:0] hundredth_clock,hundredth_countup,hundredth_countdown;
    wire [6:0] alarm_hour, alarm_minute;
    wire [6:0] setup_hour, setup_minute;
    
    wire reset_clock;
    reg start_signal;
    wire start_countup, start_countdown, start_alarm, start_setup;
    reg reset_signal;
    wire reset_countup, reset_countdown, reset_alarm, reset_setup;
    wire load_signal, save_signal;
    wire add_second, add_minute;
    wire add_hour_alarm, add_minute_alarm;
    wire add_hour_setup, add_minute_setup;
    reg [30:0]reset_counter;
    reg reset_active;
    wire setup_ready;
    wire [3:0] button;
    reg button3_last;
    
    signal_controller SignalController(
        .clk(clk),
        .start(start_signal),
        .reset(reset_signal),
        .button(button[2:1]),
        .state(state[3:0]),
        .start_countup(start_countup), .reset_countup(reset_countup), .btn2_countup(save_signal), .btn1_countup(load_signal),
        .start_countdown(start_countdown), .reset_countdown(reset_countdown), .btn2_countdown(add_minute), .btn1_countdown(add_second),
        .start_alarm(start_alarm), .reset_alarm(reset_alarm), .btn2_alarm(add_hour_alarm), .btn1_alarm(add_minute_alarm),
        .start_setup(start_setup), .reset_setup(reset_setup), .btn2_setup(add_hour_setup), .btn1_setup(add_minute_setup),
        .reset_clock(reset_clock) 
    );
    
    debouncer Debounce(
        .clk(clk),
        .button(btn),
        .debounced_button(button)
    );
    
    clock Clock(
        .clk(clk),
        .reset(reset_clock),
        .setup_ready(setup_ready),
        .alarm_ready(alarm_ready),
        .alarm_hour(alarm_hour),
        .alarm_minute(alarm_minute),
        .setup_hour(setup_hour),
        .setup_minute(setup_minute),
        .hour(hour_clock),
        .minute(minute_clock),
        .second(second_clock),
        .hundredth(hundredth_clock),
        .alarm_ring(alarm_ring)
    );
    
    count_up CountUpMode(
        .clk(clk),
        .reset(reset_countup),
        .start(start_countup),
        .save_time_signal(save_signal),
        .load_time_signal(load_signal),
        .slot(sw),
        .hour(hour_countup),
        .minute(minute_countup),
        .second(second_countup),
        .hundredth(hundredth_countup)
    );
    
    count_down CountDownMode(
        .clk(clk),
        .reset(reset_countdown),
        .start(start_countdown),
        .add_minute_signal(add_minute),
        .add_second_signal(add_second),
        .hour(hour_countdown),
        .minute(minute_countdown),
        .second(second_countdown),
        .hundredth(hundredth_countdown),
        .done_signal(cdown_done_signal)
    );
    
    alarm AlarmMode(
        .clk(clk),
        .reset(reset_alarm),
        .start(start_alarm),
        .add_hour_signal(add_hour_alarm),
        .add_minute_signal(add_minute_alarm),
        .alarm_hour(alarm_hour),
        .alarm_minute(alarm_minute),
        .alarm_set(alarm_ready)
    );
    
    setup SetupMode(
        .clk(clk),
        .reset(reset_setup),
        .start(start_setup),
        .add_hour_signal(add_hour_setup),
        .add_minute_signal(add_minute_setup),
        .setup_hour(setup_hour),
        .setup_minute(setup_minute),
        .setup_ready(setup_ready)
    );
    
    display_segment Dis7SegLeft(
        .clk(clk),
        .left(llseg),
        .right(lrseg),
        .segment(left_seg),
        .select(left_dig)
    );
    
    display_segment Dis7SegRight(
        .clk(clk),
        .left(rlseg),
        .right(rrseg),
        .segment(right_seg),
        .select(right_dig)
    );
    
    function [3:0] changeMode;
        input [3:0] current_mode;
        begin
            case (current_mode)
                4'b0000: changeMode = 4'b0001;
                4'b0001: changeMode = 4'b0010; 
                4'b0010: changeMode = 4'b0100; 
                4'b0100: changeMode = 4'b1000; 
                4'b1000: changeMode = 4'b0000; 
            endcase
        end
    endfunction

    // BUTTONS Station
//    always @(posedge button[3]) begin   // Change state
//        state <= changeMode(state);
//        mode_led <= changeMode(mode_led);
//    end
    
    always @(posedge clk) begin
        if (button[3] && !button3_last) begin   
            state <= changeMode(state);
            mode_led <= changeMode(mode_led);
            start_signal <= 0; 
        end
        button3_last <= button[3];

        if (button[0]) begin
            reset_counter <= reset_counter + 1;
            if (reset_counter >= 250000000) begin
                reset_signal <= 1;
                reset_active <= 1;
                start_signal <= 0;
            end
        end
        else begin
            if (reset_counter > 100) begin
                if (!reset_active) // Chỉ thay đổi start_signal khi reset không còn active
                    start_signal <= ~start_signal;
            end
            else reset_signal <= 0;
            reset_active <= 0; // Đặt reset_active về 0 khi button đã nhả ra
            reset_counter <= 0;
        end
    end
    
    // Logic chuyển đổi trạng thái
    always @(state) begin
        case (state)
            CLOCK: begin
               llseg <= hour_clock;
               lrseg <= minute_clock;
               rlseg <= second_clock;
               rrseg <= hundredth_clock;
            end
            
            COUNTUP: begin
                llseg <= hour_countup;
                lrseg <= minute_countup;
                rlseg <= second_countup;
                rrseg <= hundredth_countup;
            end
            
            COUNTDOWN: begin
                llseg <= hour_countdown;
                lrseg <= minute_countdown;
                rlseg <= second_countdown;
                rrseg <= hundredth_countdown;
            end
            
            ALARM: begin
                llseg <= hour_clock;
                lrseg <= minute_clock;
                rlseg <= alarm_hour;
                rrseg <= alarm_minute;
            end
            
            SETUP: begin
                llseg <= hour_clock;
                lrseg <= minute_clock;
                rlseg <= setup_hour;
                rrseg <= setup_minute;
            end
            
        endcase
    end

endmodule

