`timescale 1ns / 1ps

module swarm_engine(
    input wire clk,
    input wire rst,

    input wire msg_valid,
    input wire [7:0] msg_type,
    input wire [7:0] sender_id,

    output reg allocate_task_out,
    output reg sync_knowledge_out,
    output reg detect_conflict_out
);

////////////////////////////////////////////////////
// INTERNAL
////////////////////////////////////////////////////
reg [7:0] task_agent;
reg [7:0] sync_agent;
reg [7:0] conflict_agent;

////////////////////////////////////////////////////
// CONTROL
////////////////////////////////////////////////////
always @(posedge clk or posedge rst) begin
    if (rst) begin
        allocate_task_out   <= 0;
        sync_knowledge_out  <= 0;
        detect_conflict_out <= 0;
    end else begin
        allocate_task_out   <= 0;
        sync_knowledge_out  <= 0;
        detect_conflict_out <= 0;

        if (msg_valid) begin
            case (msg_type)
                8'd1: begin
                    allocate_task_out <= 1;
                    task_agent <= sender_id;
                end
                8'd2: begin
                    sync_knowledge_out <= 1;
                    sync_agent <= sender_id;
                end
                8'd3: begin
                    detect_conflict_out <= 1;
                    conflict_agent <= sender_id;
                end
            endcase
        end
    end
end

////////////////////////////////////////////////////
// COMM CONTROLLER (MATCHED PORTS)
////////////////////////////////////////////////////
swarm_comm_controller comm_ctrl(
    .clk(clk),
    .rst(rst),

    .rx_valid(msg_valid),
    .rx_msg_type(msg_type),
    .rx_sender_id(sender_id),

    .send_msg(),
    .tx_msg_type(),
    .tx_target_id(),
    .tx_valid(),
    .tx_msg_out(),
    .tx_target_out()
);

////////////////////////////////////////////////////
// TASK ALLOCATOR (MATCHED PORTS)
////////////////////////////////////////////////////
task_allocator allocator(
    .clk(clk),
    .rst(rst),

    .task_request(allocate_task_out),
    .task_type(8'd1),
    .task_done(1'b0),
    .done_agent_id(8'd0),

    .assign_task(),
    .assigned_agent(),
    .assigned_task()
);

////////////////////////////////////////////////////
// KNOWLEDGE SYNC (MATCHED PORTS)
////////////////////////////////////////////////////
knowledge_sync_unit sync_unit(
    .clk(clk),
    .rst(rst),

    .knowledge_update(sync_knowledge_out),
    .knowledge_id(sync_agent),

    .remote_update(1'b0),
    .remote_knowledge_id(8'd0),

    .send_sync(),
    .sync_data(),
    .apply_remote_update(),
    .applied_knowledge()
);

////////////////////////////////////////////////////
// CONFLICT RESOLVER (MATCHED PORTS)
////////////////////////////////////////////////////
conflict_resolver resolver(
    .clk(clk),
    .rst(rst),

    .assign_request(detect_conflict_out),
    .task_id(8'd0),
    .task_done(1'b0),
    .done_agent_id(8'd0),

    .grant_task(),
    .conflict_detected()
);

endmodule
