`timescale 1ns / 1ps

module discovery_update_unit(

    input wire clk,
    input wire rst,

    // Discovery input from reasoning system
    input wire discovery_valid,
    input wire [7:0] discovery_type,
    input wire [7:0] discovery_confidence,

    // Outputs to knowledge_graph_engine
    output reg create_node,
    output reg [7:0] node_id,

    output reg create_edge,
    output reg [7:0] edge_source,
    output reg [7:0] edge_target

);

reg [7:0] discovery_counter;

always @(posedge clk or posedge rst) begin

    if(rst) begin

        discovery_counter <= 0;
        create_node <= 0;
        create_edge <= 0;

    end

    else begin

        create_node <= 0;
        create_edge <= 0;

        if(discovery_valid) begin

            discovery_counter <= discovery_counter + 1;

            // Create node
            create_node <= 1;
            node_id <= discovery_counter;

            // Create relationship edge
            create_edge <= 1;
            edge_source <= discovery_type;
            edge_target <= discovery_counter;

        end

    end

end

endmodule
