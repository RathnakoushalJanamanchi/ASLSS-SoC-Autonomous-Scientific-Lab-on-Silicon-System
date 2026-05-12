`timescale 1ns / 1ps

module packet_decoder #(
    parameter HEADER = 8'hAA
)(
    input wire clk,
    input wire rst,

    // Incoming packet
    input wire packet_valid,
    input wire [31:0] packet_in,

    // Decoded outputs
    output reg data_valid,
    output reg [7:0] packet_type,
    output reg [7:0] source_id,
    output reg [7:0] payload_data
);

//////////////////////////////////////////////////
// Packet Decode Logic
//////////////////////////////////////////////////

always @(posedge clk or posedge rst) begin

    if(rst) begin
        data_valid   <= 0;
        packet_type  <= 0;
        source_id    <= 0;
        payload_data <= 0;
    end
    else begin

        data_valid <= 0;

        if(packet_valid) begin

            // Check header
            if(packet_in[31:24] == HEADER) begin

                packet_type  <= packet_in[23:16];
                source_id    <= packet_in[15:8];
                payload_data <= packet_in[7:0];

                data_valid <= 1;

            end

        end

    end

end

endmodule
