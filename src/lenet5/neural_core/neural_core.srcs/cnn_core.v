`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: cnn_core
// Description:
//////////////////////////////////////////////////////////////////////////////////

`include "nc_defines.vh"

module cnn_core #(
    parameter pixel_width  = 8 , // 8bits per pixel channel (r/g/b)
    parameter kernel_width = 3 , // 3x3 kernel
    parameter image_width  = 32  // 32x32 image (change if needed)
) (
    input                                      i_clk             ,
    input                                      i_rst             ,
    input  [pixel_width*(kernel_width**2)-1:0] i_pixels          ,
    input                                      i_pixels_valid    ,
    output [128*pixel_width*4-1:0]             o_cnn_result      ,
    output                                     o_cnn_result_valid
);


    genvar i;
    integer a;
    integer b;
    integer c;

    localparam NUM_OF_CONV_MODULES_L1 = 32 ;
    localparam NUM_OF_CONV_MODULES_L2 = 64 ;
    localparam NUM_OF_CONV_MODULES_L3 = 128;

    localparam FILTER_DEPTH_L1 = 1;
    localparam FILTER_DEPTH_L2 = 32;
    localparam FILTER_DEPTH_L3 = 64;


    reg [FILTER_DEPTH_L1*pixel_width*(kernel_width**2)-1:0] kernel_l1[0:NUM_OF_CONV_MODULES_L1-1];
    reg [FILTER_DEPTH_L2*pixel_width*(kernel_width**2)-1:0] kernel_l2[0:NUM_OF_CONV_MODULES_L2-1];
    reg [FILTER_DEPTH_L3*pixel_width*(kernel_width**2)-1:0] kernel_l3[0:NUM_OF_CONV_MODULES_L3-1];

    reg [pixel_width-1:0] bias_l1[NUM_OF_CONV_MODULES_L1-1:0];
    reg [pixel_width-1:0] bias_l2[NUM_OF_CONV_MODULES_L2-1:0];
    reg [pixel_width-1:0] bias_l3[NUM_OF_CONV_MODULES_L3-1:0];


    wire kernel_valid;
    wire bias_valid;

    wire [NUM_OF_CONV_MODULES_L3-1:0] o_cnn_result_valid_list;


    wire [NUM_OF_CONV_MODULES_L1*pixel_width*(kernel_width**2)-1:0] conv_l2_input      ;
    wire [NUM_OF_CONV_MODULES_L1-1:0] conv_l2_input_valid;


    wire [NUM_OF_CONV_MODULES_L2*pixel_width*(kernel_width**2)-1:0] conv_l3_input      ;
    wire [NUM_OF_CONV_MODULES_L2-1:0] conv_l3_input_valid;


    assign kernel_valid       = 1'b1;
    assign bias_valid         = 1'b1;
    
    initial begin
        $readmemh({`conv_layer_wb_dir,"weights_0.mem"}, kernel_l1);
        $readmemh({`conv_layer_wb_dir,"weights_1.mem"}, kernel_l2);
        $readmemh({`conv_layer_wb_dir,"weights_2.mem"}, kernel_l3);
        $readmemh({`conv_layer_wb_dir,"biases_0.mem"}, bias_l1);
        $readmemh({`conv_layer_wb_dir,"biases_1.mem"}, bias_l2);
        $readmemh({`conv_layer_wb_dir,"biases_2.mem"}, bias_l3);
    end
