`timescale 1ns / 1ps

module knowledge_graph_engine(
    input wire clk,
    input wire rst,

    //////////////////////////////////////////////////
    // DISCOVERY INPUT
    //////////////////////////////////////////////////
    input wire discovery_valid,
    input wire [7:0] discovery_id,
    input wire [7:0] discovery_type,

    //////////////////////////////////////////////////
    // QUERY INTERFACE
    //////////////////////////////////////////////////
    input wire query_request,
    input wire [7:0] query_node_id,

    //////////////////////////////////////////////////
    // OUTPUT
    //////////////////////////////////////////////////
    output wire result_valid,
    output wire [7:0] result_data
);

//////////////////////////////////////////////////
// INTERNAL CONTROL SIGNALS
//////////////////////////////////////////////////
reg create_node;
reg [7:0] node_id;

reg create_edge;
reg [7:0] edge_source;
reg [7:0] edge_target;

reg execute_query;
reg [7:0] query_node;

//////////////////////////////////////////////////
// INTERNAL WIRES
//////////////////////////////////////////////////
wire node_created;
wire node_exists;
wire [7:0] node_data;

wire edge_created;
wire edge_found;
wire [7:0] found_target;

wire query_result_valid;
wire [7:0] query_result;

//////////////////////////////////////////////////
// CONTROL LOGIC
//////////////////////////////////////////////////
always @(posedge clk or posedge rst) begin
    if (rst) begin
        create_node   <= 0;
        create_edge   <= 0;
        execute_query <= 0;
    end else begin
        create_node   <= 0;
        create_edge   <= 0;
        execute_query <= 0;

        ////////////////////////////////////////////////
        // DISCOVERY → NODE + EDGE
        ////////////////////////////////////////////////
        if (discovery_valid) begin
            create_node <= 1;
            node_id     <= discovery_id;

            create_edge <= 1;
            edge_source <= discovery_type;
            edge_target <= discovery_id;
        end

        ////////////////////////////////////////////////
        // QUERY
        ////////////////////////////////////////////////
        if (query_request) begin
            execute_query <= 1;
            query_node    <= query_node_id;
        end
    end
end

//////////////////////////////////////////////////
// NODE MANAGER (FIXED INTERFACE)
//////////////////////////////////////////////////
node_manager node_mgr(
    .clk(clk),
    .rst(rst),

    .create_node(create_node),
    .node_id(node_id),

    .query_valid(execute_query),
    .query_node_id(query_node),

    .node_created(node_created),
    .node_exists(node_exists),
    .node_data(node_data)
);

//////////////////////////////////////////////////
// EDGE PROCESSOR (FIXED INTERFACE)
//////////////////////////////////////////////////
edge_processor edge_proc(
    .clk(clk),
    .rst(rst),

    .create_edge(create_edge),
    .edge_source(edge_source),
    .edge_target(edge_target),

    .query_edge(execute_query),
    .query_source(query_node),

    .edge_created(edge_created),
    .edge_found(edge_found),
    .found_target(found_target)
);

//////////////////////////////////////////////////
// Discovery update unit (FINAL FIX)
//////////////////////////////////////////////////
discovery_update_unit discovery_unit(
    .clk(clk),
    .rst(rst),

    // INPUTS (MATCHED)
    .discovery_valid(discovery_valid),
    .discovery_type(discovery_type),
    .discovery_confidence(8'd0),

    // OUTPUTS (unused → safe tie-off)
    .create_node(),
    .node_id(),
    .create_edge(),
    .edge_source(),
    .edge_target()
);
//////////////////////////////////////////////////
// GRAPH QUERY ENGINE (FIXED)
//////////////////////////////////////////////////
graph_query_engine query_engine(
    .clk(clk),
    .rst(rst),

    .query_request(execute_query),
    .query_node_id(query_node),

    .node_exists(node_exists),
    .node_data(node_data),

    .edge_found(edge_found),
    .edge_target(found_target),

    .result_valid(query_result_valid),
    .result_node(query_result),
    .result_edge()   // unused
);

//////////////////////////////////////////////////
// OUTPUT MAPPING
//////////////////////////////////////////////////
assign result_valid = query_result_valid;
assign result_data  = query_result;

endmodule
