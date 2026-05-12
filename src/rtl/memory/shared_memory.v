`timescale 1ns/1ps

module shared_memory #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 10,
    parameter DEPTH      = 1024
)(
    input  wire clk,
    input  wire rst,

    // Port A (CPU cluster)
    input  wire [ADDR_WIDTH-1:0] addr_a,
    input  wire [DATA_WIDTH-1:0] wdata_a,
    input  wire write_a,
    input  wire read_a,
    output reg  [DATA_WIDTH-1:0] rdata_a,
    output reg  ready_a,

    // Port B (NoC / DMA)
    input  wire [ADDR_WIDTH-1:0] addr_b,
    input  wire [DATA_WIDTH-1:0] wdata_b,
    input  wire write_b,
    input  wire read_b,
    output reg  [DATA_WIDTH-1:0] rdata_b,
    output reg  ready_b
);

////////////////////////////////////////////////////
// Memory Array
////////////////////////////////////////////////////

(* ram_style = "block" *) 
reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

////////////////////////////////////////////////////
// Port A
////////////////////////////////////////////////////

always @(posedge clk or posedge rst) begin
    if(rst) begin
        ready_a <= 0;
        rdata_a <= 0;
    end
    else begin
        ready_a <= 0;

        if(write_a) begin
            mem[addr_a] <= wdata_a;
            ready_a <= 1;
        end
        else if(read_a) begin
            rdata_a <= mem[addr_a];
            ready_a <= 1;
        end

    end
end

////////////////////////////////////////////////////
// Port B
////////////////////////////////////////////////////

always @(posedge clk or posedge rst) begin
    if(rst) begin
        ready_b <= 0;
        rdata_b <= 0;
    end
    else begin
        ready_b <= 0;

        if(write_b) begin
            mem[addr_b] <= wdata_b;
            ready_b <= 1;
        end
        else if(read_b) begin
            rdata_b <= mem[addr_b];
            ready_b <= 1;
        end

    end
end

endmodule
