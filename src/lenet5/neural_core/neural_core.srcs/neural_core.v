
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: neural_core
// Description: LeNet Architecture 
//              Transfer data between neural core IP & DDR memory
//              Interface with DMA controller through AXI Stream interface 
//////////////////////////////////////////////////////////////////////////////////

`include "nc_defines.vh"

module neural_core # (
    parameter pixel_width=16, // 8bits per pixel channel (r/g/b)
    parameter kernel_width=3, // 3x3 kernel
    parameter image_width=32 // 128x128 image (change if needed)
)
(
    input                     axi_clk,
    input                     axi_resetn,
    // slave
    input  [pixel_width-1:0]  i_data,
    input                     i_data_valid,
    output                    o_data_ready,
    // master
    output [pixel_width-1:0]  o_data,
    //output [31:0]             o_index,
    output                    o_data_valid,
    input                     i_data_ready, // FIXME: maybe double check
    // interrupt
    output                    o_interrupt
);
    wire [128*pixel_width*4-1:0] cnn_result;
    wire cnn_result_valid;
    wire [pixel_width*(kernel_width**2)-1:0] pixels;
    wire pixels_valid;
    wire [pixel_width-1:0] o_data_tmp;
    wire [31:0] o_index;

    assign o_data = o_index[pixel_width-1:0];
    
    assign o_interrupt = o_data_valid;

    // always ready to recv axi stream data
    assign o_data_ready = 1'b1;

    inter_ram_to_conv #(
        .data_width   (pixel_width),
        .row_width    (image_width), // dimension of the ram block, i.e. 15x15
        .counter_width(6          ), // DON'T CHANGE
        .kernel_width (3          )  // DON'T CHANGE
    ) ram_to_conv_inst (
        .i_clk(axi_clk),
        .i_rst(~axi_resetn),
        .i_data(i_data),
        .i_data_valid(i_data_valid),
        .o_data(pixels),
        .o_data_valid(pixels_valid)
    );

    cnn_core # (
        .pixel_width(pixel_width),
        .kernel_width(kernel_width),
        .image_width(image_width)
    ) cnn_core_inst (
        .i_clk(axi_clk),
        .i_rst(~axi_resetn),
        .i_pixels(pixels), 
        .i_pixels_valid(pixels_valid), 
        .o_cnn_result(cnn_result),
        .o_cnn_result_valid(cnn_result_valid)
    );


    fully_connected_network fully_connected_network_inst (
        .clk(axi_clk),
        .rst(~axi_resetn),
        .i_data(cnn_result), 
        .i_data_valid(cnn_result_valid), 
        .o_data(o_data_tmp),
        .o_data_valid(o_data_valid),
        .o_max_neuron_idx(o_index)
    );

endmodule
