`timescale 1ns / 1ps

module conflict_resolver #(
    parameter AGENT_COUNT = 8
)(

    input wire clk,
    input wire rst,

    // Incoming task assignment
    input wire assign_request,
    input wire [2:0] agent_id,
    input wire [7:0] task_id,

    // Task completion
    input wire task_done,
    input wire [2:0] done_agent_id,

    // Resolution outputs
    output reg grant_task,
    output reg conflict_detected

);

reg [7:0] active_task [0:AGENT_COUNT-1];
reg task_active [0:AGENT_COUNT-1];

integer i;
reg conflict;

always @(posedge clk or posedge rst) begin

    if(rst) begin

        grant_task <= 0;
        conflict_detected <= 0;

        for(i = 0; i < AGENT_COUNT; i = i + 1) begin
            task_active[i] <= 0;
            active_task[i] <= 0;
        end

    end

    else begin

        grant_task <= 0;
        conflict_detected <= 0;

        // Free task slot
        if(task_done) begin
            task_active[done_agent_id] <= 0;
        end

        // Check assignment request
        if(assign_request) begin

            conflict = 0;

            for(i = 0; i < AGENT_COUNT; i = i + 1) begin
                if(task_active[i] && active_task[i] == task_id)
                    conflict = 1;
            end

            if(!conflict) begin

                grant_task <= 1;
                task_active[agent_id] <= 1;
                active_task[agent_id] <= task_id;

            end
            else begin

                conflict_detected <= 1;

            end

        end

    end

end

endmodule
