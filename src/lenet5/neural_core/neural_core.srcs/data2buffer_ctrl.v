
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: data2buffer_ctrl
// Description: Get image from DDR row by row and store in row buffers
//////////////////////////////////////////////////////////////////////////////////

`define num_row_buffers 4

module data2buffer_ctrl # (
    parameter pixel_width=8, // 8bits per pixel channel (r/g/b)
    parameter kernel_width=3, // 3x3 kernel
    parameter image_width=128 // 128x128 image (change if needed)
)
(
    input                                          i_clk,
    input                                          i_rst,
    input      [pixel_width-1:0]                   i_pixel, // one pixel
    input                                          i_pixel_valid,
    output reg [pixel_width*(kernel_width**2)-1:0] o_pixels,
    output                                         o_pixels_valid,
    output reg                                     o_interrupt
);
    
    // ceiling of log base 2
    function integer clogb2 (input integer depth);
        begin    
            for(clogb2=0;depth>0;clogb2=clogb2+1) depth=depth>>1;    
        end    
    endfunction
    
    localparam lg2_mem_depth = clogb2(image_width-1);
    localparam lg2_row_bufs = clogb2(`num_row_buffers-1);
    localparam lg2_row_bufs_cap = clogb2(4 * image_width); // all row bufs capacity
    
    // DDR to BUF decoder
    reg [lg2_mem_depth-1:0] pixel_counter; // write: count num pixels read in a row
    reg [lg2_row_bufs-1:0] cur_row_buf_wr; // which row buffer to write to (4rows=>2bits: 0,1,2,3)
    reg [`num_row_buffers-1:0] cur_valid_row_buf_wr; // write: cur valid row buf, all others invalid
    
    // BUF to CONV multiplexers
    wire [kernel_width*pixel_width-1:0] rbuf0_out; // output of row buffers
    wire [kernel_width*pixel_width-1:0] rbuf1_out;
    wire [kernel_width*pixel_width-1:0] rbuf2_out;
    wire [kernel_width*pixel_width-1:0] rbuf3_out;
    reg [lg2_row_bufs-1:0] cur_row_buf_rd; // which row buffer to read from
    reg [`num_row_buffers-1:0] cur_valid_row_buf_rd; // read: cur valid row buf, all others invalid
    reg [lg2_mem_depth-1:0] buf_rd_counter; // read: count num pixels read in a row
    
    // state machine to decide when to read from line buffers
    reg read_row_buf; // determine whether to read row buffers
    reg state; // current state of state machine; 2 states -> 1 bit
    integer three_rows_size = 3 * image_width;
    reg [lg2_row_bufs_cap-1:0] total_pixels_so_far; // how much valid data is there in all row buffers
    localparam IDLE = 'd0;
    localparam READ = 'd1;
    
    // output is valid when we can read from the row buffers
    // read_row_buf is asserted when 3 valid rows are available
    assign o_pixels_valid = read_row_buf;
    
    // total_pixels_so_far logic
    // increment when valid data comes to this module
    // decrement when reading from row buffers
    always @(posedge i_clk) begin
        if (i_rst) total_pixels_so_far <= 'd0;
        else begin
            if (i_pixel_valid & ~read_row_buf) total_pixels_so_far <= total_pixels_so_far + 'd1;
            else if (~i_pixel_valid & read_row_buf) total_pixels_so_far <= total_pixels_so_far - 'd1; 
        end
    end
    
    // BUF to CONV FSM
    always @(posedge i_clk) begin
        if (i_rst) begin
            state <= IDLE;
            read_row_buf <= 1'b0;
            o_interrupt <= 1'b0;
        end
        else begin
            state <= IDLE;
            read_row_buf <= 1'b0;
            o_interrupt <= 1'b0;
            case(state)
                IDLE: begin
                    o_interrupt <= 1'b0;
                    // once we have 3 valid rows, can start reading out of row buffers
                    if(total_pixels_so_far >= three_rows_size) begin
                        read_row_buf <= 1'b1;
                        state <= READ;
                    end
                end
                READ: begin
                    if (buf_rd_counter == image_width - 1) begin
                        state <= IDLE;
                        read_row_buf <= 1'b0;
                        // edge-triggered interrupt
                        // o_interrupt is asserted when there is a free row buffer
                        // there is a free row buffer when we finish reading a row
                        o_interrupt <= 1'b1;
                    end
                end
            endcase
        end
    end
    
    // pixel_counter logic
    always @(posedge i_clk) begin
        if (i_rst) pixel_counter <= 'd0;
        else begin
            if (i_pixel_valid) pixel_counter <= pixel_counter + 'd1;
        end
    end
    
    // cur_row_buf_wr logic: move to next line buf when cur is full
    always @(posedge i_clk) begin
        if (i_rst) cur_row_buf_wr <= 'd0;
        else begin
            // reached end of cur row & new valid data is available: should goto next row
            if ((pixel_counter == image_width - 1) & i_pixel_valid) begin
                cur_row_buf_wr <= cur_row_buf_wr + 'd1;
            end
        end
    end
    
    // activate current row buffer based on cur_row_buf_wr counter
    // deactivate all other row buffers
    always @(*) begin
        cur_valid_row_buf_wr = 'd0;
        cur_valid_row_buf_wr[cur_row_buf_wr] = i_pixel_valid;
    end
    
    // buf_rd_counter logic
    always @(posedge i_clk) begin
        if (i_rst) buf_rd_counter <= 'd0;
        else begin
            if (read_row_buf) buf_rd_counter <= buf_rd_counter + 'd1;
        end
    end
    
    // cur_row_buf_rd logic
    always @(posedge i_clk) begin
        if (i_rst) cur_row_buf_rd <= 'd0;
        else begin
            // reached end of cur row & new valid data is available: should goto next row
            if ((buf_rd_counter == image_width - 1) & read_row_buf) begin
                cur_row_buf_rd <= cur_row_buf_rd + 'd1;
            end
        end
    end
    
    // BUF to CONV multiplexers
    // determine which 3 rows to read from based on cur_row_buf_rd counter
    // wraps around to row 0 based on cur_row_buf_rd counter
    always @(*) begin
        case(cur_row_buf_rd)
            2'd0: o_pixels = {rbuf2_out, rbuf1_out, rbuf0_out};
            2'd1: o_pixels = {rbuf3_out, rbuf2_out, rbuf1_out};
            2'd2: o_pixels = {rbuf0_out, rbuf3_out, rbuf2_out};
            2'd3: o_pixels = {rbuf1_out, rbuf0_out, rbuf3_out};
        endcase
    end
    
    // control signals for which 3 rows to read from based on cur_row_buf_rd counter
    // combinational since output data (o_pixels) is determined combinationally
    always @(*) begin
        case(cur_row_buf_rd)
            2'd0: begin
                cur_valid_row_buf_rd[0] = read_row_buf;
                cur_valid_row_buf_rd[1] = read_row_buf;
                cur_valid_row_buf_rd[2] = read_row_buf;
                cur_valid_row_buf_rd[3] = 1'b0;
            end
            2'd1: begin
                cur_valid_row_buf_rd[0] = 1'b0;
                cur_valid_row_buf_rd[1] = read_row_buf;
                cur_valid_row_buf_rd[2] = read_row_buf;
                cur_valid_row_buf_rd[3] = read_row_buf;
            end
            2'd2: begin
                cur_valid_row_buf_rd[0] = read_row_buf;
                cur_valid_row_buf_rd[1] = 1'b0;
                cur_valid_row_buf_rd[2] = read_row_buf;
                cur_valid_row_buf_rd[3] = read_row_buf;
            end
            2'd3: begin
                cur_valid_row_buf_rd[0] = read_row_buf;
                cur_valid_row_buf_rd[1] = read_row_buf;
                cur_valid_row_buf_rd[2] = 1'b0;
                cur_valid_row_buf_rd[3] = read_row_buf;
            end
        endcase
    end
    
    
    // instantiate 4 row buffers
    row_buffer # (
        .pixel_width(pixel_width),
        .kernel_width(kernel_width),
        .image_width(image_width)
    ) rbuf0 (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_data(i_pixel),
        .i_data_valid(cur_valid_row_buf_wr[0]),
        .o_data(rbuf0_out),
        .i_rd_data(cur_valid_row_buf_rd[0])
    );
    
    row_buffer # (
        .pixel_width(pixel_width),
        .kernel_width(kernel_width),
        .image_width(image_width)
    ) rbuf1 (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_data(i_pixel),
        .i_data_valid(cur_valid_row_buf_wr[1]),
        .o_data(rbuf1_out),
        .i_rd_data(cur_valid_row_buf_rd[1])
    );
    
    row_buffer # (
        .pixel_width(pixel_width),
        .kernel_width(kernel_width),
        .image_width(image_width)
    ) rbuf2 (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_data(i_pixel),
        .i_data_valid(cur_valid_row_buf_wr[2]),
        .o_data(rbuf2_out),
        .i_rd_data(cur_valid_row_buf_rd[2])
    );
    
    row_buffer # (
        .pixel_width(pixel_width),
        .kernel_width(kernel_width),
        .image_width(image_width)
    ) rbuf3 (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .i_data(i_pixel),
        .i_data_valid(cur_valid_row_buf_wr[3]),
        .o_data(rbuf3_out),
        .i_rd_data(cur_valid_row_buf_rd[3])
    );
    
endmodule
