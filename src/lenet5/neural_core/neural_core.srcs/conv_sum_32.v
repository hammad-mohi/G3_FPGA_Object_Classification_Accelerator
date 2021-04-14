`timescale 1ns / 1ps

module conv_sum_32 # (
    parameter input_width=8)

(
    input                                                 i_clk,
    input                                                 i_rst,
    input   [input_width*32-1:0]                          i_conv, 
    input                                                 i_conv_valid,
    output       [input_width-1:0]                        o_result,
    output reg                                            o_result_valid
);


    integer i;

    reg [input_width+4:0] reg_stage1 [15:0];
    reg [input_width+4:0] reg_stage2 [7:0];
    reg [input_width+4:0] reg_stage3 [3:0];
    reg [input_width+4:0] reg_stage4 [1:0];
    reg valid_stage [3:0];
    reg [input_width+4:0] temp_o_result;

    assign o_result = temp_o_result[input_width+4:5];

    always @(posedge i_clk) begin
        reg_stage1[0] <= i_conv[2*input_width-1:1*input_width] + i_conv[1*input_width-1:0*input_width];
        reg_stage1[1] <= i_conv[4*input_width-1:3*input_width] + i_conv[3*input_width-1:2*input_width];
        reg_stage1[2] <= i_conv[6*input_width-1:5*input_width] + i_conv[5*input_width-1:4*input_width];
        reg_stage1[3] <= i_conv[8*input_width-1:7*input_width] + i_conv[7*input_width-1:6*input_width];
        reg_stage1[4] <= i_conv[10*input_width-1:9*input_width] + i_conv[9*input_width-1:8*input_width];
        reg_stage1[5] <= i_conv[12*input_width-1:11*input_width] + i_conv[11*input_width-1:10*input_width];
        reg_stage1[6] <= i_conv[14*input_width-1:13*input_width] + i_conv[13*input_width-1:12*input_width];
        reg_stage1[7] <= i_conv[16*input_width-1:15*input_width] + i_conv[15*input_width-1:14*input_width];
        reg_stage1[8] <= i_conv[18*input_width-1:17*input_width] + i_conv[17*input_width-1:16*input_width];
        reg_stage1[9] <= i_conv[20*input_width-1:19*input_width] + i_conv[19*input_width-1:18*input_width];
        reg_stage1[10] <= i_conv[22*input_width-1:21*input_width] + i_conv[21*input_width-1:20*input_width];
        reg_stage1[11] <= i_conv[24*input_width-1:23*input_width] + i_conv[23*input_width-1:22*input_width];
        reg_stage1[12] <= i_conv[26*input_width-1:25*input_width] + i_conv[25*input_width-1:24*input_width];
        reg_stage1[13] <= i_conv[28*input_width-1:27*input_width] + i_conv[27*input_width-1:26*input_width];
        reg_stage1[14] <= i_conv[30*input_width-1:29*input_width] + i_conv[29*input_width-1:28*input_width];
        reg_stage1[15] <= i_conv[32*input_width-1:31*input_width] + i_conv[31*input_width-1:30*input_width];
        

        for (i=0;i<8;i=i+1) begin
            reg_stage2[i] <= reg_stage1[2*i] + reg_stage1[2*i+1];
        end

        for (i=0;i<4;i=i+1) begin
            reg_stage3[i] <= reg_stage2[2*i] + reg_stage2[2*i+1];
        end

        for (i=0;i<2;i=i+1) begin
            reg_stage4[i] <= reg_stage3[2*i] + reg_stage3[2*i+1];
        end

        temp_o_result <= (reg_stage4[1] + reg_stage4[0]);

 
    end


    always @(posedge i_clk) begin
        if(i_rst) begin
            valid_stage[0] <= 'd0;
            valid_stage[1] <= 'd0;
            valid_stage[2] <= 'd0;
            valid_stage[3] <= 'd0;
            o_result_valid <= 'd0;
        end
        else begin
            valid_stage[0] <= i_conv_valid;
            valid_stage[1] <= valid_stage[0];
            valid_stage[2] <= valid_stage[1];
            valid_stage[3] <= valid_stage[2];
            o_result_valid <= valid_stage[3];
        end
    end

endmodule
