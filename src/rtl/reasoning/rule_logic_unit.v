`timescale 1ns / 1ps

module rule_logic_unit #(
    parameter HYP_WIDTH = 8,
    parameter CONF_WIDTH = 8,
    parameter RULE_COUNT = 16
)(
    input wire clk,
    input wire rst,

    // Input from hypothesis engine
    input wire [HYP_WIDTH-1:0] hypothesis_id,
    input wire [CONF_WIDTH-1:0] confidence,
    input wire hypothesis_valid,

    // CPU rule programming interface
    input wire rule_write_en,
    input wire [3:0] rule_addr,
    input wire [HYP_WIDTH-1:0] rule_hypothesis,
    input wire [CONF_WIDTH-1:0] rule_conf_threshold,
    input wire [7:0] rule_action,

    // Decision output
    output reg [7:0] action_out,
    output reg action_valid
);

reg [HYP_WIDTH-1:0] rule_hypothesis_mem [0:RULE_COUNT-1];
reg [CONF_WIDTH-1:0] rule_conf_mem [0:RULE_COUNT-1];
reg [7:0] rule_action_mem [0:RULE_COUNT-1];

integer i;

always @(posedge clk) begin
    if(rule_write_en) begin
        rule_hypothesis_mem[rule_addr] <= rule_hypothesis;
        rule_conf_mem[rule_addr] <= rule_conf_threshold;
        rule_action_mem[rule_addr] <= rule_action;
    end
end

always @(posedge clk or posedge rst) begin

    if(rst) begin
        action_out <= 0;
        action_valid <= 0;
    end

    else begin

        action_valid <= 0;

        if(hypothesis_valid) begin

            for(i = 0; i < RULE_COUNT; i = i + 1) begin

                if((rule_hypothesis_mem[i] == hypothesis_id) &&
                   (confidence >= rule_conf_mem[i])) begin

                    action_out <= rule_action_mem[i];
                    action_valid <= 1;

                end

            end

        end

    end

end

endmodule
