`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name:
// Description:
//////////////////////////////////////////////////////////////////////////////////

module conv_bias #(parameter pixel_width  = 8 // 8bits per pixel channel (r/g/b)
) (
    input                    i_clk         ,
    input                    i_rst         ,
    input   [pixel_width-1:0] i_pixels      ,
    input                    i_pixels_valid,
    input   [pixel_width-1:0] i_bias        ,
    input                    i_bias_valid  ,
    output [pixel_width-1:0] o_data        ,
    output reg               o_data_valid
);


    reg [pixel_width:0] temp_o_data;
    
    // relu
    assign o_data = (temp_o_data[pixel_width:1] >= 127) ? temp_o_data[pixel_width:1] : 'd0;

    always @(posedge i_clk) begin
        if(i_rst) begin
            temp_o_data <= 'd0;
            o_data_valid <= 'd0;
        end    
        else if(i_pixels_valid & i_bias_valid) begin
            temp_o_data <= i_bias + i_pixels;
            o_data_valid <= 'd1;
        end
        else begin
            temp_o_data <= 'd0;
            o_data_valid <= 'd0;
        end
    end


endmodule