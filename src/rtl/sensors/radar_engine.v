`timescale 1ns/1ps
module radar_engine #(
    parameter SAMPLE_WIDTH = 16,   // width of radar sample
    parameter BUFFER_DEPTH = 128,  // number of samples buffered
    parameter ADDR_WIDTH = $clog2(BUFFER_DEPTH)
)(
    input  wire clk,
    input  wire rst,

    // Radar input
    input  wire [SAMPLE_WIDTH-1:0] sample_in,
    input  wire                    sample_valid,
    output reg                     sample_ready,

    // Output to NoC/CPU
    output reg  [SAMPLE_WIDTH-1:0] data_out,
    output reg                     data_out_valid,
    input  wire                    data_out_ready
);

    // -----------------------------
    // Internal buffer
    // -----------------------------
    reg [SAMPLE_WIDTH-1:0] buffer [0:BUFFER_DEPTH-1];
    reg [ADDR_WIDTH-1:0] write_ptr;
    reg [ADDR_WIDTH-1:0] read_ptr;
    reg buffer_full;

    // -----------------------------
    // Write process
    // -----------------------------
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            write_ptr <= 0;
            buffer_full <= 0;
            sample_ready <= 1;
        end else begin
            if(sample_valid && sample_ready) begin
                buffer[write_ptr] <= sample_in;
                write_ptr <= write_ptr + 1;
                if(write_ptr == BUFFER_DEPTH-1)
                    buffer_full <= 1;
            end
            sample_ready <= ~buffer_full;
        end
    end

    // -----------------------------
    // Read process
    // -----------------------------
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            read_ptr <= 0;
            data_out <= 0;
            data_out_valid <= 0;
        end else begin
            if(buffer_full && data_out_ready) begin
                data_out <= buffer[read_ptr];
                data_out_valid <= 1;
                read_ptr <= read_ptr + 1;
                if(read_ptr == BUFFER_DEPTH-1)
                    read_ptr <= 0;
            end else begin
                data_out_valid <= 0;
            end
        end
    end

endmodule
