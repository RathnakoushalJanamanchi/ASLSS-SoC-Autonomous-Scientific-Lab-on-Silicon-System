`timescale 1ns / 1ps

module vision_engine #(
    parameter DATA_WIDTH = 16
)(
    input wire clk,
    input wire rst,

    //////////////////////////////////////////////////
    // INPUT SENSOR STREAM
    //////////////////////////////////////////////////
    input wire [DATA_WIDTH-1:0] sensor_input,
    input wire sensor_valid,
    output reg sensor_ready,

    //////////////////////////////////////////////////
    // OUTPUT STREAM
    //////////////////////////////////////////////////
    output reg [DATA_WIDTH-1:0] vision_out,
    output reg vision_valid,
    input wire vision_ready
);

//////////////////////////////////////////////////
// INTERNAL REGISTERS
//////////////////////////////////////////////////
reg [DATA_WIDTH-1:0] stage1_data;
reg stage1_valid;

reg [DATA_WIDTH-1:0] stage2_data;
reg stage2_valid;

//////////////////////////////////////////////////
// STAGE 1: INPUT CAPTURE
//////////////////////////////////////////////////
always @(posedge clk or posedge rst) begin
    if (rst) begin
        stage1_data  <= 0;
        stage1_valid <= 0;
    end else begin
        if (sensor_valid && sensor_ready) begin
            stage1_data  <= sensor_input;
            stage1_valid <= 1'b1;
        end else if (stage2_valid && vision_ready) begin
            // pipeline moves forward
            stage1_valid <= 1'b0;
        end
    end
end

//////////////////////////////////////////////////
// STAGE 2: SIMPLE FEATURE EXTRACTION
// (placeholder for edge detection / CNN preproc)
//////////////////////////////////////////////////
always @(posedge clk or posedge rst) begin
    if (rst) begin
        stage2_data  <= 0;
        stage2_valid <= 0;
    end else begin
        if (stage1_valid) begin
            // Example transformation:
            // Split 16-bit into two bytes and combine features
            stage2_data <= {
                stage1_data[15:8] + stage1_data[7:0],   // simple intensity mix
                stage1_data[15:8] ^ stage1_data[7:0]    // edge-like XOR
            };
            stage2_valid <= 1'b1;
        end else if (vision_ready) begin
            stage2_valid <= 1'b0;
        end
    end
end

//////////////////////////////////////////////////
// OUTPUT STAGE
//////////////////////////////////////////////////
always @(posedge clk or posedge rst) begin
    if (rst) begin
        vision_out   <= 0;
        vision_valid <= 0;
    end else begin
        vision_valid <= 0;

        if (stage2_valid && vision_ready) begin
            vision_out   <= stage2_data;
            vision_valid <= 1'b1;
        end
    end
end

//////////////////////////////////////////////////
// READY LOGIC
//////////////////////////////////////////////////
always @(*) begin
    // ready when pipeline can accept new data
    sensor_ready = !stage1_valid || (vision_ready && stage2_valid);
end

endmodule
