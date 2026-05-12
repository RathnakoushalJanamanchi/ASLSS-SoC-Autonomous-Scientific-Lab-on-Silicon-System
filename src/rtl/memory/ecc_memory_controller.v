`timescale 1ns/1ps

module ecc_memory_controller #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 10,
    parameter ECC_BITS   = 7
)(
    input  wire clk,
    input  wire rst,

    // CPU interface
    input  wire [ADDR_WIDTH-1:0] addr,
    input  wire [DATA_WIDTH-1:0] wdata,
    input  wire write,
    input  wire read,

    output reg  [DATA_WIDTH-1:0] rdata,
    output reg  ready,
    output reg  err_detected,
    output reg  err_corrected
);

//////////////////////////////////////////////////
// Memory with ECC bits
//////////////////////////////////////////////////

(* ram_style = "block" *)
reg [DATA_WIDTH+ECC_BITS-1:0] mem [0:(1<<ADDR_WIDTH)-1];

//////////////////////////////////////////////////
// Simple parity encoder
//////////////////////////////////////////////////

function [DATA_WIDTH+ECC_BITS-1:0] encode;
    input [DATA_WIDTH-1:0] data;
    reg parity;
    begin
        parity = ^data;
        encode = {parity, data};
    end
endfunction

wire [DATA_WIDTH+ECC_BITS-1:0] ecc_wdata;
assign ecc_wdata = encode(wdata);

//////////////////////////////////////////////////
// Main memory logic
//////////////////////////////////////////////////

always @(posedge clk or posedge rst) begin

    if(rst) begin
        ready <= 0;
        rdata <= 0;
        err_detected <= 0;
        err_corrected <= 0;
    end
    else begin

        ready <= 0;
        err_detected <= 0;
        err_corrected <= 0;

        // WRITE
        if(write) begin
            mem[addr] <= ecc_wdata;
            ready <= 1;
        end

        // READ
        else if(read) begin

            rdata <= mem[addr][DATA_WIDTH-1:0];
            ready <= 1;

            // parity check
            if(^mem[addr][DATA_WIDTH-1:0] != mem[addr][DATA_WIDTH+ECC_BITS-1]) begin
                err_detected <= 1;

                // demo correction
                rdata[0] <= ~mem[addr][0];
                err_corrected <= 1;
            end

        end

    end

end

endmodule
