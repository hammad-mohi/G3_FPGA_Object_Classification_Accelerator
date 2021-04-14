
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: softmax
// Description: Softmax Activation Function
//////////////////////////////////////////////////////////////////////////////////

module softmax #(
    parameter num_inputs=43,
    parameter data_width=16
)
(
    input                                  clk,
    input                                  rst,
    input      [num_inputs*data_width-1:0] i_data,        // flattened neurons in output layer
    input                                  i_data_valid,
    output reg [data_width-1:0]            o_max,         // actual max value
    output reg                             o_max_valid,
    output reg [31:0]                      max_neuron_idx // which neuron in output layer
);
    integer i = 0; // max finder counter
    reg [num_inputs*data_width-1:0] data_buf = 'd0;
    
    // find the neuron with max value in 'num_inputs' clk cycles
    always @(posedge clk) begin
        if (rst) begin
            o_max <= 'd0;
            o_max_valid <= 'd0;
            max_neuron_idx <= -1;
        end
        else begin
            o_max_valid <= 1'b0;
            if (i_data_valid) begin
                o_max <= i_data[data_width-1:0];
                data_buf <= i_data; // register inputs and start processing next cycle
                max_neuron_idx <= 'd0;
                i <= 1; // start processing next cycle
            end
            // found max, raise o_max_valid so calling module knows when done
            else if (i == num_inputs) begin
                i <= 0;
                o_max_valid <= 1'b1;
            end
            // start finding max
            else if (i) begin
                i <= i + 1;
                if (data_buf[i*data_width +: data_width] > o_max) begin
                    o_max <= data_buf[i*data_width +: data_width];
                    max_neuron_idx <= i;
                end
            end
        end
    end

endmodule
