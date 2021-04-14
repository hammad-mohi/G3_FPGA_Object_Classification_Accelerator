`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: inter_ram
// Description: ram between different blocks
//////////////////////////////////////////////////////////////////////////////////

module max_pool # (
    parameter data_width=8, //8 bit data
    parameter kernel_width=2 //DON'T CHANGE
)
(
    input                                 i_clk,
    input                                 i_rst,
    input  [data_width*(kernel_width**2)-1:0]     i_data,
    input                                 i_data_valid,
    output reg						      o_data_valid,
    output reg 	[data_width-1:0]	o_data
);


    wire [data_width-1:0] comp1;
    wire [data_width-1:0] comp2;
    wire [data_width-1:0] comp3;

    assign comp1 = (i_data[data_width*2-1:data_width] > i_data[data_width-1:0]) ? i_data[data_width*2-1:data_width] 
                                                                                : i_data[data_width-1:0];

    assign comp2 = (i_data[data_width*4-1:data_width*3] > i_data[data_width*3-1:data_width*2]) ? i_data[data_width*4-1:data_width*3]
                                                                                               : i_data[data_width*3-1:data_width*2];

    assign comp3 = (comp2 > comp1) ? comp2 : comp1;

    always @(posedge i_clk) begin
            if (i_rst) begin
                o_data_valid <= 'd0;
                o_data <= 'd0;
            end
            else begin
                o_data_valid <= i_data_valid;
                o_data <= comp3;
            end
    end

endmodule