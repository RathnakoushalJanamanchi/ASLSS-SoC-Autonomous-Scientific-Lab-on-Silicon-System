`timescale 1ns/1ps
module noc_packet #(
    parameter DATA_WIDTH = 32
)(
    input  wire [DATA_WIDTH-1:0] payload,
    input  wire [1:0] dest_x,
    input  wire [1:0] dest_y,
    input  wire [3:0] packet_type,
    output wire [DATA_WIDTH+7:0] packet_out
);
    assign packet_out = {packet_type, dest_y, dest_x, payload};
endmodule
