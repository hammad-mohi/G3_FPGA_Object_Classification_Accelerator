
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: fc_output_layer
// Description: Create a fully connected layer by instantiating neurons
//                Ouput Layer:
//                  activation:           Softmax
//                  # neurons:            43
//                  # weights per neuron: 84
//////////////////////////////////////////////////////////////////////////////////

`include "nc_defines.vh"

module fc_output_layer #(
    parameter num_neurons=`fc_out_layer_nn,
    parameter num_weights=`out_layer_num_weights,
    parameter data_width=`input_data_width,
    parameter layer_idx=3,
    parameter weight_int_width_fp=`fixed_pt_int_width,
    parameter activation_type=`out_layer_activation_type
)
(
    input                               clk,
    input                               rst,
    input  [data_width-1:0]             in,
    input                               in_valid,
    output [num_neurons*data_width-1:0] out,
    output [num_neurons-1:0]            out_valid // array of valid signals from each neuron
);
    
    //reg [data_width-1:0] i_weights [0:num_weights-1];
    reg [data_width*num_neurons*num_weights-1:0] i_weights;
    wire i_weight_valid;
    reg [2*data_width-1:0] biases [0:`out_layer_num_biases-1];

    //int wfile_basename = "weights_output_layer_n";

    // read weights & biases from files for this layer
    initial begin
//        int i;
//        for (i=0; i<num_neurons*num_weights;i++) begin
//            i_weights[i*data_width+:data_width] <= 'd1;
//        end
        //$readmemh(`output_layer_weight_file, i_weights);
        $readmemh(`output_layer_bias_file, biases);
    end
    
    // always valid when reading from 1 weight file, 0 otherwise
    `ifdef use_per_neuron_wfiles
        assign i_weight_valid = 1'b0;
    `else
        assign i_weight_valid = in_valid;
    `endif

//    genvar i;
//    generate
//        for (i = 0; i < num_neurons; i++) begin
//            neuron #(
//                .layer_idx            (layer_idx),
//                .neuron_idx           (i),
//                .num_weights          (num_weights),
//                .data_width           (data_width),
//                .weight_int_width_fp  (weight_int_width_fp),
//                .activation_type      (activation_type),
//                //.wfile                ($sformat(`output_layer_weight_bias_dir,wfile_basename,i,".mem"))
//                .wfile                ("./weight_bias/output_layer/weights_output_layer_n0.mem")
//            ) neuron (
//                .clk                  (clk),
//                .rst                  (rst),
//                .in                   (in),
//                .in_valid             (in_valid),
//                .i_weight             (i_weights[i*num_weights +: num_weights*data_width]),
//                .i_weight_valid       (i_weight_valid),
//                .bias                 (biases[i]),
//                .out                  (out[i * data_width +: data_width]),
//                .out_valid            (out_valid[i])
//            );
//        end
//    endgenerate

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(0),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`output_layer_weight_bias_dir,"weights_output_layer_n0.mem"})
    ) neuron_0 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[0*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[0]),
        .out(out[0*data_width +: data_width]),
        .out_valid(out_valid[0])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(1),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`output_layer_weight_bias_dir,"weights_output_layer_n1.mem"})
    ) neuron_1 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[1*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[1]),
        .out(out[1*data_width +: data_width]),
        .out_valid(out_valid[1])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(2),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`output_layer_weight_bias_dir,"weights_output_layer_n2.mem"})
    ) neuron_2 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[2*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[2]),
        .out(out[2*data_width +: data_width]),
        .out_valid(out_valid[2])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(3),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`output_layer_weight_bias_dir,"weights_output_layer_n3.mem"})
    ) neuron_3 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[3*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[3]),
        .out(out[3*data_width +: data_width]),
        .out_valid(out_valid[3])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(4),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`output_layer_weight_bias_dir,"weights_output_layer_n4.mem"})
    ) neuron_4 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[4*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[4]),
        .out(out[4*data_width +: data_width]),
        .out_valid(out_valid[4])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(5),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`output_layer_weight_bias_dir,"weights_output_layer_n5.mem"})
    ) neuron_5 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[5*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[5]),
        .out(out[5*data_width +: data_width]),
        .out_valid(out_valid[5])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(6),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`output_layer_weight_bias_dir,"weights_output_layer_n6.mem"})
    ) neuron_6 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[6*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[6]),
        .out(out[6*data_width +: data_width]),
        .out_valid(out_valid[6])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(7),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`output_layer_weight_bias_dir,"weights_output_layer_n7.mem"})
    ) neuron_7 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[7*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[7]),
        .out(out[7*data_width +: data_width]),
        .out_valid(out_valid[7])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(8),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`output_layer_weight_bias_dir,"weights_output_layer_n8.mem"})
    ) neuron_8 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[8*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[8]),
        .out(out[8*data_width +: data_width]),
        .out_valid(out_valid[8])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(9),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`output_layer_weight_bias_dir,"weights_output_layer_n9.mem"})
    ) neuron_9 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[9*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[9]),
        .out(out[9*data_width +: data_width]),
        .out_valid(out_valid[9])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(10),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`output_layer_weight_bias_dir,"weights_output_layer_n10.mem"})
    ) neuron_10 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[10*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[10]),
        .out(out[10*data_width +: data_width]),
        .out_valid(out_valid[10])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(11),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`output_layer_weight_bias_dir,"weights_output_layer_n11.mem"})
    ) neuron_11 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[11*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[11]),
        .out(out[11*data_width +: data_width]),
        .out_valid(out_valid[11])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(12),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`output_layer_weight_bias_dir,"weights_output_layer_n12.mem"})
    ) neuron_12 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[12*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[12]),
        .out(out[12*data_width +: data_width]),
        .out_valid(out_valid[12])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(13),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`output_layer_weight_bias_dir,"weights_output_layer_n13.mem"})
    ) neuron_13 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[13*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[13]),
        .out(out[13*data_width +: data_width]),
        .out_valid(out_valid[13])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(14),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`output_layer_weight_bias_dir,"weights_output_layer_n14.mem"})
    ) neuron_14 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[14*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[14]),
        .out(out[14*data_width +: data_width]),
        .out_valid(out_valid[14])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(15),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`output_layer_weight_bias_dir,"weights_output_layer_n15.mem"})
    ) neuron_15 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[15*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[15]),
        .out(out[15*data_width +: data_width]),
        .out_valid(out_valid[15])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(16),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`output_layer_weight_bias_dir,"weights_output_layer_n16.mem"})
    ) neuron_16 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[16*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[16]),
        .out(out[16*data_width +: data_width]),
        .out_valid(out_valid[16])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(17),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`output_layer_weight_bias_dir,"weights_output_layer_n17.mem"})
    ) neuron_17 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[17*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[17]),
        .out(out[17*data_width +: data_width]),
        .out_valid(out_valid[17])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(18),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`output_layer_weight_bias_dir,"weights_output_layer_n18.mem"})
    ) neuron_18 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[18*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[18]),
        .out(out[18*data_width +: data_width]),
        .out_valid(out_valid[18])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(19),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`output_layer_weight_bias_dir,"weights_output_layer_n19.mem"})
    ) neuron_19 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[19*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[19]),
        .out(out[19*data_width +: data_width]),
        .out_valid(out_valid[19])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(20),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`output_layer_weight_bias_dir,"weights_output_layer_n20.mem"})
    ) neuron_20 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[20*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[20]),
        .out(out[20*data_width +: data_width]),
        .out_valid(out_valid[20])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(21),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`output_layer_weight_bias_dir,"weights_output_layer_n21.mem"})
    ) neuron_21 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[21*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[21]),
        .out(out[21*data_width +: data_width]),
        .out_valid(out_valid[21])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(22),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`output_layer_weight_bias_dir,"weights_output_layer_n22.mem"})
    ) neuron_22 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[22*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[22]),
        .out(out[22*data_width +: data_width]),
        .out_valid(out_valid[22])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(23),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`output_layer_weight_bias_dir,"weights_output_layer_n23.mem"})
    ) neuron_23 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[23*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[23]),
        .out(out[23*data_width +: data_width]),
        .out_valid(out_valid[23])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(24),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`output_layer_weight_bias_dir,"weights_output_layer_n24.mem"})
    ) neuron_24 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[24*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[24]),
        .out(out[24*data_width +: data_width]),
        .out_valid(out_valid[24])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(25),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`output_layer_weight_bias_dir,"weights_output_layer_n25.mem"})
    ) neuron_25 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[25*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[25]),
        .out(out[25*data_width +: data_width]),
        .out_valid(out_valid[25])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(26),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`output_layer_weight_bias_dir,"weights_output_layer_n26.mem"})
    ) neuron_26 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[26*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[26]),
        .out(out[26*data_width +: data_width]),
        .out_valid(out_valid[26])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(27),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`output_layer_weight_bias_dir,"weights_output_layer_n27.mem"})
    ) neuron_27 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[27*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[27]),
        .out(out[27*data_width +: data_width]),
        .out_valid(out_valid[27])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(28),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`output_layer_weight_bias_dir,"weights_output_layer_n28.mem"})
    ) neuron_28 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[28*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[28]),
        .out(out[28*data_width +: data_width]),
        .out_valid(out_valid[28])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(29),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`output_layer_weight_bias_dir,"weights_output_layer_n29.mem"})
    ) neuron_29 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[29*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[29]),
        .out(out[29*data_width +: data_width]),
        .out_valid(out_valid[29])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(30),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`output_layer_weight_bias_dir,"weights_output_layer_n30.mem"})
    ) neuron_30 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[30*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[30]),
        .out(out[30*data_width +: data_width]),
        .out_valid(out_valid[30])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(31),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`output_layer_weight_bias_dir,"weights_output_layer_n31.mem"})
    ) neuron_31 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[31*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[31]),
        .out(out[31*data_width +: data_width]),
        .out_valid(out_valid[31])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(32),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`output_layer_weight_bias_dir,"weights_output_layer_n32.mem"})
    ) neuron_32 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[32*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[32]),
        .out(out[32*data_width +: data_width]),
        .out_valid(out_valid[32])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(33),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`output_layer_weight_bias_dir,"weights_output_layer_n33.mem"})
    ) neuron_33 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[33*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[33]),
        .out(out[33*data_width +: data_width]),
        .out_valid(out_valid[33])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(34),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`output_layer_weight_bias_dir,"weights_output_layer_n34.mem"})
    ) neuron_34 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[34*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[34]),
        .out(out[34*data_width +: data_width]),
        .out_valid(out_valid[34])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(35),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`output_layer_weight_bias_dir,"weights_output_layer_n35.mem"})
    ) neuron_35 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[35*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[35]),
        .out(out[35*data_width +: data_width]),
        .out_valid(out_valid[35])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(36),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`output_layer_weight_bias_dir,"weights_output_layer_n36.mem"})
    ) neuron_36 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[36*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[36]),
        .out(out[36*data_width +: data_width]),
        .out_valid(out_valid[36])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(37),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`output_layer_weight_bias_dir,"weights_output_layer_n37.mem"})
    ) neuron_37 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[37*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[37]),
        .out(out[37*data_width +: data_width]),
        .out_valid(out_valid[37])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(38),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`output_layer_weight_bias_dir,"weights_output_layer_n38.mem"})
    ) neuron_38 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[38*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[38]),
        .out(out[38*data_width +: data_width]),
        .out_valid(out_valid[38])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(39),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`output_layer_weight_bias_dir,"weights_output_layer_n39.mem"})
    ) neuron_39 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[39*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[39]),
        .out(out[39*data_width +: data_width]),
        .out_valid(out_valid[39])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(40),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`output_layer_weight_bias_dir,"weights_output_layer_n40.mem"})
    ) neuron_40 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[40*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[40]),
        .out(out[40*data_width +: data_width]),
        .out_valid(out_valid[40])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(41),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`output_layer_weight_bias_dir,"weights_output_layer_n41.mem"})
    ) neuron_41 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[41*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[41]),
        .out(out[41*data_width +: data_width]),
        .out_valid(out_valid[41])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(42),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`output_layer_weight_bias_dir,"weights_output_layer_n42.mem"})
    ) neuron_42 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[42*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[42]),
        .out(out[42*data_width +: data_width]),
        .out_valid(out_valid[42])
    );

endmodule
