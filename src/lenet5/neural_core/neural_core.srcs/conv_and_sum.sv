`timescale 1ns / 1ps

module conv_and_sum # (
    parameter count_width=6,
    parameter pixel_width=8)
(
    input                                                 i_clk,
    input                                                 i_rst,
    input  reg [pixel_width*9-1:0]                        i_pixels,
    input  reg                                            i_pixels_valid,
    input  reg [pixel_width*9-1:0]                        i_kernels, 
    input  reg                                            i_kernels_valid,
    output [pixel_width-1:0]                              o_result,
    output   reg                                             o_result_valid
);

    localparam count_max = 2**count_width;

    reg [count_width-1:0] counter;
    reg [pixel_width+count_width-1:0] temp_result;
    wire new_comp;
    wire [pixel_width-1:0] conv_result;
    wire conv_result_valid;

    assign new_comp = (counter == 'd0);
    assign comp_done = (counter == (count_max-1));
    assign o_result = temp_result[pixel_width+count_width-1:count_width];
//        assign o_result = temp_result[pixel_width-1:0];

    //assign o_result_valid = conv_result_valid & new_comp;
    
    always @(posedge i_clk) begin
        if(i_rst) begin
            o_result_valid <= 'd0;
        end
        
        else begin
            o_result_valid = conv_result_valid & comp_done;
        end
    end

    conv #(
        .pixel_width (pixel_width ),
        .kernel_width(3)
    ) conv_inst (
        .i_clk              (i_clk),
        .i_rst(i_rst),
        .i_pixels           (i_pixels),
        .i_pixels_valid     (i_pixels_valid),
        .i_kernel           (i_kernels),
        .i_kernel_valid     (i_kernels_valid),
        .o_conv_result      (conv_result),
        .o_conv_result_valid(conv_result_valid)
    );


    always @(posedge i_clk) begin 
        if(i_rst) begin
            counter <= 'd0;
        end 
        else if(conv_result_valid) begin
            counter <= counter + 'd1;
        end
        else begin
            counter <= counter;
        end
    end


    always @(posedge i_clk) begin
        if(i_rst) begin
            temp_result <= 'd0;
        end
        else if(new_comp&conv_result_valid) begin
            temp_result <= conv_result;
        end
        else if(conv_result_valid) begin
            temp_result <= temp_result + conv_result; 
        end
        else begin
            temp_result <= temp_result;
        end
    end

endmodule
