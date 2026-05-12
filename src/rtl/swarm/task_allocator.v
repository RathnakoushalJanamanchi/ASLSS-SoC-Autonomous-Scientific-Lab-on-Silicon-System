`timescale 1ns / 1ps

module task_allocator #(
    parameter AGENT_COUNT = 8
)(

    input wire clk,
    input wire rst,

    // Task request
    input wire task_request,
    input wire [7:0] task_type,

    // Task completion signal
    input wire task_done,
    input wire [2:0] done_agent_id,

    // Task assignment output
    output reg assign_task,
    output reg [2:0] assigned_agent,
    output reg [7:0] assigned_task

);

reg agent_busy [0:AGENT_COUNT-1];
reg [2:0] next_agent;

integer i;

always @(posedge clk or posedge rst) begin

    if(rst) begin

        assign_task <= 0;
        next_agent <= 0;

        for(i = 0; i < AGENT_COUNT; i = i + 1)
            agent_busy[i] <= 0;

    end

    else begin

        assign_task <= 0;

        // Free agent when task completes
        if(task_done)
            agent_busy[done_agent_id] <= 0;

        // Allocate new task
        if(task_request) begin

            if(!agent_busy[next_agent]) begin

                assign_task <= 1;
                assigned_agent <= next_agent;
                assigned_task <= task_type;

                agent_busy[next_agent] <= 1;

                next_agent <= next_agent + 1;

            end

        end

    end

end

endmodule
