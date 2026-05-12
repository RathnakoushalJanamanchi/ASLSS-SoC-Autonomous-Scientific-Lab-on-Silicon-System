`timescale 1ns / 1ps

module hypothesis_engine #(
    parameter OBS_WIDTH = 16,
    parameter PATTERN_WIDTH = 8,
    parameter HYP_WIDTH = 8
)(
    input wire clk,
    input wire rst,

    // Observation input
    input wire [OBS_WIDTH-1:0] observation_data,
    input wire [PATTERN_WIDTH-1:0] pattern_flags,
    input wire observation_valid,

    // Output hypothesis
    output reg [HYP_WIDTH-1:0] hypothesis_id,
    output reg [7:0] confidence,
    output reg hypothesis_valid
);

reg [HYP_WIDTH-1:0] next_hypothesis;
reg [7:0] next_confidence;

always @(*) begin
    next_hypothesis = 0;
    next_confidence = 0;

    case(pattern_flags)

        // Example rule 1
        8'b00000001: begin
            if(observation_data > 16'd100)
            begin
                next_hypothesis = 8'd1; // possible mineral presence
                next_confidence = 8'd80;
            end
        end

        // Example rule 2
        8'b00000010: begin
            if(observation_data > 16'd200)
            begin
                next_hypothesis = 8'd2; // radiation anomaly
                next_confidence = 8'd70;
            end
        end

        // Example rule 3
        8'b00000100: begin
            next_hypothesis = 8'd3; // terrain instability
            next_confidence = 8'd60;
        end

        default: begin
            next_hypothesis = 8'd0;
            next_confidence = 8'd0;
        end

    endcase
end


always @(posedge clk or posedge rst) begin
    if(rst) begin
        hypothesis_id <= 0;
        confidence <= 0;
        hypothesis_valid <= 0;
    end
    else begin
        if(observation_valid) begin
            hypothesis_id <= next_hypothesis;
            confidence <= next_confidence;
            hypothesis_valid <= 1;
        end
        else begin
            hypothesis_valid <= 0;
        end
    end
end

endmodule
