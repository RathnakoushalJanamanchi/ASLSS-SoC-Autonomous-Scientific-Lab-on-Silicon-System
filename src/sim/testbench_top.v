`timescale 1ns / 1ps

module testbench_top;

reg clk;
reg rst;

// Clock generation (100 MHz)
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end


// Reset generation
initial begin
    rst = 1;
    #50;
    rst = 0;
end


// Instantiate the SoC
aslss_soc_top DUT (
    .clk(clk),
    .rst(rst)
);


// Simulation runtime
initial begin

    $display("Starting ASLSS SoC Simulation...");

    #2000;

    $display("Simulation finished.");
    $finish;

end


// Optional waveform dump
initial begin
    $dumpfile("aslss_soc.vcd");
    $dumpvars(0, testbench_top);
end


endmodule
