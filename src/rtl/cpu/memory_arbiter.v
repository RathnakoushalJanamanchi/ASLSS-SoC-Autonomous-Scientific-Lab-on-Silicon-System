`timescale 1ns / 1ps
module memory_arbiter(
    input wire clk,
    input wire rst,

    // =========================
    // CORE INTERFACES (4 cores)
    // =========================
    input  wire [31:0] addr0, input wire [31:0] wdata0,
    input  wire read0, write0,
    output reg  [31:0] rdata0,
    output reg  ready0,

    input  wire [31:0] addr1, input wire [31:0] wdata1,
    input  wire read1, write1,
    output reg  [31:0] rdata1,
    output reg  ready1,

    input  wire [31:0] addr2, input wire [31:0] wdata2,
    input  wire read2, write2,
    output reg  [31:0] rdata2,
    output reg  ready2,

    input  wire [31:0] addr3, input wire [31:0] wdata3,
    input  wire read3, write3,
    output reg  [31:0] rdata3,
    output reg  ready3,

    // =========================
    // SHARED MEMORY INTERFACE
    // =========================
    output reg  [31:0] mem_addr,
    output reg  [31:0] mem_wdata,
    output reg         mem_read,
    output reg         mem_write,
    input  wire [31:0] mem_rdata,
    input  wire        mem_ready
);

//////////////////////////////////////////////////
// SIMPLE PRIORITY ARBITER
// Priority: core0 > core1 > core2 > core3
//////////////////////////////////////////////////

always @(*) begin
    // defaults
    mem_addr  = 32'd0;
    mem_wdata = 32'd0;
    mem_read  = 1'b0;
    mem_write = 1'b0;

    if (read0 || write0) begin
        mem_addr  = addr0;
        mem_wdata = wdata0;
        mem_read  = read0;
        mem_write = write0;
    end
    else if (read1 || write1) begin
        mem_addr  = addr1;
        mem_wdata = wdata1;
        mem_read  = read1;
        mem_write = write1;
    end
    else if (read2 || write2) begin
        mem_addr  = addr2;
        mem_wdata = wdata2;
        mem_read  = read2;
        mem_write = write2;
    end
    else if (read3 || write3) begin
        mem_addr  = addr3;
        mem_wdata = wdata3;
        mem_read  = read3;
        mem_write = write3;
    end
end

//////////////////////////////////////////////////
// RESPONSE ROUTING
//////////////////////////////////////////////////

always @(*) begin
    // default
    rdata0 = 0; ready0 = 0;
    rdata1 = 0; ready1 = 0;
    rdata2 = 0; ready2 = 0;
    rdata3 = 0; ready3 = 0;

    if (read0 || write0) begin
        rdata0 = mem_rdata;
        ready0 = mem_ready;
    end
    else if (read1 || write1) begin
        rdata1 = mem_rdata;
        ready1 = mem_ready;
    end
    else if (read2 || write2) begin
        rdata2 = mem_rdata;
        ready2 = mem_ready;
    end
    else if (read3 || write3) begin
        rdata3 = mem_rdata;
        ready3 = mem_ready;
    end
end

endmodule
