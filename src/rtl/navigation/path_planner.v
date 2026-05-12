`timescale 1ns / 1ps

module path_planner(

    input wire clk,
    input wire rst,

    // Terrain information
    input wire terrain_valid,
    input wire [2:0] terrain_type,

    // Current position
    input wire [15:0] pos_x,
    input wire [15:0] pos_y,

    // Navigation command outputs
    output reg move_forward,
    output reg move_left,
    output reg move_right,
    output reg stop

);

// Terrain encoding
// 1 = safe
// 2 = obstacle
// 3 = slope
// 4 = hazard

always @(posedge clk or posedge rst) begin

    if(rst) begin

        move_forward <= 0;
        move_left <= 0;
        move_right <= 0;
        stop <= 0;

    end

    else begin

        move_forward <= 0;
        move_left <= 0;
        move_right <= 0;
        stop <= 0;

        if(terrain_valid) begin

            case(terrain_type)

                3'd1: begin
                    move_forward <= 1;   // safe terrain
                end

                3'd2: begin
                    move_right <= 1;     // obstacle → avoid
                end

                3'd3: begin
                    move_left <= 1;      // slope → adjust path
                end

                3'd4: begin
                    stop <= 1;           // hazard detected
                end

                default: begin
                    stop <= 1;
                end

            endcase

        end

    end

end

endmodule
