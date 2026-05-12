`timescale 1ns/1ps
module cpu_interrupt_controller #(
    parameter CORE_NUM = 4,
    parameter IRQ_NUM  = 32
)(
    input  wire clk,
    input  wire rst,

    // External interrupts
    input  wire [IRQ_NUM-1:0] ext_irq,     

    // Flattened interrupt masks: [IRQ_NUM*CORE_NUM-1:0]
    input  wire [(CORE_NUM*IRQ_NUM)-1:0] irq_mask_flat,

    // Per-core interrupt outputs
    output reg [CORE_NUM-1:0] irq_out
);

    // Internal array view
    wire irq_mask [0:IRQ_NUM-1][0:CORE_NUM-1];
    genvar i,j;
    generate
        for(i=0;i<IRQ_NUM;i=i+1) begin
            for(j=0;j<CORE_NUM;j=j+1) begin
                assign irq_mask[i][j] = irq_mask_flat[i*CORE_NUM + j];
            end
        end
    endgenerate

    // Latched interrupts
    reg [IRQ_NUM-1:0] irq_latched;

    integer irq_idx;   // procedural loop index
    integer core_idx;  // procedural loop index

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            irq_latched <= 0;
            irq_out <= 0;
        end else begin
            irq_latched <= ext_irq;
            irq_out <= 0;

            // Assign interrupts to cores based on priority and mask
            for (irq_idx = 0; irq_idx < IRQ_NUM; irq_idx = irq_idx + 1) begin
                if (irq_latched[irq_idx]) begin
                    for (core_idx = 0; core_idx < CORE_NUM; core_idx = core_idx + 1) begin
                        if (!irq_mask[irq_idx][core_idx] && !irq_out[core_idx]) begin
                            irq_out[core_idx] <= 1'b1;
                        end
                    end
                end
            end
        end
    end
endmodule
