`timescale 1ns / 1ps

module terrain_analysis(

    input wire clk,
    input wire rst,

    // Position input from SLAM
    input wire map_update,
    input wire [15:0] pos_x,
    input wire [15:0] pos_y,

    // Terrain sensor input (example height / slope data)
    input wire [7:0] terrain_value,

    // Terrain classification
    output reg terrain_valid,
    output reg [2:0] terrain_type

);

// Terrain type encoding
// 0 = unknown
// 1 = safe
// 2 = obstacle
// 3 = slope
// 4 = hazard

always @(posedge clk or posedge rst) begin

    if(rst) begin
        terrain_valid <= 0;
        terrain_type <= 0;
    end

    else begin

        terrain_valid <= 0;

        if(map_update) begin

            if(terrain_value < 8'd40)
                terrain_type <= 3'd1; // safe

            else if(terrain_value < 8'd80)
                terrain_type <= 3'd3; // slope

            else if(terrain_value < 8'd120)
                terrain_type <= 3'd2; // obstacle

            else
                terrain_type <= 3'd4; // hazard

            terrain_valid <= 1;

        end

    end

end

endmodule
