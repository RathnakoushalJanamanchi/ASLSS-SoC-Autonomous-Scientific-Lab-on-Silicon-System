`timescale 1ns/1ps
module aslss_soc_top(
    input wire clk,
    input wire rst,

    // 🔥 IMPORTANT: Add outputs to prevent optimization
    output wire [15:0] debug_out,
    output wire        debug_valid
);

//////////////////////////////////////////////////////////////
// KEEP CLOCK ALIVE (PREVENT DEAD DESIGN)
//////////////////////////////////////////////////////////////
reg [7:0] heartbeat;
always @(posedge clk or posedge rst) begin
    if (rst)
        heartbeat <= 8'd0;
    else
        heartbeat <= heartbeat + 1;
end

//////////////////////////////////////////////////////////////
// CPU CLUSTER
//////////////////////////////////////////////////////////////
wire [31:0] ext_irq = 32'b0;
wire [127:0] irq_mask_flat = 128'b0;

// MEMORY INTERFACE
wire [31:0] mem_addr;
wire [31:0] mem_wdata;
wire        mem_write;
wire        mem_read;
wire [31:0] mem_rdata = 32'b0;
wire        mem_ready = 1'b1;

// NOC INTERFACE
wire [39:0] cpu_noc_in  [0:3];
wire        cpu_noc_valid_in  [0:3];
wire [39:0] cpu_noc_out [0:3];
wire        cpu_noc_valid_out [0:3];
wire        cpu_noc_ready     [0:3];

// Tie-offs
genvar j;
generate
for(j=0;j<4;j=j+1) begin
    assign cpu_noc_in[j]       = 40'd0;
    assign cpu_noc_valid_in[j] = 1'b0;
    assign cpu_noc_ready[j]    = 1'b1;
end
endgenerate

vexriscv_cluster cpu_cluster(
    .clk(clk),
    .rst(rst),
    .ext_irq(ext_irq),
    .irq_mask_flat(irq_mask_flat),

    .mem_addr(mem_addr),
    .mem_wdata(mem_wdata),
    .mem_write(mem_write),
    .mem_read(mem_read),
    .mem_rdata(mem_rdata),
    .mem_ready(mem_ready),

    .noc_local_in0(cpu_noc_in[0]),
    .noc_local_valid0(cpu_noc_valid_in[0]),
    .noc_local_out0(cpu_noc_out[0]),
    .noc_local_out_valid0(cpu_noc_valid_out[0]),
    .noc_local_ready0(cpu_noc_ready[0]),

    .noc_local_in1(cpu_noc_in[1]),
    .noc_local_valid1(cpu_noc_valid_in[1]),
    .noc_local_out1(cpu_noc_out[1]),
    .noc_local_out_valid1(cpu_noc_valid_out[1]),
    .noc_local_ready1(cpu_noc_ready[1]),

    .noc_local_in2(cpu_noc_in[2]),
    .noc_local_valid2(cpu_noc_valid_in[2]),
    .noc_local_out2(cpu_noc_out[2]),
    .noc_local_out_valid2(cpu_noc_valid_out[2]),
    .noc_local_ready2(cpu_noc_ready[2]),

    .noc_local_in3(cpu_noc_in[3]),
    .noc_local_valid3(cpu_noc_valid_in[3]),
    .noc_local_out3(cpu_noc_out[3]),
    .noc_local_out_valid3(cpu_noc_valid_out[3]),
    .noc_local_ready3(cpu_noc_ready[3])
);

//////////////////////////////////////////////////////////////
// SENSOR ENGINE
//////////////////////////////////////////////////////////////
wire [15:0] sensor_data;
wire sensor_valid;

environment_sensor_engine sensors(
    .clk(clk),
    .rst(rst),
    .ext_sensor_data({heartbeat, heartbeat}), // 🔥 dynamic input
    .sensor_valid(1'b1),
    .data_out(sensor_data),
    .data_out_valid(sensor_valid),
    .data_out_ready(1'b1)
);

//////////////////////////////////////////////////////////////
// HYPOTHESIS ENGINE
//////////////////////////////////////////////////////////////
wire [7:0] hypothesis_id;
wire [7:0] confidence;
wire hypothesis_valid;

hypothesis_engine hypo(
    .clk(clk),
    .rst(rst),
    .observation_data(sensor_data),
    .pattern_flags(8'hAA),
    .observation_valid(sensor_valid),
    .hypothesis_id(hypothesis_id),
    .confidence(confidence),
    .hypothesis_valid(hypothesis_valid)
);

//////////////////////////////////////////////////////////////
// KNOWLEDGE GRAPH ENGINE
//////////////////////////////////////////////////////////////
wire kg_valid;
wire [7:0] kg_data;

knowledge_graph_engine kg(
    .clk(clk),
    .rst(rst),
    .discovery_valid(hypothesis_valid),
    .discovery_id(hypothesis_id),
    .discovery_type(8'd1),
    .query_request(1'b0),
    .query_node_id(8'd0),
    .result_valid(kg_valid),
    .result_data(kg_data)
);

//////////////////////////////////////////////////////////////
// SWARM ENGINE
//////////////////////////////////////////////////////////////
swarm_engine swarm(
    .clk(clk),
    .rst(rst),
    .msg_valid(kg_valid),
    .msg_type(kg_data),
    .sender_id(8'd1)
);

//////////////////////////////////////////////////////////////
// MATRIX COMPUTE (FULLY CONNECTED)
//////////////////////////////////////////////////////////////
wire mcu_done;
wire [15:0] mcu_r0, mcu_r1, mcu_r2, mcu_r3;

matrix_compute_unit mcu(
    .clk(clk),
    .rst(rst),
    .start(sensor_valid),

    .v0(hypothesis_id),
    .v1(confidence),
    .v2(kg_data),
    .v3(heartbeat),

    .m00(8'd1), .m01(8'd2), .m02(8'd3), .m03(8'd4),
    .m10(8'd5), .m11(8'd6), .m12(8'd7), .m13(8'd8),
    .m20(8'd9), .m21(8'd10), .m22(8'd11), .m23(8'd12),
    .m30(8'd13), .m31(8'd14), .m32(8'd15), .m33(8'd16),

    .done(mcu_done),
    .r0(mcu_r0), .r1(mcu_r1), .r2(mcu_r2), .r3(mcu_r3)
);

//////////////////////////////////////////////////////////////
// FINAL OUTPUT (CRITICAL FIX)
//////////////////////////////////////////////////////////////

// 🔥 Combine multiple subsystems → ensures full connectivity
assign debug_out =
        sensor_data ^
        {8'b0, hypothesis_id} ^
        {8'b0, kg_data} ^
        mcu_r0;

assign debug_valid = sensor_valid | hypothesis_valid | kg_valid | mcu_done;

endmodule
