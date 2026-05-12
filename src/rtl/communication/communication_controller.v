`timescale 1ns / 1ps

module communication_controller(

    input wire clk,
    input wire rst,

    // Transmission request from system
    input wire tx_request,
    input wire [15:0] tx_payload,
    input wire [7:0] tx_type,
    input wire [7:0] tx_source,

    // Interface to packet encoder
    output reg encoder_valid,
    output reg [7:0] encoder_type,
    output reg [7:0] encoder_source,
    output reg [15:0] encoder_payload,

    // CRC interface
    input wire [7:0] crc_value,
    input wire crc_valid,

    // Receive interface from NoC
    input wire rx_valid,
    input wire [31:0] rx_packet,

    // Output to system
    output reg rx_data_valid,
    output reg [31:0] rx_data

);

//////////////////////////////////////////////////
// Transmit Logic
//////////////////////////////////////////////////

always @(posedge clk or posedge rst) begin

    if(rst) begin
        encoder_valid   <= 0;
        encoder_type    <= 0;
        encoder_source  <= 0;
        encoder_payload <= 0;
    end
    else begin

        encoder_valid <= 0;

        if(tx_request) begin

            encoder_type    <= tx_type;
            encoder_source  <= tx_source;
            encoder_payload <= tx_payload;

            encoder_valid   <= 1;

        end

    end

end

//////////////////////////////////////////////////
// Receive Logic
//////////////////////////////////////////////////

always @(posedge clk or posedge rst) begin

    if(rst) begin
        rx_data_valid <= 0;
        rx_data       <= 0;
    end
    else begin

        rx_data_valid <= 0;

        if(rx_valid) begin
            rx_data       <= rx_packet;
            rx_data_valid <= 1;
        end

    end

end

endmodule
