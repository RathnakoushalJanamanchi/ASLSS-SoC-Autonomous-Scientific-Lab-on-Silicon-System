`timescale 1ns / 1ps

module packet_encoder #(
    parameter HEADER = 8'hAA
)(
    input wire clk,
    input wire rst,

    // Data input
    input wire data_valid,
    input wire [7:0] packet_type,
    input wire [7:0] source_id,
    input wire [15:0] payload_data,

    // Encoded packet output
    output reg packet_valid,
    output reg [31:0] packet_out
);

//////////////////////////////////////////////////
// Packet Encoding
//////////////////////////////////////////////////

always @(posedge clk or posedge rst) begin

    if(rst) begin
        packet_valid <= 0;
        packet_out   <= 0;
    end
    else begin

        packet_valid <= 0;

        if(data_valid) begin

            // Packet format
            // [31:24] HEADER
            // [23:16] TYPE
            // [15:8]  SOURCE
            // [7:0]   PAYLOAD

            packet_out <= {HEADER, packet_type, source_id, payload_data[7:0]};
            packet_valid <= 1;

        end

    end

end

endmodule
