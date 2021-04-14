
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: fc_weight_buffer
// Description: Store weights for the fully connected layers (ROM)
//////////////////////////////////////////////////////////////////////////////////

`include "nc_defines.vh"

module fc_weight_buffer #(
    parameter num_weights=3, // number of weights for a neuron
    parameter addr_width=10,
    parameter data_width=8,
    parameter wfile=""
)
(
    input                       clk,
    input                       rden,
    input      [addr_width:0]   rdaddr, // controlled from neuron.v
    input                       wren,
    input      [addr_width-1:0] wraddr, // controlled from neuron.v
    input      [data_width-1:0] i_weight_val,
    output reg [data_width-1:0] weight='d0
);

    reg [data_width-1:0] mem [0:num_weights-1];
    //int i = 0;
    //initial for(i=0;i<num_weights;i=i+1)mem[i]='d0;
    
    `ifdef use_per_neuron_wfiles
        // read from the provided mem file containing weights
        initial $readmemh(wfile, mem);
        //initial $readmemh("/home/mehdi/Desktop/ece532/project/stream/neural_core/neural_core.sim/sim_fc_network/behav/xsim/weights_layer1_n0.mem", mem);
        
    `else
        // store the input weights provided
        always @(posedge clk) begin
            if (wren) mem[wraddr] <= i_weight_val;
        end
    `endif
    
    // send out the requested wight
    // sequential since we want to use a bram and not distr. ram
    always @(posedge clk) begin
        if (rden) weight <= mem[rdaddr];
        else weight <= weight;
    end

endmodule
