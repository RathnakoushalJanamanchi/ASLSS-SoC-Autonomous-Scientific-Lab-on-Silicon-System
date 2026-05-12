`timescale 1ns / 1ps
module node_manager #(
    parameter NODE_WIDTH = 8,
    parameter DEPTH = 256
)(
    input wire clk,
    input wire rst,

    // CREATE NODE
    input wire create_node,
    input wire [NODE_WIDTH-1:0] node_id,

    // QUERY
    input wire query_valid,
    input wire [NODE_WIDTH-1:0] query_node_id,

    // OUTPUTS
    output reg node_created,
    output reg node_exists,
    output reg [NODE_WIDTH-1:0] node_data
);

//////////////////////////////////////////////////
// MEMORY
//////////////////////////////////////////////////
reg [NODE_WIDTH-1:0] node_mem [0:DEPTH-1];
reg node_valid [0:DEPTH-1];

integer i;

//////////////////////////////////////////////////
// MAIN LOGIC
//////////////////////////////////////////////////
always @(posedge clk or posedge rst) begin
    if (rst) begin
        node_created <= 0;
        node_exists  <= 0;
        node_data    <= 0;

        // ✅ FIX: blocking assignment inside loop
        for (i = 0; i < DEPTH; i = i + 1) begin
            node_valid[i] = 1'b0;
            node_mem[i]   = {NODE_WIDTH{1'b0}};
        end

    end else begin
        node_created <= 1'b0;
        node_exists  <= 1'b0;

        ////////////////////////////////////////////
        // CREATE NODE
        ////////////////////////////////////////////
        if (create_node) begin
            node_mem[node_id]   <= node_id;
            node_valid[node_id] <= 1'b1;
            node_created        <= 1'b1;
        end

        ////////////////////////////////////////////
        // QUERY NODE
        ////////////////////////////////////////////
        if (query_valid) begin
            if (node_valid[query_node_id]) begin
                node_data   <= node_mem[query_node_id];
                node_exists <= 1'b1;
            end else begin
                node_data   <= {NODE_WIDTH{1'b0}};
                node_exists <= 1'b0;
            end
        end
    end
end

endmodule
