`timescale 1ns / 1ps

module fault_detection_unit(

    input wire clk,
    input wire rst,

    input wire tmr_fault,
    input wire memory_error,
    input wire comm_error,
    input wire sensor_error,

    output reg fault_detected,
    output reg [2:0] fault_type
);

always @(posedge clk or posedge rst) begin

    if(rst) begin
        fault_detected <= 0;
        fault_type <= 0;
    end
    else begin

        fault_detected <= 0;
        fault_type <= 0;

        if(tmr_fault) begin
            fault_detected <= 1;
            fault_type <= 3'd1;
        end
        else if(memory_error) begin
            fault_detected <= 1;
            fault_type <= 3'd2;
        end
        else if(comm_error) begin
            fault_detected <= 1;
            fault_type <= 3'd3;
        end
        else if(sensor_error) begin
            fault_detected <= 1;
            fault_type <= 3'd4;
        end

    end

end

endmodule
