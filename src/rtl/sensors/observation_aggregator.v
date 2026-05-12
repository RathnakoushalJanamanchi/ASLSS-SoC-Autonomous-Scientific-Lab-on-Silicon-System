`timescale 1ns / 1ps

module observation_aggregator(
    input wire clk,
    input wire rst,

    //////////////////////////////////////////////////
    // VISION INPUT
    //////////////////////////////////////////////////
    input wire [15:0] vision_data,
    input wire vision_valid,
    output reg vision_ready,

    //////////////////////////////////////////////////
    // RADAR INPUT
    //////////////////////////////////////////////////
    input wire [15:0] radar_data,
    input wire radar_valid,
    output reg radar_ready,

    //////////////////////////////////////////////////
    // SPECTROSCOPY INPUT
    //////////////////////////////////////////////////
    input wire [15:0] spectro_data,
    input wire spectro_valid,
    output reg spectro_ready,

    //////////////////////////////////////////////////
    // OUTPUT (TO SYSTEM)
    //////////////////////////////////////////////////
    output reg [15:0] obs_out,
    output reg obs_valid,
    input wire obs_ready
);

//////////////////////////////////////////////////
// INTERNAL STATE MACHINE
//////////////////////////////////////////////////
reg [1:0] state;

localparam IDLE      = 2'd0;
localparam SEND_VISION  = 2'd1;
localparam SEND_RADAR   = 2'd2;
localparam SEND_SPECTRO = 2'd3;

//////////////////////////////////////////////////
// LOGIC
//////////////////////////////////////////////////
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;

        obs_out   <= 0;
        obs_valid <= 0;

        vision_ready  <= 0;
        radar_ready   <= 0;
        spectro_ready <= 0;
    end else begin
        // defaults
        obs_valid <= 0;

        vision_ready  <= 0;
        radar_ready   <= 0;
        spectro_ready <= 0;

        case (state)

        //////////////////////////////////////////////////
        // IDLE → pick available sensor
        //////////////////////////////////////////////////
        IDLE: begin
            if (vision_valid) begin
                state <= SEND_VISION;
            end else if (radar_valid) begin
                state <= SEND_RADAR;
            end else if (spectro_valid) begin
                state <= SEND_SPECTRO;
            end
        end

        //////////////////////////////////////////////////
        // SEND VISION DATA
        //////////////////////////////////////////////////
        SEND_VISION: begin
            if (obs_ready) begin
                obs_out   <= vision_data;
                obs_valid <= 1;

                vision_ready <= 1;
                state <= IDLE;
            end
        end

        //////////////////////////////////////////////////
        // SEND RADAR DATA
        //////////////////////////////////////////////////
        SEND_RADAR: begin
            if (obs_ready) begin
                obs_out   <= radar_data;
                obs_valid <= 1;

                radar_ready <= 1;
                state <= IDLE;
            end
        end

        //////////////////////////////////////////////////
        // SEND SPECTRO DATA
        //////////////////////////////////////////////////
        SEND_SPECTRO: begin
            if (obs_ready) begin
                obs_out   <= spectro_data;
                obs_valid <= 1;

                spectro_ready <= 1;
                state <= IDLE;
            end
        end

        default: state <= IDLE;

        endcase
    end
end

endmodule
