
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: conv
// Description: Perform MACC Operations Using a 3x3 Kernel
//////////////////////////////////////////////////////////////////////////////////

`include "nc_defines.vh"

`ifdef use_dsp
(* use_dsp = "yes" *)
`endif

module conv # (
    parameter pixel_width=8, // 8bits per pixel channel (r/g/b)
    parameter kernel_width=3 // 3x3 kernel
)
(
    input                                                 i_clk,
    input                                                 i_rst,
    input      [pixel_width*(kernel_width**2)-1:0] i_pixels, // 3x3 flattened pixels
    input                                                 i_pixels_valid,
    input      [pixel_width*(kernel_width**2)-1:0] i_kernel, // 3x3 flattened kernel
    input                                                 i_kernel_valid,
    output  [pixel_width-1:0]                   o_conv_result,
    output   o_conv_result_valid
);
    
    integer a;
    integer b;

  
    reg [pixel_width*2-1:0] mult_reg [kernel_width**2-1:0];
    reg [pixel_width*2-1:0] add_reg1 [4:0];
    reg [pixel_width*2-1:0] add_reg2 [2:0];
    reg [pixel_width*2-1:0] add_reg3 [1:0];
    reg [pixel_width*2-1:0] add_reg4;
    reg valid_reg [4:0];

    assign o_conv_result_valid = valid_reg[4];
    assign o_conv_result = add_reg4[2*pixel_width-1 : pixel_width];
    always @(posedge i_clk) begin
        if(i_rst) begin
            for(a=0;a<9;a=a+1)begin
                mult_reg[a] <= 'd0;
            end
            for(b=0;b<5;b=b+1)begin
                add_reg1[b] <= 'd0;
                valid_reg[b] <= 'd0;
            end
            add_reg2[0] <= 'd0;
            add_reg2[1] <= 'd0;
            add_reg2[2] <= 'd0;
            add_reg3[0] <= 'd0;
            add_reg3[1] <= 'd0;
            add_reg4 <= 'd0;
        end
        else begin
            mult_reg[0] <= i_pixels[1*pixel_width-1:0*pixel_width] * i_kernel[1*pixel_width-1:0*pixel_width];
            mult_reg[1] <= i_pixels[2*pixel_width-1:1*pixel_width] * i_kernel[2*pixel_width-1:1*pixel_width];
            mult_reg[2] <= i_pixels[3*pixel_width-1:2*pixel_width] * i_kernel[3*pixel_width-1:2*pixel_width];
            mult_reg[3] <= i_pixels[4*pixel_width-1:3*pixel_width] * i_kernel[4*pixel_width-1:3*pixel_width];
            mult_reg[4] <= i_pixels[5*pixel_width-1:4*pixel_width] * i_kernel[5*pixel_width-1:4*pixel_width];
            mult_reg[5] <= i_pixels[6*pixel_width-1:5*pixel_width] * i_kernel[6*pixel_width-1:5*pixel_width];
            mult_reg[6] <= i_pixels[7*pixel_width-1:6*pixel_width] * i_kernel[7*pixel_width-1:6*pixel_width];
            mult_reg[7] <= i_pixels[8*pixel_width-1:7*pixel_width] * i_kernel[8*pixel_width-1:7*pixel_width];
            mult_reg[8] <= i_pixels[9*pixel_width-1:8*pixel_width] * i_kernel[9*pixel_width-1:8*pixel_width];

            add_reg1[0] <= mult_reg[0] + mult_reg[1];
            add_reg1[1] <= mult_reg[2] + mult_reg[3];
            add_reg1[2] <= mult_reg[4] + mult_reg[5];
            add_reg1[3] <= mult_reg[6] + mult_reg[7];
            add_reg1[4] <= mult_reg[8];
            
            add_reg2[0] <= add_reg1[0] + add_reg1[1];
            add_reg2[1] <= add_reg1[2] + add_reg1[3];
            add_reg2[2] <= add_reg1[4];
            
            add_reg3[0] <= add_reg2[0] + add_reg2[1];
            add_reg3[1] <= add_reg2[2];
            
            add_reg4 <= add_reg3[0] + add_reg3[1];
            
            valid_reg[0] <= i_pixels_valid & i_kernel_valid;
            valid_reg[1] <= valid_reg[0];
            valid_reg[2] <= valid_reg[1];
            valid_reg[3] <= valid_reg[2];
            valid_reg[4] <= valid_reg[3];
             
        end
    end

endmodule