/*
    initial begin
        for(a=0;a<NUM_OF_CONV_MODULES_L1;a=a+1)begin
            kernel_l1[a] = 'd1;
            bias_l1[a]   = 'd0;
        end
    end
    
        
    initial begin
        for(b=0;b<NUM_OF_CONV_MODULES_L2;b=b+1)begin
            kernel_l2[b] = 'd1;
            bias_l2[a]   = 'd0;
        end
    end
    
        initial begin
        for(c=0;c<NUM_OF_CONV_MODULES_L3;c=c+1)begin
            kernel_l3[c] = 'd1;
            bias_l3[a]   = 'd0;
        end
    end
    */
    assign o_cnn_result_valid = o_cnn_result_valid_list[0];


    ////////////////////////////////////////////////////////////
    /////////////// LAYER1_BEGIN ///////////////////////////////
    ////////////////////////////////////////////////////////////
    generate
    for (i=0; i<NUM_OF_CONV_MODULES_L1; i=i+1) begin
        cnn_layer_one_channel # (
            .pixel_width(pixel_width),
            .kernel_width(kernel_width),
            .image_width(32),
            .filter_depth(FILTER_DEPTH_L1),
            .output_width(3)
        ) cnn_layer1_inst (
            .i_clk(i_clk),
            .i_rst(i_rst),
            .i_pixels(i_pixels), //todo
            .i_pixels_valid(i_pixels_valid), //todo
            .i_kernel(kernel_l1[i]),
            .i_kernel_valid(kernel_valid),
            .i_bias        (bias_l1[i]),
            .i_bias_valid  (bias_valid),
            .o_data(conv_l2_input[(i+1)*pixel_width*(kernel_width**2)-1:i*pixel_width*(kernel_width**2)]),
            .o_data_valid(conv_l2_input_valid[i])
        );
    end
    endgenerate


    ////////////////////////////////////////////////////////////
    /////////////// LAYER1_END /////////////////////////////////
    ////////////////////////////////////////////////////////////



    ////////////////////////////////////////////////////////////
    /////////////// LAYER2_BEGIN ///////////////////////////////
    ////////////////////////////////////////////////////////////  
    generate
    for (i=0; i<NUM_OF_CONV_MODULES_L2; i=i+1) begin
        cnn_layer_one_channel # (
            .pixel_width(pixel_width),
            .kernel_width(kernel_width),
            .image_width(15),
            .filter_depth(FILTER_DEPTH_L2),
            .output_width(3)
        ) cnn_layer2_inst (
            .i_clk(i_clk),
            .i_rst(i_rst),
            .i_pixels(conv_l2_input),
            .i_pixels_valid(conv_l2_input_valid[0]),
            .i_kernel(kernel_l2[i]),
            .i_kernel_valid(kernel_valid),
            .i_bias        (bias_l2[i]),
            .i_bias_valid  (bias_valid),
            .o_data(conv_l3_input[(i+1)*pixel_width*(kernel_width**2)-1:i*pixel_width*(kernel_width**2)]),
            .o_data_valid(conv_l3_input_valid[i])
        );

    end
    endgenerate

    ////////////////////////////////////////////////////////////
    /////////////// LAYER2_END /////////////////////////////////
    ////////////////////////////////////////////////////////////



    ////////////////////////////////////////////////////////////
    /////////////// LAYER3_BEGIN ///////////////////////////////
    ////////////////////////////////////////////////////////////
   
    generate
    for (i=0; i<NUM_OF_CONV_MODULES_L3; i=i+1) begin
        cnn_layer_one_channel # (
            .pixel_width(pixel_width),
            .kernel_width(kernel_width),
            .image_width(6),
            .filter_depth(FILTER_DEPTH_L3),
            .output_width(2)
        ) cnn_layer3_inst (
            .i_clk(i_clk),
            .i_rst(i_rst),
            .i_pixels(conv_l3_input),
            .i_pixels_valid(conv_l3_input_valid[0]),
            .i_kernel(kernel_l3[i]),
            .i_kernel_valid(kernel_valid),
            .i_bias        (bias_l3[i]),
            .i_bias_valid  (bias_valid),
            .o_data(o_cnn_result[(i+1)*pixel_width*(2**2)-1:i*pixel_width*(2**2)]),
            .o_data_valid(o_cnn_result_valid_list[i])
        );

    end
    endgenerate

    ////////////////////////////////////////////////////////////
    /////////////// LAYER3_END /////////////////////////////////
    ////////////////////////////////////////////////////////////


endmodule













