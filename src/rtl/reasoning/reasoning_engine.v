`timescale 1ns / 1ps

module reasoning_engine(
    input wire clk,
    input wire rst,

    input wire [15:0] observation_data,
    input wire observation_valid,

    output wire [7:0] hypothesis_id,
    output wire [7:0] confidence,
    output wire hypothesis_valid
);

//////////////////////////////////////
// Internal wires
//////////////////////////////////////

wire [7:0] pattern_flags;
wire pattern_valid;

wire [7:0] rule_flags;
wire rule_valid;

wire [7:0] context_hypothesis;
wire [7:0] context_confidence;
wire context_valid;

//////////////////////////////////////
// Pattern analyzer
//////////////////////////////////////

ml_pattern_analyzer pattern_unit(
    .clk(clk),
    .rst(rst),
    .observation_data(observation_data),
    .observation_valid(observation_valid),
    .pattern_flags(pattern_flags),
    .pattern_valid(pattern_valid)
);

//////////////////////////////////////
// Rule logic
//////////////////////////////////////

rule_logic_unit rule_unit(
    .clk(clk),
    .rst(rst),
    .pattern_flags(pattern_flags),
    .pattern_valid(pattern_valid),
    .rule_flags(rule_flags),
    .rule_valid(rule_valid)
);

//////////////////////////////////////
// Hypothesis generator
//////////////////////////////////////

hypothesis_engine hypothesis_unit(
    .clk(clk),
    .rst(rst),
    .observation_data(observation_data),
    .pattern_flags(rule_flags),
    .observation_valid(rule_valid),
    .hypothesis_id(context_hypothesis),
    .confidence(context_confidence),
    .hypothesis_valid(context_valid)
);

//////////////////////////////////////
// Context controller
//////////////////////////////////////

context_decision_controller context_unit(
    .clk(clk),
    .rst(rst),
    .hypothesis_in(context_hypothesis),
    .confidence_in(context_confidence),
    .valid_in(context_valid),
    .hypothesis_out(hypothesis_id),
    .confidence_out(confidence),
    .valid_out(hypothesis_valid)
);

//////////////////////////////////////
// Experiment planner
//////////////////////////////////////

experiment_planner planner(
    .clk(clk),
    .rst(rst),
    .hypothesis_id(hypothesis_id),
    .confidence(confidence),
    .valid(hypothesis_valid)
);

endmodule
