`timescale 1ns / 1ps

module knowledge_sync_unit(

    input wire clk,
    input wire rst,

    // Local knowledge update
    input wire knowledge_update,
    input wire [7:0] knowledge_id,

    // Incoming remote knowledge
    input wire remote_update,
    input wire [7:0] remote_knowledge_id,

    // Output to communication controller
    output reg send_sync,
    output reg [7:0] sync_data,

    // Output to knowledge graph
    output reg apply_remote_update,
    output reg [7:0] applied_knowledge

);

always @(posedge clk or posedge rst) begin

    if(rst) begin
        send_sync <= 0;
        apply_remote_update <= 0;
    end

    else begin

        send_sync <= 0;
        apply_remote_update <= 0;

        // Local knowledge update → broadcast to swarm
        if(knowledge_update) begin

            send_sync <= 1;
            sync_data <= knowledge_id;

        end

        // Remote knowledge received
        if(remote_update) begin

            apply_remote_update <= 1;
            applied_knowledge <= remote_knowledge_id;

        end

    end

end

endmodule
