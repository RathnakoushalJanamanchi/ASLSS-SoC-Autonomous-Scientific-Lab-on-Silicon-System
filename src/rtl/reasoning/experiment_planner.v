`timescale 1ns / 1ps

module experiment_planner(

    input wire clk,
    input wire rst,

    // Input from context decision controller
    input wire trigger_experiment,
    input wire request_rescan,

    // Outputs to sensor engines
    output reg run_spectroscopy,
    output reg run_radar,
    output reg run_vision,

    // Experiment metadata
    output reg [7:0] experiment_id,
    output reg experiment_valid

);

reg [7:0] experiment_counter;

always @(posedge clk or posedge rst) begin

    if(rst) begin
        run_spectroscopy <= 0;
        run_radar <= 0;
        run_vision <= 0;
        experiment_valid <= 0;
        experiment_counter <= 0;
        experiment_id <= 0;
    end

    else begin

        // default signals
        run_spectroscopy <= 0;
        run_radar <= 0;
        run_vision <= 0;
        experiment_valid <= 0;

        if(trigger_experiment) begin

            experiment_counter <= experiment_counter + 1;
            experiment_id <= experiment_counter;

            // spectroscopy experiment
            run_spectroscopy <= 1;

            experiment_valid <= 1;

        end

        else if(request_rescan) begin

            experiment_counter <= experiment_counter + 1;
            experiment_id <= experiment_counter;

            // multi sensor scan
            run_radar <= 1;
            run_vision <= 1;

            experiment_valid <= 1;

        end

    end

end

endmodule
