`timescale 1ns / 1ps

module slam_engine(

    input wire clk,
    input wire rst,

    // Sensor input
    input wire sensor_valid,
    input wire [7:0] sensor_dx,
    input wire [7:0] sensor_dy,

    // Current position estimate
    output reg [15:0] pos_x,
    output reg [15:0] pos_y,

    // Map update signal
    output reg map_update

);

always @(posedge clk or posedge rst) begin

    if(rst) begin

        pos_x <= 0;
        pos_y <= 0;
        map_update <= 0;

    end

    else begin

        map_update <= 0;

        if(sensor_valid) begin

            // Update position estimate
            pos_x <= pos_x + sensor_dx;
            pos_y <= pos_y + sensor_dy;

            map_update <= 1;

        end

    end

end

endmodule
