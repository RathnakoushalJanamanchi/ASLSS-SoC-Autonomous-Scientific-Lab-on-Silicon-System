`timescale 1ns / 1ps
module environment_sensor_engine(
    input wire clk,
    input wire rst,

    // External sensor input
    input wire [15:0] ext_sensor_data,
    input wire sensor_valid,

    // Output to system
    output wire [15:0] data_out,
    output wire data_out_valid,
    input wire data_out_ready
);

//////////////////////////////////////////////////
// Internal signals
//////////////////////////////////////////////////

wire [15:0] vision_data;
wire        vision_valid;

wire [15:0] radar_data;
wire        radar_valid;

wire [15:0] spectro_data;
wire        spectro_valid;

wire [15:0] aggregated_data;
wire        aggregated_valid;

//////////////////////////////////////////////////
// VISION ENGINE (FINAL — DIRECT 16-BIT)
//////////////////////////////////////////////////
vision_engine vision(
    .clk(clk),
    .rst(rst),

    // ✅ NO slicing, NO adapters
    .sensor_input(ext_sensor_data),
    .sensor_valid(sensor_valid),
    .sensor_ready(),

    .vision_out(vision_data),
    .vision_valid(vision_valid),
    .vision_ready(1'b1)
);

//////////////////////////////////////////////////
// RADAR ENGINE
//////////////////////////////////////////////////
radar_engine radar(
    .clk(clk),
    .rst(rst),

    .sample_in(ext_sensor_data),
    .sample_valid(sensor_valid),
    .sample_ready(),

    .data_out(radar_data),
    .data_out_valid(radar_valid),
    .data_out_ready(1'b1)
);

//////////////////////////////////////////////////
// SPECTROSCOPY ENGINE
//////////////////////////////////////////////////
spectroscopy_engine spectroscopy(
    .clk(clk),
    .rst(rst),

    .sample_in(ext_sensor_data),
    .sample_valid(sensor_valid),
    .sample_ready(),

    .data_out(spectro_data),
    .data_out_valid(spectro_valid),
    .data_out_ready(1'b1)
);

//////////////////////////////////////////////////
// AGGREGATOR
//////////////////////////////////////////////////
observation_aggregator aggregator(
    .clk(clk),
    .rst(rst),

    .vision_data(vision_data),
    .vision_valid(vision_valid),
    .vision_ready(),

    .radar_data(radar_data),
    .radar_valid(radar_valid),
    .radar_ready(),

    .spectro_data(spectro_data),
    .spectro_valid(spectro_valid),
    .spectro_ready(),

    .obs_out(aggregated_data),
    .obs_valid(aggregated_valid),
    .obs_ready(data_out_ready)
);

//////////////////////////////////////////////////
// OUTPUT
//////////////////////////////////////////////////
assign data_out       = aggregated_data;
assign data_out_valid = aggregated_valid;

endmodule
