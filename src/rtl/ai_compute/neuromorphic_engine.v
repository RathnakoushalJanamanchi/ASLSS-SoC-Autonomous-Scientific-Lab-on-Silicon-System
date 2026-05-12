`timescale 1ns / 1ps

module neuromorphic_engine #(
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 16
)(
    input wire clk,
    input wire rst,

    //////////////////////////////////////////////////
    // CONTROL
    //////////////////////////////////////////////////
    input wire start,
    output reg ready,

    //////////////////////////////////////////////////
    // SPIKE INPUTS (FIXED WIDTH = 8-bit)
    //////////////////////////////////////////////////
    input wire [DATA_WIDTH-1:0] spike0,
    input wire [DATA_WIDTH-1:0] spike1,
    input wire [DATA_WIDTH-1:0] spike2,
    input wire [DATA_WIDTH-1:0] spike3,

    //////////////////////////////////////////////////
    // NEURON OUTPUTS
    //////////////////////////////////////////////////
    output reg neuron_fire0,
    output reg neuron_fire1,
    output reg neuron_fire2,
    output reg neuron_fire3
);

//////////////////////////////////////////////////
// INTERNAL ACCUMULATORS
//////////////////////////////////////////////////
reg [ACC_WIDTH-1:0] acc0;
reg [ACC_WIDTH-1:0] acc1;
reg [ACC_WIDTH-1:0] acc2;
reg [ACC_WIDTH-1:0] acc3;

//////////////////////////////////////////////////
// THRESHOLD
//////////////////////////////////////////////////
localparam THRESHOLD = 16'd50;

//////////////////////////////////////////////////
// COMPUTE LOGIC
//////////////////////////////////////////////////
always @(posedge clk or posedge rst) begin
    if (rst) begin
        acc0 <= 0;
        acc1 <= 0;
        acc2 <= 0;
        acc3 <= 0;

        neuron_fire0 <= 0;
        neuron_fire1 <= 0;
        neuron_fire2 <= 0;
        neuron_fire3 <= 0;

        ready <= 0;
    end else begin
        ready <= 0;

        if (start) begin
            //////////////////////////////////////////////////
            // ACCUMULATE SPIKES
            //////////////////////////////////////////////////
            acc0 <= acc0 + spike0;
            acc1 <= acc1 + spike1;
            acc2 <= acc2 + spike2;
            acc3 <= acc3 + spike3;

            //////////////////////////////////////////////////
            // THRESHOLD ACTIVATION
            //////////////////////////////////////////////////
            neuron_fire0 <= (acc0 > THRESHOLD);
            neuron_fire1 <= (acc1 > THRESHOLD);
            neuron_fire2 <= (acc2 > THRESHOLD);
            neuron_fire3 <= (acc3 > THRESHOLD);

            ready <= 1'b1;
        end
    end
end

endmodule
