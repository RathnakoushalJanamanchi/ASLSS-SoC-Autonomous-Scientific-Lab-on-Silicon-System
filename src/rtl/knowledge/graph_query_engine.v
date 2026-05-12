`timescale 1ns / 1ps

module graph_query_engine(

    input wire clk,
    input wire rst,

    // Query request
    input wire query_request,
    input wire [7:0] query_node_id,

    // Interface to node manager
    output reg query_node,
    output reg [7:0] node_query_id,
    input wire node_exists,
    input wire [7:0] node_data,

    // Interface to edge processor
    output reg query_edge,
    output reg [7:0] edge_query_source,
    input wire edge_found,
    input wire [7:0] edge_target,

    // Query result
    output reg result_valid,
    output reg [7:0] result_node,
    output reg [7:0] result_edge

);

always @(posedge clk or posedge rst) begin

    if(rst) begin

        query_node <= 0;
        query_edge <= 0;
        result_valid <= 0;

    end

    else begin

        query_node <= 0;
        query_edge <= 0;
        result_valid <= 0;

        if(query_request) begin

            // query node table
            query_node <= 1;
            node_query_id <= query_node_id;

            // query edge relationships
            query_edge <= 1;
            edge_query_source <= query_node_id;

        end

        // Return result if node exists
        if(node_exists) begin

            result_node <= node_data;

        end

        // Return edge result
        if(edge_found) begin

            result_edge <= edge_target;
            result_valid <= 1;

        end

    end

end

endmodule
