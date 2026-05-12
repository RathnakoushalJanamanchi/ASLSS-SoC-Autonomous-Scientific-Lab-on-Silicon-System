`timescale 1ns / 1ps

// ----------------------------
// Majority Voter (for TMR)
// ----------------------------
module majority_voter(

input wire a,
input wire b,
input wire c,

output wire y

);

assign y = (a & b) | (a & c) | (b & c);

endmodule



// ----------------------------
// Simple Counter
// ----------------------------
module simple_counter #(parameter WIDTH=8)(

input wire clk,
input wire rst,
input wire enable,

output reg [WIDTH-1:0] count

);

always @(posedge clk or posedge rst) begin

    if(rst)
        count <= 0;

    else if(enable)
        count <= count + 1;

end

endmodule



// ----------------------------
// Priority Encoder (4→2)
// ----------------------------
module priority_encoder(

input wire [3:0] in,
output reg [1:0] out,
output reg valid

);

always @(*) begin

    valid = 1;

    casez(in)

        4'b1???: out = 2'd3;
        4'b01??: out = 2'd2;
        4'b001?: out = 2'd1;
        4'b0001: out = 2'd0;

        default: begin
            valid = 0;
            out = 0;
        end

    endcase

end

endmodule
