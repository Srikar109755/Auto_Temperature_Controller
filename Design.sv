`timescale 1ns / 1ps


module Design(
    input clk,
    input reset,
    input [7:0] current_temp,
    input [7:0] desired_temp,
    input [4:0] temp_tolerance,
    output reg heater_on,
    output reg cooler_on
);

    localparam [2:0] IDLE    = 3'b001,
                     HEATING = 3'b010,
                     COOLING = 3'b100;

    reg [2:0] present_state, next_state;

    // State register
    always @(posedge clk or posedge reset) begin
        if (reset)
            present_state <= IDLE;
        else
            present_state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        case (present_state)
            IDLE: begin
                if (current_temp < (desired_temp - temp_tolerance))
                    next_state = HEATING;
                else if (current_temp > (desired_temp + temp_tolerance))
                    next_state = COOLING;
                else
                    next_state = IDLE;
            end

            HEATING: begin
                if (current_temp >= desired_temp)
                    next_state = IDLE;
                else
                    next_state = HEATING;
            end

            COOLING: begin
                if (current_temp <= desired_temp)
                    next_state = IDLE;
                else
                    next_state = COOLING;
            end

            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            heater_on <= 0;
            cooler_on <= 0;
        end else begin
            case (present_state)
                IDLE: begin
                    heater_on <= 0;
                    cooler_on <= 0;
                end
                HEATING: begin
                    heater_on <= 1;
                    cooler_on <= 0;
                end
                COOLING: begin
                    heater_on <= 0;
                    cooler_on <= 1;
                end
            endcase
        end
    end
endmodule
