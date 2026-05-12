`timescale 1ns/1ps

module nonvolatile_storage_controller #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 16,
    parameter STORAGE_DEPTH = 65536
)(
    input  wire clk,
    input  wire rst,

    // CPU / SoC interface
    input  wire [ADDR_WIDTH-1:0] addr,
    input  wire [DATA_WIDTH-1:0] wdata,
    input  wire write,
    input  wire read,

    output reg  [DATA_WIDTH-1:0] rdata,
    output reg  ready,
    output reg  err_detected
);

//////////////////////////////////////////////////
// Nonvolatile memory
//////////////////////////////////////////////////

(* ram_style="block" *)
reg [DATA_WIDTH-1:0] nv_mem [0:STORAGE_DEPTH-1];

//////////////////////////////////////////////////
// Read / Write logic
//////////////////////////////////////////////////

always @(posedge clk or posedge rst) begin

    if(rst) begin
        rdata <= 0;
        ready <= 0;
        err_detected <= 0;
    end
    else begin

        ready <= 0;
        err_detected <= 0;

        // WRITE
        if(write) begin
            nv_mem[addr] <= wdata;
            ready <= 1;
        end

        // READ
        else if(read) begin
            rdata <= nv_mem[addr];
            ready <= 1;
        end

    end

end

endmodule
