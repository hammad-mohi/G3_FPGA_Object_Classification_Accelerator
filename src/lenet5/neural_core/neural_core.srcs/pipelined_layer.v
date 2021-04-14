`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name:
// Description:
//////////////////////////////////////////////////////////////////////////////////

module pipelined_layer #(
    parameter pixel_width  = 8 , // 8bits per pixel channel (r/g/b)
    parameter kernel_width = 3 , // 3x3 kernel
    parameter filter_depth = 32 
) (
    input                                      i_clk         ,
    input                                      i_rst         ,
    input  [filter_depth*pixel_width*(kernel_width**2)-1:0] i_pixels,
    input                                      i_pixels_valid,
    input  [filter_depth* pixel_width*(kernel_width**2)-1:0] i_kernel      ,
    input                                      i_kernel_valid,
    output [pixel_width-1:0]                   o_data        ,
    output                                     o_data_valid
);

    wire [pixel_width*(kernel_width**2)-1:0] selected_ch;
    wire selected_ch_valid;
    wire [pixel_width*(kernel_width**2)-1:0] selected_kernel;
    wire selected_kernel_valid;
    wire [5:0] sel;


    wire [filter_depth*pixel_width*9-1:0] buffer_out;
    wire [filter_depth-1:0] buffer_out_valid;
    

    genvar i;

    generate

        if(filter_depth==32) begin

            for (i=0; i<filter_depth; i=i+1) begin
                input_buffer #(
                    .input_width (pixel_width),
                    .buffer_depth(169),
                    .count_width (5)
                ) input_buffer2_inst(
                    .i_clk         (i_clk),
                    .i_rst         (i_rst),
                    .i_data        (i_pixels[(i+1)*pixel_width*(kernel_width**2)-1:i*pixel_width*(kernel_width**2)]),
                    .i_data_valid  (i_pixels_valid),
                    .o_result      (buffer_out[(i+1)*pixel_width*(kernel_width**2)-1:i*pixel_width*(kernel_width**2)]),
                    .o_result_valid(buffer_out_valid[i])
                );
            end

            mux_logic #(
                .sel_width(5)
            ) mux_logic_32_inst (
                .i_clk(i_clk),
                .i_rst(i_rst),
                .i_data_valid(selected_ch_valid),
                .o_sel(sel[4:0])
            );


           mux_ram #(
            .pixel_width(pixel_width),
            .kernel_width(kernel_width),
            .num_inputs(32),
            .addr_width(5)  
           ) mux_32_ch_ins(
            .i_clk(i_clk),
            .i_rst(i_rst),
            .i_in(buffer_out),
            .i_valid(buffer_out_valid[0]),
            .i_addr(sel[4:0]),
            .o_out(selected_ch),
            .o_valid(selected_ch_valid)
           );



           mux_ram #(
            .pixel_width(pixel_width),
            .kernel_width(kernel_width),
            .num_inputs(32),
            .addr_width(5)  
           ) mux_32_kernel_ins(
            .i_clk(i_clk),
            .i_rst(i_rst),
            .i_in(i_kernel),
            .i_valid(i_kernel_valid),
            .i_addr(sel[4:0]),
            .o_out(selected_kernel),
            .o_valid(selected_kernel_valid)
           );


            conv_and_sum #(
                .count_width(5),
                .pixel_width(pixel_width)
            ) conv_and_sum32_inst (
                .i_clk(i_clk),
                .i_rst(i_rst),
                .i_pixels(selected_ch),
                .i_pixels_valid(selected_ch_valid),
                .i_kernels(selected_kernel),
                .i_kernels_valid(selected_kernel_valid),
                .o_result(o_data),
                .o_result_valid (o_data_valid)
            );
        end

        if(filter_depth==64) begin

            for (i=0; i<filter_depth; i=i+1) begin
                input_buffer #(
                    .input_width (pixel_width),
                    .buffer_depth(16),
                    .count_width (6)
                ) input_buffer3_inst(
                    .i_clk         (i_clk),
                    .i_rst         (i_rst),
                    .i_data        (i_pixels[(i+1)*pixel_width*(kernel_width**2)-1:i*pixel_width*(kernel_width**2)]),
                    .i_data_valid  (i_pixels_valid),
                    .o_result      (buffer_out[(i+1)*pixel_width*(kernel_width**2)-1:i*pixel_width*(kernel_width**2)]),
                    .o_result_valid(buffer_out_valid[i])
                );
            end

            mux_logic #(
                .sel_width(6)
            ) mux_logic_64_inst (
                .i_clk(i_clk),
                .i_rst(i_rst),
                .i_data_valid(selected_ch_valid),
                .o_sel(sel[5:0])
            );



           mux_ram #(
            .pixel_width(pixel_width),
            .kernel_width(kernel_width),
            .num_inputs(64),
            .addr_width(6)  
           ) mux_64_ch_ins(
            .i_clk(i_clk),
            .i_rst(i_rst),
            .i_in(buffer_out),
            .i_valid(buffer_out_valid[0]),
            .i_addr(sel[5:0]),
            .o_out(selected_ch),
            .o_valid(selected_ch_valid)
           );



           mux_ram #(
            .pixel_width(pixel_width),
            .kernel_width(kernel_width),
            .num_inputs(64),
            .addr_width(6)  
           ) mux_64_kernel_ins(
            .i_clk(i_clk),
            .i_rst(i_rst),
            .i_in(i_kernel),
            .i_valid(i_kernel_valid),
            .i_addr(sel[5:0]),
            .o_out(selected_kernel),
            .o_valid(selected_kernel_valid)
           );


            conv_and_sum #(
                .count_width(6),
                .pixel_width(pixel_width)
            ) conv_and_sum64_inst (
                .i_clk(i_clk),
                .i_rst(i_rst),
                .i_pixels(selected_ch),
                .i_pixels_valid(selected_ch_valid),
                .i_kernels(selected_kernel),
                .i_kernels_valid(selected_kernel_valid),
                .o_result(o_data),
                .o_result_valid (o_data_valid)
            );
        end      

    endgenerate


endmodule


