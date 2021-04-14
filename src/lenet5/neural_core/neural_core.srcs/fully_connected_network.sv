
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: fully_connected_network
// Description: Fully connected part of the CNN
//                # Hidden Layers: 3
//                Layer 1 activation function: ReLU
//                Layer 2 activation function: ReLU
//                Ouput Layer activation function: Softmax
//                Arch: 512 (inputs) -> 120 (relu) -> 84 (relu) > 43 (softmax)
//////////////////////////////////////////////////////////////////////////////////

`include "nc_defines.vh"

module fully_connected_network (
    input                                         clk,
    input                                         rst,
    input  [`fc_num_inputs*`input_data_width-1:0] i_data,
    input                                         i_data_valid,
    output [`input_data_width-1:0]                o_data,
    output                                        o_data_valid,
    output [31:0]                                 o_max_neuron_idx
);
    
    // states for pipeline FSMs between each layer
    localparam IDLE = 'd0;
    localparam SHIFT = 'd1;
    wire [`fc_hidden_l1_nn-1:0]                   l1_out_flattened_valid; ////////////////////////////////////////////
    
    /************************* Input Layer **************************/
    reg  [`fc_num_inputs*`input_data_width-1:0] il_out_shift_reg;
    reg  [`input_data_width-1:0]                il_out; // shift to next layer
    reg                                         il_out_valid;
    
    // input layer -> layer1 controller
    reg il_state = 'd0;
    int il_counter = 0;
    always @(posedge clk) begin
        if (rst) begin
            il_state <= IDLE;
            il_counter <= 0;
            il_out_valid <= 1'b0;
			il_out_shift_reg <= 'd0;
			il_out <= 'd0;
        end
        else begin
            case (il_state)
                IDLE: begin
                    il_counter <= 0;
                    il_out_valid <= 1'b0;
                    if (i_data_valid & ~l1_out_flattened_valid[0]) begin
                        il_out_shift_reg <= i_data;
                        il_state <= SHIFT;
                    end
                end
                SHIFT: begin
                    il_out <= il_out_shift_reg[`input_data_width-1:0];
                    il_out_shift_reg <= il_out_shift_reg >> `input_data_width;
                    il_counter <= il_counter + 1;
                    il_out_valid <= 1;
                    if (il_counter == `fc_num_inputs) begin
                        il_state <= IDLE;
                        il_out_valid <= 1'b0;
                    end
                end
            endcase
        end
    end

    /************************** FC Layer 1 **************************/
    wire [`fc_hidden_l1_nn*`input_data_width-1:0] l1_out_flattened;
    //wire [`fc_hidden_l1_nn-1:0]                   l1_out_flattened_valid;
    reg  [`fc_hidden_l1_nn*`input_data_width-1:0] l1_out_shift_reg;
    reg  [`input_data_width-1:0]                  l1_out; // shifted out to next layer
    reg                                           l1_out_valid;
    
    fc_layer1 #(
        .num_neurons          (`fc_hidden_l1_nn),
        .num_weights          (`l1_num_weights),
        .data_width           (`input_data_width),
        .layer_idx            (1),
        .weight_int_width_fp  (`fixed_pt_int_width),
        .activation_type      (`l1_activation_type)
    ) fcl1 (
        .clk                  (clk),
        .rst                  (rst),
        .in                   (il_out),
        .in_valid             (il_out_valid),
        .out                  (l1_out_flattened),
        .out_valid            (l1_out_flattened_valid)
    );
    
    // layer1 -> layer2 controller
    reg l1_state = 'd0;
    int l1_counter = 0;
    always @(posedge clk) begin
        if (rst) begin
            l1_state <= IDLE;
            l1_counter <= 0;
            l1_out_valid <= 1'b0;
			l1_out_shift_reg <= 'd0;
			l1_out <= 'd0;
        end
        else begin
            case (l1_state)
                IDLE: begin
                    l1_counter <= 0;
                    l1_out_valid <= 1'b0;
                    if ( & l1_out_flattened_valid) begin
                        l1_out_shift_reg <= l1_out_flattened;
                        l1_state <= SHIFT;
                    end
                end
                SHIFT: begin
                    l1_out <= l1_out_shift_reg[`input_data_width-1:0];
                    l1_out_shift_reg <= l1_out_shift_reg >> `input_data_width;
                    l1_counter <= l1_counter + 1;
                    l1_out_valid <= 1;
                    if (l1_counter == `fc_hidden_l1_nn) begin
                        l1_state <= IDLE;
                        l1_out_valid <= 1'b0;
                    end
                end
            endcase
        end
    end
    
    /************************** FC Layer 2 **************************/
    wire [`fc_hidden_l2_nn*`input_data_width-1:0] l2_out_flattened;
    wire [`fc_hidden_l2_nn-1:0]                   l2_out_flattened_valid;
    reg  [`fc_hidden_l2_nn*`input_data_width-1:0] l2_out_shift_reg;
    reg  [`input_data_width-1:0]                  l2_out; // shifted out to next layer
    reg                                           l2_out_valid;
    
    fc_layer2 #(
        .num_neurons          (`fc_hidden_l2_nn),
        .num_weights          (`l2_num_weights),
        .data_width           (`input_data_width),
        .layer_idx            (2),
        .weight_int_width_fp  (`fixed_pt_int_width),
        .activation_type      (`l2_activation_type)
    ) fcl2 (
        .clk                  (clk),
        .rst                  (rst),
        .in                   (l1_out),
        .in_valid             (l1_out_valid),
        .out                  (l2_out_flattened),
        .out_valid            (l2_out_flattened_valid)
    );
    
    // layer2 -> output layer controller
    reg l2_state = 'd0;
    int l2_counter = 0;
    always @(posedge clk) begin
        if (rst) begin
            l2_state <= IDLE;
            l2_counter <= 0;
            l2_out_valid <= 1'b0;
			l2_out <= 'd0;
			l2_out_shift_reg <= 'd0;
        end
        else begin
            case (l2_state)
                IDLE: begin
                    l2_counter <= 0;
                    l2_out_valid <= 1'b0;
                    if ( & l2_out_flattened_valid) begin
                        l2_out_shift_reg <= l2_out_flattened;
                        l2_state <= SHIFT;
                    end
                end
                SHIFT: begin
                    l2_out <= l2_out_shift_reg[`input_data_width-1:0];
                    l2_out_shift_reg <= l2_out_shift_reg >> `input_data_width;
                    l2_counter <= l2_counter + 1;
                    l2_out_valid <= 1;
                    if (l2_counter == `fc_hidden_l2_nn) begin
                        l2_state <= IDLE;
                        l2_out_valid <= 1'b0;
                    end
                end
            endcase
        end
    end
    
    /************************* Output Layer *************************/
    wire [`fc_out_layer_nn*`input_data_width-1:0] ol_out_flattened;
    wire [`fc_out_layer_nn-1:0]                   ol_out_flattened_valid;
//    reg  [`fc_out_layer_nn*`input_data_width-1:0] ol_out_shift_reg = 'd0;
//    reg  [`input_data_width-1:0]                  ol_out = 'd0; // shifted out to next layer
//    reg                                           ol_out_valid = 'd0;
    
    fc_output_layer #(
        .num_neurons          (`fc_out_layer_nn),
        .num_weights          (`out_layer_num_weights),
        .data_width           (`input_data_width),
        .layer_idx            (3),
        .weight_int_width_fp  (`fixed_pt_int_width),
        .activation_type      (`out_layer_activation_type)
    ) fc_outl (
        .clk                  (clk),
        .rst                  (rst),
        .in                   (l2_out),
        .in_valid             (l2_out_valid),
        .out                  (ol_out_flattened),
        .out_valid            (ol_out_flattened_valid)
    );
    
    /*************************** Softmax ****************************/
    softmax #(
        .num_inputs           (`fc_out_layer_nn),
        .data_width           (`input_data_width)
    ) softmax0 (
        .clk                  (clk),
        .rst                  (rst),
        .i_data               (ol_out_flattened), // output of last layer
        .i_data_valid         (&ol_out_flattened_valid),
        .o_max                (o_data),
        .o_max_valid          (o_data_valid),
        .max_neuron_idx       (o_max_neuron_idx)
    );

endmodule
