`timescale 1ns / 1ps

module ml_pattern_analyzer #(
    parameter OBS_WIDTH = 16,
    parameter PATTERN_WIDTH = 8
)(
    input wire clk,
    input wire rst,

    // Observation input from sensors
    input wire [OBS_WIDTH-1:0] observation_data,
    input wire observation_valid,

    // Pattern output
    output reg [PATTERN_WIDTH-1:0] pattern_flags,
    output reg pattern_valid
);

// Threshold parameters (can be made programmable later)
parameter MINERAL_THRESHOLD = 16'd120;
parameter RADIATION_THRESHOLD = 16'd200;
parameter TERRAIN_THRESHOLD = 16'd60;

always @(posedge clk or posedge rst) begin

    if(rst) begin
        pattern_flags <= 0;
        pattern_valid <= 0;
    end

    else begin

        pattern_valid <= 0;
        pattern_flags <= 0;

        if(observation_valid) begin

            // Pattern 0 : mineral spectral spike
            if(observation_data > MINERAL_THRESHOLD)
                pattern_flags[0] <= 1;

            // Pattern 1 : radiation anomaly
            if(observation_data > RADIATION_THRESHOLD)
                pattern_flags[1] <= 1;

            // Pattern 2 : terrain irregularity
            if(observation_data < TERRAIN_THRESHOLD)
                pattern_flags[2] <= 1;

            pattern_valid <= 1;

        end

    end

end

endmodule
