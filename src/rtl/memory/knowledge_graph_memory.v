`timescale 1ns/1ps

module knowledge_graph_memory #(
    parameter NODE_WIDTH = 32,
    parameter EDGE_WIDTH = 32,
    parameter NODE_DEPTH = 256,
    parameter EDGE_DEPTH = 512,
    parameter NODE_ADDR_WIDTH = 8,
    parameter EDGE_ADDR_WIDTH = 9
)(
    input  wire clk,
    input  wire rst,

    // Node interface
    input  wire [NODE_ADDR_WIDTH-1:0] node_addr,
    input  wire [NODE_WIDTH-1:0] node_wdata,
    input  wire node_write,
    input  wire node_read,
    output reg  [NODE_WIDTH-1:0] node_rdata,
    output reg node_ready,

    // Edge interface
    input  wire [EDGE_ADDR_WIDTH-1:0] edge_addr,
    input  wire [EDGE_WIDTH-1:0] edge_wdata,
    input  wire edge_write,
    input  wire edge_read,
    output reg  [EDGE_WIDTH-1:0] edge_rdata,
    output reg edge_ready
);

////////////////////////////////////////////////////
// Memory arrays
////////////////////////////////////////////////////

(* ram_style = "block" *)
reg [NODE_WIDTH-1:0] node_mem [0:NODE_DEPTH-1];

(* ram_style = "block" *)
reg [EDGE_WIDTH-1:0] edge_mem [0:EDGE_DEPTH-1];

////////////////////////////////////////////////////
// Node memory port
////////////////////////////////////////////////////

always @(posedge clk or posedge rst) begin

    if(rst) begin
        node_rdata <= 0;
        node_ready <= 0;
    end
    else begin

        node_ready <= 0;

        if(node_write) begin
            node_mem[node_addr] <= node_wdata;
            node_ready <= 1;
        end
        else if(node_read) begin
            node_rdata <= node_mem[node_addr];
            node_ready <= 1;
        end

    end

end

////////////////////////////////////////////////////
// Edge memory port
////////////////////////////////////////////////////

always @(posedge clk or posedge rst) begin

    if(rst) begin
        edge_rdata <= 0;
        edge_ready <= 0;
    end
    else begin

        edge_ready <= 0;

        if(edge_write) begin
            edge_mem[edge_addr] <= edge_wdata;
            edge_ready <= 1;
        end
        else if(edge_read) begin
            edge_rdata <= edge_mem[edge_addr];
            edge_ready <= 1;
        end

    end

end

endmodule
