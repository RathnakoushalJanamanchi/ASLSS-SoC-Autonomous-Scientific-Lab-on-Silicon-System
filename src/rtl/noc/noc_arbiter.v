`timescale 1ns/1ps
module noc_arbiter (
    input  wire [4:0] req,
    output reg  [4:0] grant
);
    always @(*) begin
        grant = 5'b0;
        // Priority: Local > North > South > East > West
        if (req[4]) grant[4] = 1;
        else if (req[0]) grant[0] = 1;
        else if (req[1]) grant[1] = 1;
        else if (req[2]) grant[2] = 1;
        else if (req[3]) grant[3] = 1;
    end
endmodule
