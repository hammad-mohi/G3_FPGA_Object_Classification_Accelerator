`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: inter_ram
// Description: ram between different blocks
//////////////////////////////////////////////////////////////////////////////////

module inter_ram_to_max # (
    parameter data_width=8, //8 bit data
    parameter row_width=30, // dimension of the ram block, i.e. 30x30
    parameter counter_width=5,  //count up to 31
    parameter kernel_width=2
)
(
    input                                 i_clk,
    input                                 i_rst,
    input  [data_width-1:0]              i_data,
    input                                 i_data_valid,
    output reg                            o_data_valid,
    output reg  [data_width*(kernel_width**2)-1:0]  o_data
);


    reg [counter_width-1:0] input_counter;
    reg [counter_width-1:0] row_counter;
    reg [counter_width-1:0] output_counter;
    reg [data_width-1:0] row0 [row_width-1:0];
    reg [data_width-1:0] row1 [row_width-1:0];
    reg [data_width-1:0] row2 [row_width-1:0];
    //reg [data_width-1:0] row3 [row_width-1:0];
    reg row0_valid;
    reg row1_valid;
    reg row2_valid;
    //reg row3_valid;

    wire row_ready;
    wire compute_done;
    wire output_done;
    wire rows_valid;
    wire ignore_last_line;
    localparam out_row_width = row_width - (row_width%2);

    integer i;
      always @(posedge i_clk) begin
        if (i_rst) begin
            for (i=0; i<row_width; i=i+1) begin
                row0[i] <= 0;
            end
        end
        else if(i_data_valid & row_ready) row0[0] <= i_data;
        else if(i_data_valid) row0[input_counter] <= i_data;
    end

    // counter logic
    always @(posedge i_clk) begin
        if (i_rst) input_counter <= 'd0;
        else if(~i_data_valid & row_ready) input_counter <= 'd0;
        else if (i_data_valid & row_ready) input_counter <= 'd1;
        else if (i_data_valid & ~row_ready) input_counter <= input_counter + 'd1;
        else input_counter = input_counter;
    end

    // row ready logic
    assign row_ready = (input_counter == row_width); 
    assign ignore_last_line = (output_counter == row_width) & (row_width%2);
    // row counter logic
    always @(posedge i_clk) begin
        if (i_rst) row_counter <= 'd0;
        else if(~row_ready & compute_done) row_counter <= 'd0;
        else if (row_ready & compute_done) row_counter <= 'd1;
        else if (row_ready & ~compute_done) row_counter <= row_counter + 'd1;
        else row_counter = row_counter;
    end

    // compute_done logic
    assign compute_done = (row_counter == row_width);

    //row valid logic

    always @(posedge i_clk) begin
        if(i_rst) row0_valid = 'd1;
        else if(compute_done) row0_valid = 'd0;
        else if (input_counter == row_width-1) row0_valid <= 'd1;
        else row0_valid <= row0_valid;
    end

    always @(posedge i_clk) begin
        if (i_rst) begin 
            row1_valid <= 'd0;
            row2_valid <= 'd0;
        end
        else if(output_done) begin 
            row1_valid <= 'd0;
            row2_valid <= 'd0;
        end
        else if(row_counter > out_row_width) begin
            row1_valid <= 'd0;
            row2_valid <= 'd0;
        end
        else if(row_ready)begin 
            row1_valid <= row0_valid;
            row2_valid <= row1_valid;
        end
        else begin
            row1_valid <= row1_valid;
            row2_valid <= row2_valid;
        end
    end


    // shift buffers logic
    always @(posedge i_clk) begin
        if (i_rst) begin 
            for (i=0; i<row_width; i=i+1) begin
                row1[i] <= 'd0;
                row2[i] <= 'd0;
            end
        end
        else if(compute_done) begin
            for (i=0; i<row_width; i=i+1) begin
                row1[i] <= row1[i];
                row2[i] <= row2[i];
            end

        end

        else if(row_ready) begin 
            for (i=0; i<row_width; i=i+1) begin
                row1[i] <= row0[i];
                row2[i] <= row1[i];
            end

        end
    end

    // output counter logic
    always @(posedge i_clk) begin
        if (i_rst) output_counter <= 'd0;
        else if(rows_valid & output_done) output_counter <= 'd0;
        else if(ignore_last_line) output_counter<='d0;
        else if (rows_valid & ~output_done) output_counter <= output_counter + 'd2;
        else output_counter = output_counter;
    end


    assign output_done = (output_counter == (out_row_width));

    // rows_valid logic
    assign rows_valid = row1_valid & row2_valid;

    // output valid logic
    always @(posedge i_clk) begin
        if(i_rst) o_data_valid <= 'd0;
        else o_data_valid <= (rows_valid & ~output_done);
    end

    // output data logic 
    always @(posedge i_clk) begin
        if(i_rst) o_data <= 'd0;
        else if(rows_valid & ~output_done)begin
            o_data <= {row1[output_counter+1],row1[output_counter],
                      row2[output_counter+1],row2[output_counter]};
        end
        else
           o_data <= 'd0;
    end
endmodule

    
    