`timescale 1ns / 1ps

module crc_unit(
    input wire clk,
    input wire rst,

    // Input data
    input wire data_valid,
    input wire [31:0] data_in,

    // CRC output
    output reg crc_valid,
    output reg [7:0] crc_out
);

reg [7:0] crc_reg;
integer i;

reg [7:0] crc_next;

//////////////////////////////////////////////////
// CRC computation
//////////////////////////////////////////////////

always @(*) begin

    crc_next = 8'h00;

    for(i = 0; i < 32; i = i + 1) begin
        crc_next = crc_next ^ {7'b0, data_in[i]};
        crc_next = {crc_next[6:0], crc_next[7]^crc_next[2]^crc_next[1]};
    end

end

//////////////////////////////////////////////////
// Register stage
//////////////////////////////////////////////////

always @(posedge clk or posedge rst) begin

    if(rst) begin
        crc_reg   <= 8'h00;
        crc_out   <= 8'h00;
        crc_valid <= 0;
    end
    else begin

        crc_valid <= 0;

        if(data_valid) begin
            crc_reg   <= crc_next;
            crc_out   <= crc_next;
            crc_valid <= 1;
        end

    end

end

endmodule
