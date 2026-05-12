`timescale 1ns/1ps
module environment_sensor_engine_flat #(
    parameter NUM_SENSORS = 4,
    parameter DATA_WIDTH = 16,
    parameter BUFFER_DEPTH = 64,
    parameter ADDR_WIDTH = 6 // $clog2(BUFFER_DEPTH)
)(
    input  wire clk,
    input  wire rst,

    // Flattened sensor inputs
    input  wire [DATA_WIDTH-1:0] sensor_in0,
    input  wire                  sensor_valid0,
    output reg                   sensor_ready0,

    input  wire [DATA_WIDTH-1:0] sensor_in1,
    input  wire                  sensor_valid1,
    output reg                   sensor_ready1,

    input  wire [DATA_WIDTH-1:0] sensor_in2,
    input  wire                  sensor_valid2,
    output reg                   sensor_ready2,

    input  wire [DATA_WIDTH-1:0] sensor_in3,
    input  wire                  sensor_valid3,
    output reg                   sensor_ready3,

    // Output to NoC/CPU
    output reg  [DATA_WIDTH-1:0] data_out,
    output reg                   data_out_valid,
    input  wire                  data_out_ready
);

    // -----------------------------
    // Internal buffers for each sensor
    // -----------------------------
    reg [DATA_WIDTH-1:0] buffer0[0:BUFFER_DEPTH-1];
    reg [DATA_WIDTH-1:0] buffer1[0:BUFFER_DEPTH-1];
    reg [DATA_WIDTH-1:0] buffer2[0:BUFFER_DEPTH-1];
    reg [DATA_WIDTH-1:0] buffer3[0:BUFFER_DEPTH-1];

    reg [ADDR_WIDTH-1:0] write_ptr0, write_ptr1, write_ptr2, write_ptr3;
    reg [ADDR_WIDTH-1:0] read_ptr;
    reg buffer_full0, buffer_full1, buffer_full2, buffer_full3;
    reg [1:0] sensor_idx; // round-robin read

    // -----------------------------
    // Write logic
    // -----------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            write_ptr0 <= 0; write_ptr1 <= 0; write_ptr2 <= 0; write_ptr3 <= 0;
            buffer_full0 <= 0; buffer_full1 <= 0; buffer_full2 <= 0; buffer_full3 <= 0;
            sensor_ready0 <= 1; sensor_ready1 <= 1; sensor_ready2 <= 1; sensor_ready3 <= 1;
        end else begin
            // Sensor 0
            if(sensor_valid0 && sensor_ready0) begin
                buffer0[write_ptr0] <= sensor_in0;
                write_ptr0 <= write_ptr0 + 1;
                if(write_ptr0 == BUFFER_DEPTH-1) buffer_full0 <= 1;
            end
            sensor_ready0 <= ~buffer_full0;

            // Sensor 1
            if(sensor_valid1 && sensor_ready1) begin
                buffer1[write_ptr1] <= sensor_in1;
                write_ptr1 <= write_ptr1 + 1;
                if(write_ptr1 == BUFFER_DEPTH-1) buffer_full1 <= 1;
            end
            sensor_ready1 <= ~buffer_full1;

            // Sensor 2
            if(sensor_valid2 && sensor_ready2) begin
                buffer2[write_ptr2] <= sensor_in2;
                write_ptr2 <= write_ptr2 + 1;
                if(write_ptr2 == BUFFER_DEPTH-1) buffer_full2 <= 1;
            end
            sensor_ready2 <= ~buffer_full2;

            // Sensor 3
            if(sensor_valid3 && sensor_ready3) begin
                buffer3[write_ptr3] <= sensor_in3;
                write_ptr3 <= write_ptr3 + 1;
                if(write_ptr3 == BUFFER_DEPTH-1) buffer_full3 <= 1;
            end
            sensor_ready3 <= ~buffer_full3;
        end
    end

    // -----------------------------
    // Read logic (round-robin)
    // -----------------------------
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            read_ptr <= 0;
            sensor_idx <= 0;
            data_out <= 0;
            data_out_valid <= 0;
        end else begin
            case(sensor_idx)
                2'd0: if(buffer_full0 && data_out_ready) begin
                        data_out <= buffer0[read_ptr];
                        data_out_valid <= 1;
                        read_ptr <= read_ptr + 1;
                        if(read_ptr == BUFFER_DEPTH-1) begin
                            read_ptr <= 0;
                            buffer_full0 <= 0;
                            sensor_idx <= sensor_idx + 1;
                        end
                     end
                2'd1: if(buffer_full1 && data_out_ready) begin
                        data_out <= buffer1[read_ptr];
                        data_out_valid <= 1;
                        read_ptr <= read_ptr + 1;
                        if(read_ptr == BUFFER_DEPTH-1) begin
                            read_ptr <= 0;
                            buffer_full1 <= 0;
                            sensor_idx <= sensor_idx + 1;
                        end
                     end
                2'd2: if(buffer_full2 && data_out_ready) begin
                        data_out <= buffer2[read_ptr];
                        data_out_valid <= 1;
                        read_ptr <= read_ptr + 1;
                        if(read_ptr == BUFFER_DEPTH-1) begin
                            read_ptr <= 0;
                            buffer_full2 <= 0;
                            sensor_idx <= sensor_idx + 1;
                        end
                     end
                2'd3: if(buffer_full3 && data_out_ready) begin
                        data_out <= buffer3[read_ptr];
                        data_out_valid <= 1;
                        read_ptr <= read_ptr + 1;
                        if(read_ptr == BUFFER_DEPTH-1) begin
                            read_ptr <= 0;
                            buffer_full3 <= 0;
                            sensor_idx <= 0;
                        end
                     end
                default: sensor_idx <= 0;
            endcase
            if(!(buffer_full0 || buffer_full1 || buffer_full2 || buffer_full3))
                data_out_valid <= 0;
        end
    end

endmodule
