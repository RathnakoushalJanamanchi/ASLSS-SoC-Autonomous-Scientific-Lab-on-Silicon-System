`timescale 1ns / 1ps

module matrix_compute_unit(
    input wire clk,
    input wire rst,

    //////////////////////////////////////////////////
    // CONTROL
    //////////////////////////////////////////////////
    input wire start,
    output reg done,

    //////////////////////////////////////////////////
    // INPUT VECTOR (8-bit each)
    //////////////////////////////////////////////////
    input wire [7:0] v0,
    input wire [7:0] v1,
    input wire [7:0] v2,
    input wire [7:0] v3,

    //////////////////////////////////////////////////
    // MATRIX (8-bit each)
    //////////////////////////////////////////////////
    input wire [7:0] m00, m01, m02, m03,
    input wire [7:0] m10, m11, m12, m13,
    input wire [7:0] m20, m21, m22, m23,
    input wire [7:0] m30, m31, m32, m33,

    //////////////////////////////////////////////////
    // OUTPUT VECTOR (16-bit results)
    //////////////////////////////////////////////////
    output reg [15:0] r0,
    output reg [15:0] r1,
    output reg [15:0] r2,
    output reg [15:0] r3
);

//////////////////////////////////////////////////
// INTERNAL WIRES
//////////////////////////////////////////////////
wire rram_ready;
wire neuro_ready;

wire neuron_fire0;
wire neuron_fire1;
wire neuron_fire2;
wire neuron_fire3;

//////////////////////////////////////////////////
// MATRIX COMPUTE (MAIN LOGIC)
//////////////////////////////////////////////////
always @(posedge clk or posedge rst) begin
    if (rst) begin
        r0 <= 0;
        r1 <= 0;
        r2 <= 0;
        r3 <= 0;
        done <= 0;
    end else begin
        done <= 0;

        if (start) begin
            //////////////////////////////////////////////////
            // MAC OPERATIONS
            //////////////////////////////////////////////////
            r0 <= m00*v0 + m01*v1 + m02*v2 + m03*v3;
            r1 <= m10*v0 + m11*v1 + m12*v2 + m13*v3;
            r2 <= m20*v0 + m21*v1 + m22*v2 + m23*v3;
            r3 <= m30*v0 + m31*v1 + m32*v2 + m33*v3;

            done <= 1'b1;
        end
    end
end

//////////////////////////////////////////////////
// RRAM COMPUTE FABRIC (FIXED INTERFACE)
//////////////////////////////////////////////////
rram_compute_fabric rram_unit(
    .clk(clk),
    .rst(rst),
    .start(start),
    .ready(rram_ready)
    // NOTE: no extra ports assumed (kept minimal & safe)
);

//////////////////////////////////////////////////
// NEUROMORPHIC ENGINE (FIXED)
//////////////////////////////////////////////////
neuromorphic_engine neuro_unit(
    .clk(clk),
    .rst(rst),
    .start(start),

    // FIXED WIDTH MATCH
    .spike0(v0),
    .spike1(v1),
    .spike2(v2),
    .spike3(v3),

    .neuron_fire0(neuron_fire0),
    .neuron_fire1(neuron_fire1),
    .neuron_fire2(neuron_fire2),
    .neuron_fire3(neuron_fire3),

    .ready(neuro_ready)
);

endmodule
