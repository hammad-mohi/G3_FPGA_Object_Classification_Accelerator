`timescale 1ns / 1ps

module mux_logic # (
    parameter sel_width=6)
(
    input                                                 i_clk,
    input                                                 i_rst, 
    input                                                 i_data_valid,
    output     [sel_width-1:0]                                           o_sel
);

    reg [sel_width-1:0] counter;
    assign o_sel = counter;
    always @(posedge i_clk) begin 
        if(i_rst) begin
            counter <= 'd0;
        end 
        else if(i_data_valid) begin
            counter <= counter + 'd1;
        end
        else begin
            counter <= counter;
        end
    end

endmodule
