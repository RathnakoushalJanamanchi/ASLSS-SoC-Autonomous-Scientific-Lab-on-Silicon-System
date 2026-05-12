`timescale 1ns/1ps
module vexriscv_cluster #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 32,
    parameter CORE_NUM   = 4,
    parameter IRQ_NUM    = 32
)(
    input  wire clk,
    input  wire rst,

    // Shared memory interface
    output wire [ADDR_WIDTH-1:0] mem_addr,
    output wire [DATA_WIDTH-1:0] mem_wdata,
    output wire                  mem_write,
    output wire                  mem_read,
    input  wire [DATA_WIDTH-1:0] mem_rdata,
    input  wire                  mem_ready,

    // NoC ports
    input  wire [DATA_WIDTH+7:0] noc_local_in0,
    input  wire                  noc_local_valid0,
    output wire [DATA_WIDTH+7:0] noc_local_out0,
    output wire                  noc_local_out_valid0,
    output wire                  noc_local_ready0,

    input  wire [DATA_WIDTH+7:0] noc_local_in1,
    input  wire                  noc_local_valid1,
    output wire [DATA_WIDTH+7:0] noc_local_out1,
    output wire                  noc_local_out_valid1,
    output wire                  noc_local_ready1,

    input  wire [DATA_WIDTH+7:0] noc_local_in2,
    input  wire                  noc_local_valid2,
    output wire [DATA_WIDTH+7:0] noc_local_out2,
    output wire                  noc_local_out_valid2,
    output wire                  noc_local_ready2,

    input  wire [DATA_WIDTH+7:0] noc_local_in3,
    input  wire                  noc_local_valid3,
    output wire [DATA_WIDTH+7:0] noc_local_out3,
    output wire                  noc_local_out_valid3,
    output wire                  noc_local_ready3,

    // external interrupts
    input wire [IRQ_NUM-1:0] ext_irq,
    input wire [(CORE_NUM*IRQ_NUM)-1:0] irq_mask_flat
);

//////////////////////////////////////////////////////
// IRQ
//////////////////////////////////////////////////////
wire [CORE_NUM-1:0] irq_internal;

cpu_interrupt_controller #(
    .CORE_NUM(CORE_NUM),
    .IRQ_NUM(IRQ_NUM)
) irq_controller (
    .clk(clk),
    .rst(rst),
    .ext_irq(ext_irq),
    .irq_mask_flat(irq_mask_flat),
    .irq_out(irq_internal)
);

//////////////////////////////////////////////////////
// PER-CORE MEMORY SIGNALS
//////////////////////////////////////////////////////
wire [31:0] addr0, wdata0, rdata0;
wire [31:0] addr1, wdata1, rdata1;
wire [31:0] addr2, wdata2, rdata2;
wire [31:0] addr3, wdata3, rdata3;

wire read0, write0, ready0;
wire read1, write1, ready1;
wire read2, write2, ready2;
wire read3, write3, ready3;

//////////////////////////////////////////////////////
// CPU CORES (NOW ISOLATED)
//////////////////////////////////////////////////////
vexriscv_core_wrapper core0 (
    .clk(clk),
    .rst(rst),
    .mem_addr(addr0),
    .mem_wdata(wdata0),
    .mem_write(write0),
    .mem_read(read0),
    .mem_rdata(rdata0),
    .mem_ready(ready0),
    .noc_local_in(noc_local_in0),
    .noc_local_valid(noc_local_valid0),
    .noc_local_out(noc_local_out0),
    .noc_local_out_valid(noc_local_out_valid0),
    .noc_local_ready(noc_local_ready0),
    .irq(irq_internal[0])
);

vexriscv_core_wrapper core1 (
    .clk(clk),
    .rst(rst),
    .mem_addr(addr1),
    .mem_wdata(wdata1),
    .mem_write(write1),
    .mem_read(read1),
    .mem_rdata(rdata1),
    .mem_ready(ready1),
    .noc_local_in(noc_local_in1),
    .noc_local_valid(noc_local_valid1),
    .noc_local_out(noc_local_out1),
    .noc_local_out_valid(noc_local_out_valid1),
    .noc_local_ready(noc_local_ready1),
    .irq(irq_internal[1])
);

vexriscv_core_wrapper core2 (
    .clk(clk),
    .rst(rst),
    .mem_addr(addr2),
    .mem_wdata(wdata2),
    .mem_write(write2),
    .mem_read(read2),
    .mem_rdata(rdata2),
    .mem_ready(ready2),
    .noc_local_in(noc_local_in2),
    .noc_local_valid(noc_local_valid2),
    .noc_local_out(noc_local_out2),
    .noc_local_out_valid(noc_local_out_valid2),
    .noc_local_ready(noc_local_ready2),
    .irq(irq_internal[2])
);

vexriscv_core_wrapper core3 (
    .clk(clk),
    .rst(rst),
    .mem_addr(addr3),
    .mem_wdata(wdata3),
    .mem_write(write3),
    .mem_read(read3),
    .mem_rdata(rdata3),
    .mem_ready(ready3),
    .noc_local_in(noc_local_in3),
    .noc_local_valid(noc_local_valid3),
    .noc_local_out(noc_local_out3),
    .noc_local_out_valid(noc_local_out_valid3),
    .noc_local_ready(noc_local_ready3),
    .irq(irq_internal[3])
);

//////////////////////////////////////////////////////
// MEMORY ARBITER (KEY FIX)
//////////////////////////////////////////////////////
memory_arbiter arbiter (
    .clk(clk),
    .rst(rst),

    // Core 0
    .addr0(addr0), .wdata0(wdata0),
    .read0(read0), .write0(write0),
    .rdata0(rdata0), .ready0(ready0),

    // Core 1
    .addr1(addr1), .wdata1(wdata1),
    .read1(read1), .write1(write1),
    .rdata1(rdata1), .ready1(ready1),

    // Core 2
    .addr2(addr2), .wdata2(wdata2),
    .read2(read2), .write2(write2),
    .rdata2(rdata2), .ready2(ready2),

    // Core 3
    .addr3(addr3), .wdata3(wdata3),
    .read3(read3), .write3(write3),
    .rdata3(rdata3), .ready3(ready3),

    // Shared memory
    .mem_addr(mem_addr),
    .mem_wdata(mem_wdata),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .mem_rdata(mem_rdata),
    .mem_ready(mem_ready)
);

endmodule
