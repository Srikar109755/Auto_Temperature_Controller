`timescale 1ns / 1ps

module Simple_TB;
    reg clk, reset;
    reg [7:0] c_temp, d_temp;
    reg [4:0] temp_tol;
    wire ht_on, cl_on;

    Design atc (
        .clk(clk),
        .reset(reset),
        .current_temp(c_temp),
        .desired_temp(d_temp),
        .temp_tolerance(temp_tol),
        .heater_on(ht_on),
        .cooler_on(cl_on)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        reset = 1;
        c_temp = 8'd0;
        d_temp = 8'd0;
        temp_tol = 4'd2;

        #20;
        reset = 0;

        // Run test cases
        apply_temp(65, 70, 4);  // Should go to HEATING
        apply_temp(72, 70, 4);  // Should go to COOLING
        apply_temp(70, 70, 4);  // Should go to IDLE
        apply_temp(50, 70, 4);  // HEATING
        apply_temp(90, 70, 4);  // COOLING

        #50;
        $stop;
    end

    // Task to apply temp + tolerance + wait
    task apply_temp(input [7:0] cur, input [7:0] des, input [4:0] tol);
    begin
        c_temp = cur;
        d_temp = des;
        temp_tol = tol;
        repeat(3) @(posedge clk);
    end
    endtask

    // Monitor
    initial begin
        $monitor($time, " Temp=%d, Desired=%d, Tol=%d, Heater=%b, Cooler=%b, State=%b",
                 c_temp, d_temp, temp_tol, ht_on, cl_on, atc.present_state);
    end
endmodule
