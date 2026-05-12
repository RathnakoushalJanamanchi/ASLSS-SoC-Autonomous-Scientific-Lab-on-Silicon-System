`timescale 1ns / 1ps
module edge_processor #(
    parameter NODE_WIDTH = 8,
    parameter EDGE_COUNT = 256
)(
    input wire clk,
    input wire rst,

    // CREATE EDGE
    input wire create_edge,
    input wire [NODE_WIDTH-1:0] edge_source,
    input wire [NODE_WIDTH-1:0] edge_target,

    // QUERY EDGE
    input wire query_edge,
    input wire [NODE_WIDTH-1:0] query_source,

    // OUTPUTS
    output reg edge_created,
    output reg edge_found,
    output reg [NODE_WIDTH-1:0] found_target
);

//////////////////////////////////////////////////
// MEMORY
//////////////////////////////////////////////////
reg [NODE_WIDTH-1:0] edge_source_mem [0:EDGE_COUNT-1];
reg [NODE_WIDTH-1:0] edge_target_mem [0:EDGE_COUNT-1];
reg edge_valid [0:EDGE_COUNT-1];

reg [7:0] edge_index;
integer i;

//////////////////////////////////////////////////
// MAIN LOGIC
//////////////////////////////////////////////////
always @(posedge clk or posedge rst) begin
    if (rst) begin
        edge_created <= 0;
        edge_found   <= 0;
        edge_index   <= 0;
        found_target <= 0;

        // ✅ FIX: blocking assignment
        for (i = 0; i < EDGE_COUNT; i = i + 1) begin
            edge_valid[i]      = 0;
            edge_source_mem[i] = 0;
            edge_target_mem[i] = 0;
        end

    end else begin
        edge_created <= 0;
        edge_found   <= 0;

        ////////////////////////////////////////////
        // CREATE EDGE
        ////////////////////////////////////////////
        if (create_edge) begin
            edge_source_mem[edge_index] <= edge_source;
            edge_target_mem[edge_index] <= edge_target;
            edge_valid[edge_index]      <= 1'b1;

            edge_created <= 1'b1;
            edge_index   <= edge_index + 1;
        end

        ////////////////////////////////////////////
        // QUERY EDGE
        ////////////////////////////////////////////
        if (query_edge) begin
            edge_found   <= 0;
            found_target <= 0;

            for (i = 0; i < EDGE_COUNT; i = i + 1) begin
                if (edge_valid[i] && edge_source_mem[i] == query_source) begin
                    edge_found   <= 1'b1;
                    found_target <= edge_target_mem[i];
                end
            end
        end
    end
end

endmodule
