`timescale 1ns / 1ps

module rram_compute_fabric #(
    parameter DATA_WIDTH = 8,
    parameter OUT_WIDTH  = 16
)(
    input wire clk,
    input wire rst,

    //////////////////////////////////////////////////
    // CONTROL
    //////////////////////////////////////////////////
    input wire start,
    output reg ready,

    //////////////////////////////////////////////////
    // INPUT VECTOR
    //////////////////////////////////////////////////
    input wire [DATA_WIDTH-1:0] in0,
    input wire [DATA_WIDTH-1:0] in1,
    input wire [DATA_WIDTH-1:0] in2,
    input wire [DATA_WIDTH-1:0] in3,

    //////////////////////////////////////////////////
    // WEIGHTS (RRAM STORED)
    //////////////////////////////////////////////////
    input wire [DATA_WIDTH-1:0] w00, w01, w02, w03,
    input wire [DATA_WIDTH-1:0] w10, w11, w12, w13,
    input wire [DATA_WIDTH-1:0] w20, w21, w22, w23,
    input wire [DATA_WIDTH-1:0] w30, w31, w32, w33,

    //////////////////////////////////////////////////
    // OUTPUT VECTOR
    //////////////////////////////////////////////////
    output reg [OUT_WIDTH-1:0] out0,
    output reg [OUT_WIDTH-1:0] out1,
    output reg [OUT_WIDTH-1:0] out2,
    output reg [OUT_WIDTH-1:0] out3
);

//////////////////////////////////////////////////
// INTERNAL PIPELINE
//////////////////////////////////////////////////
reg busy;

//////////////////////////////////////////////////
// COMPUTE LOGIC
//////////////////////////////////////////////////
always @(posedge clk or posedge rst) begin
    if (rst) begin
        out0  <= 0;
        out1  <= 0;
        out2  <= 0;
        out3  <= 0;
        ready <= 0;
        busy  <= 0;
    end else begin
        ready <= 0;

        if (start && !busy) begin
            busy <= 1'b1;

            //////////////////////////////////////////////////
            // MATRIX MULTIPLY (RRAM MAC STYLE)
            //////////////////////////////////////////////////
            out0 <= (w00 * in0) + (w01 * in1) + (w02 * in2) + (w03 * in3);
            out1 <= (w10 * in0) + (w11 * in1) + (w12 * in2) + (w13 * in3);
            out2 <= (w20 * in0) + (w21 * in1) + (w22 * in2) + (w23 * in3);
            out3 <= (w30 * in0) + (w31 * in1) + (w32 * in2) + (w33 * in3);

            ready <= 1'b1;
        end else begin
            busy <= 1'b0;
        end
    end
end

endmodule
