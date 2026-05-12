`timescale 1ns/1ps

module sensor_buffer #(
    parameter DATA_WIDTH = 32,
    parameter DEPTH      = 64,
    parameter ADDR_WIDTH = 6
)(
    input  wire clk,
    input  wire rst,

    // Write interface (from sensors)
    input  wire [DATA_WIDTH-1:0] wdata,
    input  wire write,
    output wire write_ready,

    // Read interface (to CPU / NoC)
    output reg  [DATA_WIDTH-1:0] rdata,
    input  wire read,
    output wire read_valid
);

//////////////////////////////////////////////////
// FIFO memory
//////////////////////////////////////////////////

reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

reg [ADDR_WIDTH-1:0] write_ptr;
reg [ADDR_WIDTH-1:0] read_ptr;
reg [ADDR_WIDTH:0]   count;

//////////////////////////////////////////////////
// Status signals
//////////////////////////////////////////////////

assign write_ready = (count < DEPTH);
assign read_valid  = (count > 0);

//////////////////////////////////////////////////
// FIFO logic
//////////////////////////////////////////////////

always @(posedge clk or posedge rst) begin

    if(rst) begin
        write_ptr <= 0;
        read_ptr  <= 0;
        count     <= 0;
        rdata     <= 0;
    end
    else begin

        // WRITE
        if(write && write_ready) begin
            mem[write_ptr] <= wdata;

            if(write_ptr == DEPTH-1)
                write_ptr <= 0;
            else
                write_ptr <= write_ptr + 1;
        end

        // READ
        if(read && read_valid) begin
            rdata <= mem[read_ptr];

            if(read_ptr == DEPTH-1)
                read_ptr <= 0;
            else
                read_ptr <= read_ptr + 1;
        end

        // COUNT UPDATE
        case({write && write_ready, read && read_valid})

            2'b10: count <= count + 1; // write only
            2'b01: count <= count - 1; // read only
            default: count <= count;   // same or none

        endcase

    end

end

endmodule
