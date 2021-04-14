//////////////////////////////////////////////////////////////////////////////////
// Module Name: mux_ram
// Description: Implement a large multiplexer using a RAM
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module mux_ram #(
    parameter pixel_width=8,
    parameter kernel_width=3,
    parameter num_inputs=64,
    parameter addr_width=6 // $clog2(num_inputs)
)(
    input                                                 i_clk,
    input                                                 i_rst, // active-high
    input  [num_inputs*pixel_width*(kernel_width**2)-1:0] i_in, // flattened 3x3 grid
    input                                                 i_valid,
    input  [addr_width-1:0]                               i_addr,
    output [pixel_width*(kernel_width**2)-1:0]            o_out,
    output reg                                            o_valid
);

    // flattened input size: easier to type
    localparam fi_size = pixel_width*(kernel_width**2);
    reg [fi_size-1:0]out;
    reg [fi_size-1:0] mxram [num_inputs-1:0]; // ram to be used as a mux
    //reg [addr_width-1:0] raddr='d0; // mux sel
//    integer i;
//    initial for(i=0;i<num_inputs;i=i+1)mxram[i]='d0;
    
    // store 'num_inputs' values in ram in parallel
    // only store if i_valid is high @ posedge of i_clk
    genvar j;
    generate
        for (j=0;j<num_inputs;j=j+1) begin
            always @(posedge i_clk) begin
                if (i_rst) mxram[j] <= 'd0;
                else if (i_valid) mxram[j] <= i_in[j*fi_size +: fi_size];
                else mxram[j] <= mxram[j];
            end
        end
    endgenerate
    
    // generate mux sel; raddr will overflow to 0 once 'num_inputs' reached
   // always @(posedge i_clk) begin
   //     if (i_rst) raddr <= {addr_width{1'b1}}; // start with all 1's to it overflows to 0 on 1st store
   //     else if (i_valid) raddr <= raddr + 'd1;
   // end
    
    // FIXME: might not want to output 0 when i_valid is low
    // make o_out available as soon as stored properly
    assign o_out = mxram[i_addr];

    
    // 1-stage pipeline to align o_valid with i_valid and 1st store
    always @(posedge i_clk) begin
        if (i_rst) o_valid <= 1'b0;
        else if (i_valid) o_valid <= 1'b1;
        else o_valid <= 1'b0;
    end

endmodule
