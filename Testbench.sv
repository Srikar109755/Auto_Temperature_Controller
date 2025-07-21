`timescale 1ns / 1ps

module Testbench();
    reg clk;
    reg reset;
    reg [7:0] current_temp;
    reg [7:0] desired_temp;
    reg [4:0] temp_tolerance;
    wire heater_on;
    wire cooler_on;

    // Instantiate the DUT
    Design dut(
        .clk(clk),
        .reset(reset),
        .current_temp(current_temp),
        .desired_temp(desired_temp),
        .temp_tolerance(temp_tolerance),
        .heater_on(heater_on),
        .cooler_on(cooler_on)
    );

    // Parameters
    parameter integer HEATER_CYCLE_DELAY = 10;
    parameter integer COOLER_CYCLE_DELAY = 5;
    parameter integer HEATER_STEP = 2;
    parameter integer COOLER_STEP = 3;

    reg [31:0] heat_tick, cool_tick;

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Temperature update logic
    always @(posedge clk) begin
        if (reset) begin
            heat_tick <= 0;
            cool_tick <= 0;
        end else begin
            if (heater_on)
                heat_tick <= heat_tick + 1;
            else
                heat_tick <= 0;

            if (cooler_on)
                cool_tick <= cool_tick + 1;
            else
                cool_tick <= 0;

            if (heater_on && heat_tick >= HEATER_CYCLE_DELAY)
                current_temp <= current_temp + HEATER_STEP;
            else if (cooler_on && cool_tick >= COOLER_CYCLE_DELAY)
                current_temp <= current_temp - COOLER_STEP;
        end
    end

    // Test case task
    task automatic test_case(input [7:0] init_temp, input [7:0] set_temp, input [31:0] wait_time);
    begin
        $display("\nStarting test case: Current = %0d, Desired = %0d", init_temp, set_temp);
        current_temp <= init_temp;
        desired_temp <= set_temp;
        #wait_time;

        if ((heater_on === 1'b0 && cooler_on === 1'b0) &&
            (current_temp >= desired_temp - temp_tolerance &&
             current_temp <= desired_temp + temp_tolerance)) begin
            $display("Test case passed. Final temp = %0d", current_temp);
        end else begin
            $error("Test case failed. Final temp = %0d, Heater = %b, Cooler = %b",
                   current_temp, heater_on, cooler_on);
        end
    end
    endtask

    // Main stimulus
    initial begin
        reset = 1;
        current_temp = 0;
        desired_temp = 0;
        temp_tolerance = 5'd2;

        #100;
        reset = 0;

        // Heating case
        test_case(60, 70, 2000);

        // Cooling case
        test_case(80, 70, 3000);

        // Extended heating
        test_case(40, 70, 4000);

        // Extended cooling
        test_case(95, 70, 4000);

        $display("All test cases completed.");
        #1000;
        $stop;
    end

    // State monitor for debug
    initial begin
        $monitor($time, " Temp = %0d, Desired = %0d, Heater = %b, Cooler = %b, State = %b",
                 current_temp, desired_temp, heater_on, cooler_on, dut.present_state);
    end
endmodule
