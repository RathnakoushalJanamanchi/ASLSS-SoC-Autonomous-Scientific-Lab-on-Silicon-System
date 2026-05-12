`timescale 1ns/1ps

module noc_mesh_4x4_final #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 4
)(
    input wire clk,
    input wire rst,

    input wire [DATA_WIDTH+7:0] local_in0, input wire local_valid0,
    input wire [DATA_WIDTH+7:0] local_in1, input wire local_valid1,
    input wire [DATA_WIDTH+7:0] local_in2, input wire local_valid2,
    input wire [DATA_WIDTH+7:0] local_in3, input wire local_valid3,
    input wire [DATA_WIDTH+7:0] local_in4, input wire local_valid4,
    input wire [DATA_WIDTH+7:0] local_in5, input wire local_valid5,
    input wire [DATA_WIDTH+7:0] local_in6, input wire local_valid6,
    input wire [DATA_WIDTH+7:0] local_in7, input wire local_valid7,
    input wire [DATA_WIDTH+7:0] local_in8, input wire local_valid8,
    input wire [DATA_WIDTH+7:0] local_in9, input wire local_valid9,
    input wire [DATA_WIDTH+7:0] local_in10, input wire local_valid10,
    input wire [DATA_WIDTH+7:0] local_in11, input wire local_valid11,
    input wire [DATA_WIDTH+7:0] local_in12, input wire local_valid12,
    input wire [DATA_WIDTH+7:0] local_in13, input wire local_valid13,
    input wire [DATA_WIDTH+7:0] local_in14, input wire local_valid14,
    input wire [DATA_WIDTH+7:0] local_in15, input wire local_valid15,

    output wire [DATA_WIDTH+7:0] local_out0, output wire local_out_valid0, output wire local_ready0,
    output wire [DATA_WIDTH+7:0] local_out1, output wire local_out_valid1, output wire local_ready1,
    output wire [DATA_WIDTH+7:0] local_out2, output wire local_out_valid2, output wire local_ready2,
    output wire [DATA_WIDTH+7:0] local_out3, output wire local_out_valid3, output wire local_ready3,
    output wire [DATA_WIDTH+7:0] local_out4, output wire local_out_valid4, output wire local_ready4,
    output wire [DATA_WIDTH+7:0] local_out5, output wire local_out_valid5, output wire local_ready5,
    output wire [DATA_WIDTH+7:0] local_out6, output wire local_out_valid6, output wire local_ready6,
    output wire [DATA_WIDTH+7:0] local_out7, output wire local_out_valid7, output wire local_ready7,
    output wire [DATA_WIDTH+7:0] local_out8, output wire local_out_valid8, output wire local_ready8,
    output wire [DATA_WIDTH+7:0] local_out9, output wire local_out_valid9, output wire local_ready9,
    output wire [DATA_WIDTH+7:0] local_out10, output wire local_out_valid10, output wire local_ready10,
    output wire [DATA_WIDTH+7:0] local_out11, output wire local_out_valid11, output wire local_ready11,
    output wire [DATA_WIDTH+7:0] local_out12, output wire local_out_valid12, output wire local_ready12,
    output wire [DATA_WIDTH+7:0] local_out13, output wire local_out_valid13, output wire local_ready13,
    output wire [DATA_WIDTH+7:0] local_out14, output wire local_out_valid14, output wire local_ready14,
    output wire [DATA_WIDTH+7:0] local_out15, output wire local_out_valid15, output wire local_ready15
);

/////////////////////////////////////////////////////
// Internal arrays
/////////////////////////////////////////////////////

wire [DATA_WIDTH+7:0] local_in [0:15];
wire local_valid [0:15];

wire [DATA_WIDTH+7:0] local_out [0:15];
wire local_out_valid [0:15];
wire local_ready [0:15];

/////////////////////////////////////////////////////
// Map inputs
/////////////////////////////////////////////////////

assign local_in[0]=local_in0; assign local_in[1]=local_in1;
assign local_in[2]=local_in2; assign local_in[3]=local_in3;
assign local_in[4]=local_in4; assign local_in[5]=local_in5;
assign local_in[6]=local_in6; assign local_in[7]=local_in7;
assign local_in[8]=local_in8; assign local_in[9]=local_in9;
assign local_in[10]=local_in10; assign local_in[11]=local_in11;
assign local_in[12]=local_in12; assign local_in[13]=local_in13;
assign local_in[14]=local_in14; assign local_in[15]=local_in15;

assign local_valid[0]=local_valid0; assign local_valid[1]=local_valid1;
assign local_valid[2]=local_valid2; assign local_valid[3]=local_valid3;
assign local_valid[4]=local_valid4; assign local_valid[5]=local_valid5;
assign local_valid[6]=local_valid6; assign local_valid[7]=local_valid7;
assign local_valid[8]=local_valid8; assign local_valid[9]=local_valid9;
assign local_valid[10]=local_valid10; assign local_valid[11]=local_valid11;
assign local_valid[12]=local_valid12; assign local_valid[13]=local_valid13;
assign local_valid[14]=local_valid14; assign local_valid[15]=local_valid15;

/////////////////////////////////////////////////////
// Router interconnect wires
/////////////////////////////////////////////////////

wire [DATA_WIDTH+7:0] e[0:15], n[0:15], s[0:15];
wire ev[0:15], nv[0:15], sv[0:15];
wire er[0:15], nr[0:15], sr[0:15];

/////////////////////////////////////////////////////
// Router generation
/////////////////////////////////////////////////////

genvar i,j;

generate
for(i=0;i<4;i=i+1) begin:row
for(j=0;j<4;j=j+1) begin:col

localparam IDX=i*4+j;

noc_router #(
.DATA_WIDTH(DATA_WIDTH),
.ADDR_WIDTH(ADDR_WIDTH),
.X_POS(j),
.Y_POS(i)
) r (

.clk(clk),
.rst(rst),

.local_in(local_in[IDX]),
.local_valid(local_valid[IDX]),
.local_ready(local_ready[IDX]),

.local_out(local_out[IDX]),
.local_out_valid(local_out_valid[IDX]),

.north_in(i==0 ? 0 : s[(i-1)*4+j]),
.north_valid(i==0 ? 0 : sv[(i-1)*4+j]),
.north_out(n[IDX]),
.north_out_valid(nv[IDX]),
.north_ready(nr[IDX]),

.south_in(i==3 ? 0 : n[(i+1)*4+j]),
.south_valid(i==3 ? 0 : nv[(i+1)*4+j]),
.south_out(s[IDX]),
.south_out_valid(sv[IDX]),
.south_ready(sr[IDX]),

.east_in(j==3 ? 0 : e[i*4+j+1]),
.east_valid(j==3 ? 0 : ev[i*4+j+1]),
.east_out(e[IDX]),
.east_out_valid(ev[IDX]),
.east_ready(er[IDX]),

.west_in(j==0 ? 0 : e[i*4+j-1]),
.west_valid(j==0 ? 0 : ev[i*4+j-1]),
.west_out(),
.west_out_valid(),
.west_ready()

);

end
end
endgenerate

/////////////////////////////////////////////////////
// Map outputs
/////////////////////////////////////////////////////

assign local_out0=local_out[0]; assign local_out1=local_out[1];
assign local_out2=local_out[2]; assign local_out3=local_out[3];
assign local_out4=local_out[4]; assign local_out5=local_out[5];
assign local_out6=local_out[6]; assign local_out7=local_out[7];
assign local_out8=local_out[8]; assign local_out9=local_out[9];
assign local_out10=local_out[10]; assign local_out11=local_out[11];
assign local_out12=local_out[12]; assign local_out13=local_out[13];
assign local_out14=local_out[14]; assign local_out15=local_out[15];

assign local_out_valid0=local_out_valid[0]; assign local_out_valid1=local_out_valid[1];
assign local_out_valid2=local_out_valid[2]; assign local_out_valid3=local_out_valid[3];
assign local_out_valid4=local_out_valid[4]; assign local_out_valid5=local_out_valid[5];
assign local_out_valid6=local_out_valid[6]; assign local_out_valid7=local_out_valid[7];
assign local_out_valid8=local_out_valid[8]; assign local_out_valid9=local_out_valid[9];
assign local_out_valid10=local_out_valid[10]; assign local_out_valid11=local_out_valid[11];
assign local_out_valid12=local_out_valid[12]; assign local_out_valid13=local_out_valid[13];
assign local_out_valid14=local_out_valid[14]; assign local_out_valid15=local_out_valid[15];

assign local_ready0=local_ready[0]; assign local_ready1=local_ready[1];
assign local_ready2=local_ready[2]; assign local_ready3=local_ready[3];
assign local_ready4=local_ready[4]; assign local_ready5=local_ready[5];
assign local_ready6=local_ready[6]; assign local_ready7=local_ready[7];
assign local_ready8=local_ready[8]; assign local_ready9=local_ready[9];
assign local_ready10=local_ready[10]; assign local_ready11=local_ready[11];
assign local_ready12=local_ready[12]; assign local_ready13=local_ready[13];
assign local_ready14=local_ready[14]; assign local_ready15=local_ready[15];

endmodule
