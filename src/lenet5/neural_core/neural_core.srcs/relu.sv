
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: relu
// Description: ReLu Activation Function
//////////////////////////////////////////////////////////////////////////////////

module relu #(
    parameter data_width=8,
    parameter weight_int_width_fp=1 // width of integer part of fixed point #
)
(
    input                         clk,
    input      [2*data_width-1:0] in,
    output reg [data_width-1:0]   out
);

//    always @(posedge clk) begin
//        if ($signed(in) >= 0) begin
//            // overflow sign bit of integer part
//            if ( | in[2*data_width-1 -: weight_int_width_fp]) begin
//                // saturation
//                out <= {1'b0, {data_width-1{1'b1}}};
//            end
//            else out <= in[2*data_width-1-weight_int_width_fp -: data_width];
//        end
//        else out <= 'd0;
//    end

    always @(posedge clk) begin
//        if (in >= 0) out <= in[2*data_width-1 -: data_width];
        if (in >= 127) out <= in[2*data_width-1 -: data_width];
        else out <= 'd0;
    end

endmodule
