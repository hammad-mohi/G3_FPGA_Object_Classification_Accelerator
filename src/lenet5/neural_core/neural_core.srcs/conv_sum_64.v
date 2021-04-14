`timescale 1ns / 1ps

module conv_sum_64 # (
    parameter input_width=8)

(
    input                                                 i_clk,
    input                                                 i_rst,
    input   [input_width*64-1:0]                          i_conv, 
    input                                                 i_conv_valid,
    output       [input_width-1:0]                        o_result,
    output reg                                            o_result_valid
);


    integer i;

    reg [input_width+5:0] reg_stage1 [31:0];
    reg [input_width+5:0] reg_stage2 [15:0];
    reg [input_width+5:0] reg_stage3 [7:0];
    reg [input_width+5:0] reg_stage4 [3:0];
    reg [input_width+5:0] reg_stage5 [1:0];
    reg valid_stage [4:0];
    reg [input_width+5:0] temp_o_result;

    assign o_result = temp_o_result[input_width+5:6];

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
        reg_stage1[16] <= i_conv[34*input_width-1:33*input_width] + i_conv[33*input_width-1:32*input_width];
        reg_stage1[17] <= i_conv[36*input_width-1:35*input_width] + i_conv[35*input_width-1:34*input_width];
        reg_stage1[18] <= i_conv[38*input_width-1:37*input_width] + i_conv[37*input_width-1:36*input_width];
        reg_stage1[19] <= i_conv[40*input_width-1:39*input_width] + i_conv[39*input_width-1:38*input_width];
        reg_stage1[20] <= i_conv[42*input_width-1:41*input_width] + i_conv[41*input_width-1:40*input_width];
        reg_stage1[21] <= i_conv[44*input_width-1:43*input_width] + i_conv[43*input_width-1:42*input_width];
        reg_stage1[22] <= i_conv[46*input_width-1:45*input_width] + i_conv[45*input_width-1:44*input_width];
        reg_stage1[23] <= i_conv[48*input_width-1:47*input_width] + i_conv[47*input_width-1:46*input_width];
        reg_stage1[24] <= i_conv[50*input_width-1:49*input_width] + i_conv[49*input_width-1:48*input_width];
        reg_stage1[25] <= i_conv[52*input_width-1:51*input_width] + i_conv[51*input_width-1:50*input_width];
        reg_stage1[26] <= i_conv[54*input_width-1:53*input_width] + i_conv[53*input_width-1:52*input_width];
        reg_stage1[27] <= i_conv[56*input_width-1:55*input_width] + i_conv[55*input_width-1:54*input_width];
        reg_stage1[28] <= i_conv[58*input_width-1:57*input_width] + i_conv[57*input_width-1:56*input_width];
        reg_stage1[29] <= i_conv[60*input_width-1:59*input_width] + i_conv[59*input_width-1:58*input_width];
        reg_stage1[30] <= i_conv[62*input_width-1:61*input_width] + i_conv[61*input_width-1:60*input_width];
        reg_stage1[31] <= i_conv[64*input_width-1:63*input_width] + i_conv[63*input_width-1:62*input_width];
 


        for (i=0;i<16;i=i+1) begin
            reg_stage2[i] <= reg_stage1[2*i] + reg_stage1[2*i+1];
        end

        for (i=0;i<8;i=i+1) begin
            reg_stage3[i] <= reg_stage2[2*i] + reg_stage2[2*i+1];
        end

        for (i=0;i<4;i=i+1) begin
            reg_stage4[i] <= reg_stage3[2*i] + reg_stage3[2*i+1];
        end

        for (i=0;i<2;i=i+1) begin
            reg_stage5[i] <= reg_stage4[2*i] + reg_stage4[2*i+1];
        end

        temp_o_result <= (reg_stage5[1] + reg_stage5[0]);

 
    end


    always @(posedge i_clk) begin
        if(i_rst) begin
            valid_stage[0] <= 'd0;
            valid_stage[1] <= 'd0;
            valid_stage[2] <= 'd0;
            valid_stage[3] <= 'd0;
            valid_stage[4] <= 'd0;
            o_result_valid <= 'd0;
        end
        else begin
            valid_stage[0] <= i_conv_valid;
            valid_stage[1] <= valid_stage[0];
            valid_stage[2] <= valid_stage[1];
            valid_stage[3] <= valid_stage[2];
            valid_stage[4] <= valid_stage[3];
            o_result_valid <= valid_stage[4];
        end
    end

endmodule
