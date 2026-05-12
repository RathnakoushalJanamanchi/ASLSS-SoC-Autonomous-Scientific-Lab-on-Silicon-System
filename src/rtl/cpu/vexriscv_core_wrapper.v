`timescale 1ns/1ps
module vexriscv_core_wrapper #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 32
)(
    input  wire clk,
    input  wire rst,

    // Shared memory interface
    output reg [ADDR_WIDTH-1:0] mem_addr,
    output reg [DATA_WIDTH-1:0] mem_wdata,
    output reg                  mem_write,
    output reg                  mem_read,
    input  wire [DATA_WIDTH-1:0] mem_rdata,
    input  wire                  mem_ready,

    // NoC local interface
    input  wire [DATA_WIDTH+7:0] noc_local_in,
    input  wire                  noc_local_valid,
    output reg [DATA_WIDTH+7:0] noc_local_out,
    output reg                  noc_local_out_valid,
    output reg                  noc_local_ready,

    // Interrupt input from enhanced controller
    input wire irq
);

    // --- Pipeline state ---
    reg [ADDR_WIDTH-1:0] pc;
    reg [2:0] state;

    localparam IDLE      = 3'b000,
               FETCH     = 3'b001,
               EXEC      = 3'b010,
               MEM       = 3'b011,
               WRITEBACK = 3'b100;

    // ALU result register (demo)
    reg [DATA_WIDTH-1:0] alu_result;

    // --- Main sequential logic ---
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            pc <= 0;
            state <= IDLE;
            mem_addr <= 0;
            mem_wdata <= 0;
            mem_write <= 0;
            mem_read <= 0;
            noc_local_out <= 0;
            noc_local_out_valid <= 0;
            noc_local_ready <= 0;
            alu_result <= 0;
        end else begin
            case(state)
                IDLE: begin
                    if(irq) begin
                        // Handle interrupt: simple jump to ISR (demo)
                        pc <= 32'h1000;
                        state <= FETCH;
                    end else begin
                        state <= FETCH;
                    end
                end

                FETCH: begin
                    mem_addr <= pc;
                    mem_read <= 1;
                    state <= MEM;
                end

                MEM: if(mem_ready) begin
                    mem_read <= 0;
                    alu_result <= mem_rdata + 1; // simple ALU operation
                    state <= EXEC;
                end

                EXEC: begin
                    pc <= pc + 4;

                    // NoC handshake
                    if(noc_local_valid) begin
                        noc_local_out <= noc_local_in + 1;
                        noc_local_out_valid <= 1;
                        noc_local_ready <= 1;
                    end else begin
                        noc_local_out_valid <= 0;
                        noc_local_ready <= 0;
                    end

                    state <= WRITEBACK;
                end

                WRITEBACK: begin
                    mem_addr <= pc;
                    mem_wdata <= alu_result;
                    mem_write <= 1;
                    state <= FETCH;
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule
