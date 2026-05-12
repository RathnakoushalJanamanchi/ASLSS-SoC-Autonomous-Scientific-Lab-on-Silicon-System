`timescale 1ns / 1ps

module context_decision_controller(

    input wire clk,
    input wire rst,

    // Input from rule_logic_unit
    input wire [7:0] action_in,
    input wire action_valid,

    // Outputs to system modules
    output reg trigger_experiment,
    output reg request_rescan,
    output reg store_discovery,
    output reg swarm_broadcast

);

always @(posedge clk or posedge rst) begin

    if(rst) begin
        trigger_experiment <= 0;
        request_rescan <= 0;
        store_discovery <= 0;
        swarm_broadcast <= 0;
    end

    else begin

        // default outputs
        trigger_experiment <= 0;
        request_rescan <= 0;
        store_discovery <= 0;
        swarm_broadcast <= 0;

        if(action_valid) begin

            case(action_in)

                8'd10: begin
                    trigger_experiment <= 1;
                end

                8'd20: begin
                    request_rescan <= 1;
                end

                8'd30: begin
                    store_discovery <= 1;
                end

                8'd40: begin
                    swarm_broadcast <= 1;
                end

                default: begin
                    // no action
                end

            endcase

        end

    end

end

endmodule
