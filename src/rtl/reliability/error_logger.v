`timescale 1ns / 1ps

module error_logger #(
    parameter LOG_DEPTH = 16
)(
    input wire clk,
    input wire rst,

    input wire fault_detected,
    input wire [2:0] fault_type,

    input wire read_log,
    input wire [3:0] read_index,

    output reg [2:0] log_fault_type,
    output reg log_valid
);

reg [2:0] fault_log [0:LOG_DEPTH-1];
reg [3:0] log_pointer;

integer i;

always @(posedge clk or posedge rst) begin

    if(rst) begin
        log_pointer <= 0;
        log_valid <= 0;

        for(i = 0; i < LOG_DEPTH; i = i + 1)
            fault_log[i] <= 0;
    end
    else begin

        log_valid <= 0;

        // Store new fault
        if(fault_detected) begin
            fault_log[log_pointer] <= fault_type;

            if(log_pointer == LOG_DEPTH-1)
                log_pointer <= 0;
            else
                log_pointer <= log_pointer + 1;
        end

        // Read log entry
        if(read_log) begin
            log_fault_type <= fault_log[read_index];
            log_valid <= 1;
        end

    end

end

endmodule
