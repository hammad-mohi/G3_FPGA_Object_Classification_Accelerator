`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name:
// Description:
//////////////////////////////////////////////////////////////////////////////////

module cnn_layer_one_channel #(
    parameter pixel_width  = 8 , // 8bits per pixel channel (r/g/b)
    parameter kernel_width = 3 , // 3x3 kernel
    parameter image_width  = 32,  // 128x128 image (change if needed)
    parameter filter_depth = 1 ,
    parameter output_width = 3
) (
    input                                      i_clk         ,
    input                                      i_rst         ,
    input  [filter_depth*pixel_width*(kernel_width**2)-1:0] i_pixels,
    input                                      i_pixels_valid,
    input  [filter_depth* pixel_width*(kernel_width**2)-1:0] i_kernel      ,
    input                                      i_kernel_valid,
    input  [pixel_width-1:0]                   i_bias,
    input                                      i_bias_valid,
    output [pixel_width*(output_width**2)-1:0] o_data        ,
    output                                     o_data_valid
);

    genvar i;
    wire [ filter_depth*pixel_width-1:0] conv_result          ;
    wire [filter_depth-1:0] conv_result_valid    ;
    wire [pixel_width-1:0] bias_output;
    wire bias_output_valid;
    wire [pixel_width*(2**2)-1:0] max_pool_input       ;
    wire                          max_pool_input_valid ;
    wire [pixel_width-1:0] max_pool_output;
    wire max_pool_output_valid;
    wire [pixel_width-1:0]adder_output;
    wire adder_output_valid;

    generate
    if(filter_depth == 1) begin
        for (i=0; i<filter_depth; i=i+1) begin
            conv #(
                .pixel_width (pixel_width ),
                .kernel_width(kernel_width)
            ) conv_inst (
                .i_clk              (i_clk),
                .i_rst              (i_rst),
                .i_pixels           (i_pixels[(i+1)*pixel_width*(kernel_width**2)-1:i*pixel_width*(kernel_width**2)]),
                .i_pixels_valid     (i_pixels_valid),
                .i_kernel           (i_kernel[(i+1)*pixel_width*(kernel_width**2)-1:i*pixel_width*(kernel_width**2)]),
                .i_kernel_valid     (i_kernel_valid),
                .o_conv_result      (conv_result[(i+1)*pixel_width-1:i*pixel_width]),
                .o_conv_result_valid(conv_result_valid[i])
            );
        end

        conv_bias #(
            .pixel_width(pixel_width)
        ) conv_bias_inst(
            .i_clk         (i_clk),
            .i_rst         (i_rst),
            .i_pixels      (conv_result),
            .i_pixels_valid(conv_result_valid),
            .i_bias        (i_bias),
            .i_bias_valid  (i_bias_valid),
            .o_data        (bias_output),
            .o_data_valid  (bias_output_valid)
        );

        inter_ram_to_max #(
            .data_width   (pixel_width  ),
            .row_width    (image_width-2), // dimension of the ram block, i.e. 30x30
            .counter_width(5            ), // DON'T CHANGE
            .kernel_width (2            )  // DON'T CHANGE
        ) ram_to_max_inst (
            .i_clk       (i_clk               ),
            .i_rst       (i_rst               ),
            .i_data      (bias_output         ),
            .i_data_valid(bias_output_valid   ),
            .o_data(max_pool_input      ),
            .o_data_valid      (max_pool_input_valid)
        );
    end 


    else if(filter_depth == 32) begin
        pipelined_layer #(  
            .pixel_width (pixel_width),
            .kernel_width(kernel_width),
            .filter_depth(filter_depth)
        ) pipelined_layer32_inst (
            .i_clk         (i_clk),
            .i_rst         (i_rst),
            .i_pixels      (i_pixels),
            .i_pixels_valid(i_pixels_valid),
            .i_kernel      (i_kernel),
            .i_kernel_valid(i_kernel_valid),
            .o_data        (adder_output),
            .o_data_valid  (adder_output_valid)
        );

        conv_bias #(
            .pixel_width(pixel_width)
        ) conv_bias_inst(
            .i_clk         (i_clk),
            .i_rst         (i_rst),
            .i_pixels      (adder_output),
            .i_pixels_valid(adder_output_valid),
            .i_bias        (i_bias),
            .i_bias_valid  (i_bias_valid),
            .o_data        (bias_output),
            .o_data_valid  (bias_output_valid)
        );

        inter_ram_to_max #(
            .data_width   (pixel_width  ),
            .row_width    (image_width-2), // dimension of the ram block, i.e. 30x30
            .counter_width(5            ), // DON'T CHANGE
            .kernel_width (2            )  // DON'T CHANGE
        ) ram_to_max_inst (
            .i_clk       (i_clk               ),
            .i_rst       (i_rst               ),
            .i_data      (bias_output         ),
            .i_data_valid(bias_output_valid   ),
            .o_data      (max_pool_input      ),
            .o_data_valid(max_pool_input_valid)
        );

    end 


    else if(filter_depth == 64) begin
        pipelined_layer #(  
            .pixel_width (pixel_width),
            .kernel_width(kernel_width),
            .filter_depth(filter_depth)
        ) pipelined_layer64_inst (
            .i_clk(i_clk),
            .i_rst         (i_rst),
            .i_pixels      (i_pixels),
            .i_pixels_valid(i_pixels_valid),
            .i_kernel      (i_kernel),
            .i_kernel_valid(i_kernel_valid),
            .o_data        (adder_output),
            .o_data_valid  (adder_output_valid)
        );

        conv_bias #(
            .pixel_width(pixel_width)
        ) conv_bias_inst(
            .i_clk         (i_clk),
            .i_rst         (i_rst),
            .i_pixels      (adder_output),
            .i_pixels_valid(adder_output_valid),
            .i_bias        (i_bias),
            .i_bias_valid  (i_bias_valid),
            .o_data        (bias_output),
            .o_data_valid  (bias_output_valid)
        );

        inter_ram_to_max #(
            .data_width   (pixel_width  ),
            .row_width    (image_width-2), // dimension of the ram block, i.e. 30x30
            .counter_width(5            ), // DON'T CHANGE
            .kernel_width (2            )  // DON'T CHANGE
        ) ram_to_max_inst (
            .i_clk       (i_clk               ),
            .i_rst       (i_rst               ),
            .i_data      (bias_output         ),
            .i_data_valid(bias_output_valid   ),
            .o_data      (max_pool_input      ),
            .o_data_valid(max_pool_input_valid)
        );
    end 


    max_pool #(
        .data_width  (pixel_width),
        .kernel_width(2          )  // DON'T CHANGE
    ) max_pool_inst (
        .i_clk       (i_clk                ),
        .i_rst       (i_rst                ),
        .i_data      (max_pool_input       ),
        .i_data_valid(max_pool_input_valid ),
        .o_data      (max_pool_output      ),
        .o_data_valid(max_pool_output_valid)
    );

 
    if(filter_depth == 1) begin
        inter_ram_to_conv #(
            .data_width   (pixel_width),
            .row_width    (15         ), // dimension of the ram block, i.e. 15x15
            .counter_width(5          ), // DON'T CHANGE
            .kernel_width (3          )  // DON'T CHANGE
        ) ram_to_conv_inst (
            .i_clk       (i_clk                   ),
            .i_rst       (i_rst                   ),
            .i_data      (max_pool_output      ),
            .i_data_valid(max_pool_output_valid),
            .o_data      (o_data           ),
            .o_data_valid(o_data_valid     )
        );
    end


    else if(filter_depth == 32) begin
        inter_ram_to_conv #(
            .data_width   (pixel_width),
            .row_width    (6         ), // dimension of the ram block, i.e. 15x15
            .counter_width(5          ), // DON'T CHANGE
            .kernel_width (3          )  // DON'T CHANGE
        ) ram_to_conv_inst (
            .i_clk       (i_clk                   ),
            .i_rst       (i_rst                   ),
            .i_data      (max_pool_output      ),
            .i_data_valid(max_pool_output_valid),
            .o_data      (o_data           ),
            .o_data_valid(o_data_valid     )
        );
    end


    else if(filter_depth == 64) begin
        inter_ram_to_max #(
            .data_width   (pixel_width),
            .row_width    (2         ), // dimension of the ram block, i.e. 15x15
            .counter_width(5          ), // DON'T CHANGE
            .kernel_width (2          )  // DON'T CHANGE
        ) ram_to_max_inst (
            .i_clk       (i_clk                   ),
            .i_rst       (i_rst                   ),
            .i_data      (max_pool_output      ),
            .i_data_valid(max_pool_output_valid),
            .o_data      (o_data           ),
            .o_data_valid(o_data_valid     )
        );
    end
    endgenerate

endmodule


