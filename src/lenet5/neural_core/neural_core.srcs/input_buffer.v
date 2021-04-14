`timescale 1ns / 1ps

module input_buffer # (
    parameter input_width=8,
    parameter buffer_depth=16,
    parameter count_width=5)
(
    input                                                 i_clk,
    input                                                 i_rst,
    input   [input_width*9-1:0]                           i_data, 
    input                                                 i_data_valid,
    output       [input_width*9-1:0]                      o_result,
    output                                                o_result_valid
);

    localparam count_max = 2**count_width;

    integer i;

    reg [input_width*9-1:0] data_buffer [buffer_depth-1:0];
    reg [buffer_depth-1:0] valid_buffer;
    wire push;
    reg [count_width-1:0] counter;
    wire count_done;

    assign count_done = (counter == (count_max-1));
    assign push = (i_data_valid | count_done);
    assign o_result_valid = valid_buffer[buffer_depth-1];
    assign o_result = data_buffer[buffer_depth-1];

    always @(posedge i_clk) begin
        if(i_rst) begin
            for (i=0;i<buffer_depth;i=i+1) begin
                data_buffer[i] <= 'd0;
                valid_buffer[i] <= 'd0;
            end
        end

        else if(push) begin
            data_buffer[0] <= i_data;
            valid_buffer[0] <= i_data_valid;
            for (i=0;i<buffer_depth-1;i=i+1) begin
                data_buffer[i+1] <= data_buffer[i];
                valid_buffer[i+1] <= valid_buffer[i];
            end
        end
        else begin
            for (i=0;i<buffer_depth;i=i+1) begin
                data_buffer[i] <= data_buffer[i];
                valid_buffer[i] <= valid_buffer[i];
            end
        end
    end

    always @(posedge i_clk) begin 
        if(i_rst) begin
            counter <= 'd0;
        end 
        else if(valid_buffer[buffer_depth-1]) begin
            counter <= counter + 'd1;
        end
        else begin
            counter <= counter;
        end
    end

endmodule
