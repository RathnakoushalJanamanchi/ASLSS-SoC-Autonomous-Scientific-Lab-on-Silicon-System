`timescale 1ns / 1ps

module swarm_comm_controller(

    input wire clk,
    input wire rst,

    // Incoming packet from NoC / communication layer
    input wire rx_valid,
    input wire [7:0] rx_msg_type,
    input wire [7:0] rx_sender_id,

    // Output to swarm engine
    output reg msg_valid,
    output reg [7:0] msg_type,
    output reg [7:0] sender_id,

    // Outgoing message request
    input wire send_msg,
    input wire [7:0] tx_msg_type,
    input wire [7:0] tx_target_id,

    // Output packet to communication layer
    output reg tx_valid,
    output reg [7:0] tx_msg_out,
    output reg [7:0] tx_target_out

);

always @(posedge clk or posedge rst) begin

    if(rst) begin

        msg_valid <= 0;
        tx_valid <= 0;

    end

    else begin

        msg_valid <= 0;
        tx_valid <= 0;

        // Receive swarm message
        if(rx_valid) begin

            msg_valid <= 1;
            msg_type <= rx_msg_type;
            sender_id <= rx_sender_id;

        end

        // Send swarm message
        if(send_msg) begin

            tx_valid <= 1;
            tx_msg_out <= tx_msg_type;
            tx_target_out <= tx_target_id;

        end

    end

end

endmodule
