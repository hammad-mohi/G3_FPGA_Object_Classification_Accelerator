
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: row_buffer
// Description: Store 1 row of pixels read from DDR
//////////////////////////////////////////////////////////////////////////////////

module row_buffer # (
    parameter pixel_width=8, // 8bits per pixel channel (r/g/b)
    parameter kernel_width=3, // 3x3 kernel
    parameter image_width=128 // 128x128 image (change if needed)
)
(
    input                                 i_clk,
    input                                 i_rst,
    input  [pixel_width-1:0]              i_data,
    input                                 i_data_valid,
    output [kernel_width*pixel_width-1:0] o_data,
    input                                 i_rd_data // read request
);

    // ceiling of log base 2
    function integer clogb2 (input integer depth);
        begin    
            for(clogb2=0;depth>0;clogb2=clogb2+1) depth=depth>>1;    
        end    
    endfunction

    // bram-like buffer to hold 1 row of img
    reg [pixel_width-1:0] row [image_width-1:0];
    
    // read/write pointers to index into row
    localparam lg2_mem_depth = clogb2(image_width-1);
    reg [lg2_mem_depth-1:0] rd_ptr, wr_ptr;
    
    /*********************** write channel ***********************/
    always @(posedge i_clk) begin
        if (i_data_valid) row[wr_ptr] <= i_data;
    end
    
    // write ptr logic
    always @(posedge i_clk) begin
        if (i_rst) wr_ptr <= 'd0;
        else if (i_data_valid) wr_ptr <= wr_ptr + 'd1;
    end
    
    /*********************** read channel ************************/
    // concat 3 consecutive pixels and send it out with no latency
    assign o_data = {row[rd_ptr],row[rd_ptr+1],row[rd_ptr+2]};
    
    // read ptr logic
    always @(posedge i_clk) begin
        if (i_rst) rd_ptr <= 'd0;
        else if (i_rd_data) rd_ptr <= rd_ptr + 'd1;
    end

endmodule
