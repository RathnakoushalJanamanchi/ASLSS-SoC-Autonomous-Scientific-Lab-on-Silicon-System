`timescale 1ns / 1ps

module tmr_controller(

    input wire clk,
    input wire rst,

    // Outputs from redundant modules
    input wire [31:0] out_a,
    input wire [31:0] out_b,
    input wire [31:0] out_c,

    // Voted output
    output reg [31:0] voted_output,

    // Error detection
    output reg fault_detected

);

always @(posedge clk or posedge rst) begin

    if(rst) begin
        voted_output <= 0;
        fault_detected <= 0;
    end

    else begin

        // Majority voting
        voted_output <= (out_a & out_b) |
                        (out_a & out_c) |
                        (out_b & out_c);

        // Fault detection
        if((out_a != out_b) || (out_a != out_c) || (out_b != out_c))
            fault_detected <= 1;
        else
            fault_detected <= 0;

    end

end

endmodule
