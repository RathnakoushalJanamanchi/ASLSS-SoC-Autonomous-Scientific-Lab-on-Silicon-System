`timescale 1ns/1ps
module noc_router #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 4,
    parameter X_POS = 0,
    parameter Y_POS = 0
)(
    input  wire clk,
    input  wire rst,

    input  wire [DATA_WIDTH+7:0] local_in,
    input  wire                  local_valid,
    output reg                   local_ready,
    output reg  [DATA_WIDTH+7:0] local_out,
    output reg                   local_out_valid,

    input  wire [DATA_WIDTH+7:0] north_in,
    input  wire                  north_valid,
    output reg                   north_ready,
    output reg  [DATA_WIDTH+7:0] north_out,
    output reg                   north_out_valid,

    input  wire [DATA_WIDTH+7:0] south_in,
    input  wire                  south_valid,
    output reg                   south_ready,
    output reg  [DATA_WIDTH+7:0] south_out,
    output reg                   south_out_valid,

    input  wire [DATA_WIDTH+7:0] east_in,
    input  wire                  east_valid,
    output reg                   east_ready,
    output reg  [DATA_WIDTH+7:0] east_out,
    output reg                   east_out_valid,

    input  wire [DATA_WIDTH+7:0] west_in,
    input  wire                  west_valid,
    output reg                   west_ready,
    output reg  [DATA_WIDTH+7:0] west_out,
    output reg                   west_out_valid
);

    // Extract destination XY from packet
    wire [1:0] dest_x_local  = local_in[ADDR_WIDTH+1:ADDR_WIDTH];
    wire [1:0] dest_y_local  = local_in[ADDR_WIDTH-1:ADDR_WIDTH-2];
    wire [1:0] dest_x_north  = north_in[ADDR_WIDTH+1:ADDR_WIDTH];
    wire [1:0] dest_y_north  = north_in[ADDR_WIDTH-1:ADDR_WIDTH-2];
    wire [1:0] dest_x_south  = south_in[ADDR_WIDTH+1:ADDR_WIDTH];
    wire [1:0] dest_y_south  = south_in[ADDR_WIDTH-1:ADDR_WIDTH-2];
    wire [1:0] dest_x_east   = east_in[ADDR_WIDTH+1:ADDR_WIDTH];
    wire [1:0] dest_y_east   = east_in[ADDR_WIDTH-1:ADDR_WIDTH-2];
    wire [1:0] dest_x_west   = west_in[ADDR_WIDTH+1:ADDR_WIDTH];
    wire [1:0] dest_y_west   = west_in[ADDR_WIDTH-1:ADDR_WIDTH-2];

    // Requests for arbiter
    reg [4:0] req_local, req_north, req_south, req_east, req_west;
    wire [4:0] grant;

    always @(*) begin
        req_local = 5'b0; req_north = 5'b0; req_south = 5'b0; req_east = 5'b0; req_west = 5'b0;

        if(local_valid && dest_x_local==X_POS && dest_y_local==Y_POS) req_local[4]=1;
        if(north_valid) begin
            if(dest_x_north==X_POS && dest_y_north==Y_POS) req_north[4]=1;
            else if(dest_y_north<Y_POS) req_north[0]=1;
            else if(dest_y_north>Y_POS) req_north[1]=1;
            else if(dest_x_north<X_POS) req_north[3]=1;
            else if(dest_x_north>X_POS) req_north[2]=1;
        end
        if(south_valid) begin
            if(dest_x_south==X_POS && dest_y_south==Y_POS) req_south[4]=1;
            else if(dest_y_south<Y_POS) req_south[0]=1;
            else if(dest_y_south>Y_POS) req_south[1]=1;
            else if(dest_x_south<X_POS) req_south[3]=1;
            else if(dest_x_south>X_POS) req_south[2]=1;
        end
        if(east_valid) begin
            if(dest_x_east==X_POS && dest_y_east==Y_POS) req_east[4]=1;
            else if(dest_y_east<Y_POS) req_east[0]=1;
            else if(dest_y_east>Y_POS) req_east[1]=1;
            else if(dest_x_east<X_POS) req_east[3]=1;
            else if(dest_x_east>X_POS) req_east[2]=1;
        end
        if(west_valid) begin
            if(dest_x_west==X_POS && dest_y_west==Y_POS) req_west[4]=1;
            else if(dest_y_west<Y_POS) req_west[0]=1;
            else if(dest_y_west>Y_POS) req_west[1]=1;
            else if(dest_x_west<X_POS) req_west[3]=1;
            else if(dest_x_west>X_POS) req_west[2]=1;
        end
    end

    noc_arbiter arb(.req({req_local[4], req_north[0], req_south[1], req_east[2], req_west[3]}), .grant(grant));

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            local_out <= 0; local_out_valid <= 0; local_ready <= 0;
            north_out <= 0; north_out_valid <= 0; north_ready <= 0;
            south_out <= 0; south_out_valid <= 0; south_ready <= 0;
            east_out  <= 0; east_out_valid <= 0; east_ready <= 0;
            west_out  <= 0; west_out_valid <= 0; west_ready <= 0;
        end else begin
            local_out_valid <= grant[4]; local_ready <= grant[4]; local_out <= grant[4]?local_in:local_out;
            north_out_valid <= grant[0]; north_ready <= grant[0]; north_out <= grant[0]?north_in:north_out;
            south_out_valid <= grant[1]; south_ready <= grant[1]; south_out <= grant[1]?south_in:south_out;
            east_out_valid  <= grant[2]; east_ready  <= grant[2]; east_out  <= grant[2]?east_in:east_out;
            west_out_valid  <= grant[3]; west_ready  <= grant[3]; west_out  <= grant[3]?west_in:west_out;
        end
    end

endmodule
