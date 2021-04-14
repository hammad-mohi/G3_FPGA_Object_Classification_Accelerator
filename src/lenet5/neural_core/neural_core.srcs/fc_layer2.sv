
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: fc_layer2
// Description: Create a fully connected layer by instantiating neurons
//                Layer 2:
//                  activation:           ReLU
//                  # neurons:            84
//                  # weights per neuron: 120
//////////////////////////////////////////////////////////////////////////////////

`include "nc_defines.vh"

module fc_layer2 #(
    parameter num_neurons=`fc_hidden_l2_nn,
    parameter num_weights=`l2_num_weights,
    parameter data_width=`input_data_width,
    parameter layer_idx=2,
    parameter weight_int_width_fp=`fixed_pt_int_width,
    parameter activation_type=`l2_activation_type
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
    reg [2*data_width-1:0] biases [0:`l2_num_biases-1];

    //int wfile_basename = "weights_layer2_n";

    // read weights & biases from files for this layer
    initial begin
//        int i;
//        for (i=0; i<num_neurons*num_weights;i++) begin
//            i_weights[i*data_width+:data_width] <= 'd1;
//        end
        //$readmemh(`l2_weight_file, i_weights);
        $readmemh(`l2_bias_file, biases);
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
//                //.wfile                ($sformat(`l2_weight_bias_dir,wfile_basename,i,".mem"))
//                .wfile                ("./weight_bias/layer2/weights_layer2_n0.mem")
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
        .wfile({`l2_weight_bias_dir,"weights_layer2_n0.mem"})
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
        .wfile({`l2_weight_bias_dir,"weights_layer2_n1.mem"})
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
        .wfile({`l2_weight_bias_dir,"weights_layer2_n2.mem"})
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
        .wfile({`l2_weight_bias_dir,"weights_layer2_n3.mem"})
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
        .wfile({`l2_weight_bias_dir,"weights_layer2_n4.mem"})
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
        .wfile({`l2_weight_bias_dir,"weights_layer2_n5.mem"})
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
        .wfile({`l2_weight_bias_dir,"weights_layer2_n6.mem"})
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
        .wfile({`l2_weight_bias_dir,"weights_layer2_n7.mem"})
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
        .wfile({`l2_weight_bias_dir,"weights_layer2_n8.mem"})
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
        .wfile({`l2_weight_bias_dir,"weights_layer2_n9.mem"})
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
        .wfile({`l2_weight_bias_dir,"weights_layer2_n10.mem"})
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
        .wfile({`l2_weight_bias_dir,"weights_layer2_n11.mem"})
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
        .wfile({`l2_weight_bias_dir,"weights_layer2_n12.mem"})
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
        .wfile({`l2_weight_bias_dir,"weights_layer2_n13.mem"})
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
        .wfile({`l2_weight_bias_dir,"weights_layer2_n14.mem"})
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
        .wfile({`l2_weight_bias_dir,"weights_layer2_n15.mem"})
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
        .wfile({`l2_weight_bias_dir,"weights_layer2_n16.mem"})
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
        .wfile({`l2_weight_bias_dir,"weights_layer2_n17.mem"})
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
        .wfile({`l2_weight_bias_dir,"weights_layer2_n18.mem"})
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
        .wfile({`l2_weight_bias_dir,"weights_layer2_n19.mem"})
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
        .wfile({`l2_weight_bias_dir,"weights_layer2_n20.mem"})
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
        .wfile({`l2_weight_bias_dir,"weights_layer2_n21.mem"})
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
        .wfile({`l2_weight_bias_dir,"weights_layer2_n22.mem"})
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
        .wfile({`l2_weight_bias_dir,"weights_layer2_n23.mem"})
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
        .wfile({`l2_weight_bias_dir,"weights_layer2_n24.mem"})
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
        .wfile({`l2_weight_bias_dir,"weights_layer2_n25.mem"})
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
        .wfile({`l2_weight_bias_dir,"weights_layer2_n26.mem"})
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
        .wfile({`l2_weight_bias_dir,"weights_layer2_n27.mem"})
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
        .wfile({`l2_weight_bias_dir,"weights_layer2_n28.mem"})
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
        .wfile({`l2_weight_bias_dir,"weights_layer2_n29.mem"})
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
        .wfile({`l2_weight_bias_dir,"weights_layer2_n30.mem"})
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
        .wfile({`l2_weight_bias_dir,"weights_layer2_n31.mem"})
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
        .wfile({`l2_weight_bias_dir,"weights_layer2_n32.mem"})
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
        .wfile({`l2_weight_bias_dir,"weights_layer2_n33.mem"})
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
        .wfile({`l2_weight_bias_dir,"weights_layer2_n34.mem"})
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
        .wfile({`l2_weight_bias_dir,"weights_layer2_n35.mem"})
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
        .wfile({`l2_weight_bias_dir,"weights_layer2_n36.mem"})
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
        .wfile({`l2_weight_bias_dir,"weights_layer2_n37.mem"})
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
        .wfile({`l2_weight_bias_dir,"weights_layer2_n38.mem"})
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
        .wfile({`l2_weight_bias_dir,"weights_layer2_n39.mem"})
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
        .wfile({`l2_weight_bias_dir,"weights_layer2_n40.mem"})
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
        .wfile({`l2_weight_bias_dir,"weights_layer2_n41.mem"})
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
        .wfile({`l2_weight_bias_dir,"weights_layer2_n42.mem"})
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

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(43),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l2_weight_bias_dir,"weights_layer2_n43.mem"})
    ) neuron_43 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[43*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[43]),
        .out(out[43*data_width +: data_width]),
        .out_valid(out_valid[43])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(44),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l2_weight_bias_dir,"weights_layer2_n44.mem"})
    ) neuron_44 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[44*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[44]),
        .out(out[44*data_width +: data_width]),
        .out_valid(out_valid[44])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(45),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l2_weight_bias_dir,"weights_layer2_n45.mem"})
    ) neuron_45 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[45*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[45]),
        .out(out[45*data_width +: data_width]),
        .out_valid(out_valid[45])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(46),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l2_weight_bias_dir,"weights_layer2_n46.mem"})
    ) neuron_46 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[46*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[46]),
        .out(out[46*data_width +: data_width]),
        .out_valid(out_valid[46])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(47),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l2_weight_bias_dir,"weights_layer2_n47.mem"})
    ) neuron_47 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[47*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[47]),
        .out(out[47*data_width +: data_width]),
        .out_valid(out_valid[47])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(48),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l2_weight_bias_dir,"weights_layer2_n48.mem"})
    ) neuron_48 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[48*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[48]),
        .out(out[48*data_width +: data_width]),
        .out_valid(out_valid[48])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(49),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l2_weight_bias_dir,"weights_layer2_n49.mem"})
    ) neuron_49 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[49*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[49]),
        .out(out[49*data_width +: data_width]),
        .out_valid(out_valid[49])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(50),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l2_weight_bias_dir,"weights_layer2_n50.mem"})
    ) neuron_50 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[50*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[50]),
        .out(out[50*data_width +: data_width]),
        .out_valid(out_valid[50])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(51),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l2_weight_bias_dir,"weights_layer2_n51.mem"})
    ) neuron_51 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[51*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[51]),
        .out(out[51*data_width +: data_width]),
        .out_valid(out_valid[51])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(52),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l2_weight_bias_dir,"weights_layer2_n52.mem"})
    ) neuron_52 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[52*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[52]),
        .out(out[52*data_width +: data_width]),
        .out_valid(out_valid[52])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(53),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l2_weight_bias_dir,"weights_layer2_n53.mem"})
    ) neuron_53 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[53*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[53]),
        .out(out[53*data_width +: data_width]),
        .out_valid(out_valid[53])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(54),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l2_weight_bias_dir,"weights_layer2_n54.mem"})
    ) neuron_54 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[54*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[54]),
        .out(out[54*data_width +: data_width]),
        .out_valid(out_valid[54])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(55),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l2_weight_bias_dir,"weights_layer2_n55.mem"})
    ) neuron_55 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[55*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[55]),
        .out(out[55*data_width +: data_width]),
        .out_valid(out_valid[55])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(56),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l2_weight_bias_dir,"weights_layer2_n56.mem"})
    ) neuron_56 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[56*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[56]),
        .out(out[56*data_width +: data_width]),
        .out_valid(out_valid[56])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(57),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l2_weight_bias_dir,"weights_layer2_n57.mem"})
    ) neuron_57 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[57*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[57]),
        .out(out[57*data_width +: data_width]),
        .out_valid(out_valid[57])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(58),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l2_weight_bias_dir,"weights_layer2_n58.mem"})
    ) neuron_58 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[58*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[58]),
        .out(out[58*data_width +: data_width]),
        .out_valid(out_valid[58])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(59),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l2_weight_bias_dir,"weights_layer2_n59.mem"})
    ) neuron_59 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[59*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[59]),
        .out(out[59*data_width +: data_width]),
        .out_valid(out_valid[59])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(60),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l2_weight_bias_dir,"weights_layer2_n60.mem"})
    ) neuron_60 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[60*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[60]),
        .out(out[60*data_width +: data_width]),
        .out_valid(out_valid[60])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(61),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l2_weight_bias_dir,"weights_layer2_n61.mem"})
    ) neuron_61 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[61*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[61]),
        .out(out[61*data_width +: data_width]),
        .out_valid(out_valid[61])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(62),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l2_weight_bias_dir,"weights_layer2_n62.mem"})
    ) neuron_62 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[62*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[62]),
        .out(out[62*data_width +: data_width]),
        .out_valid(out_valid[62])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(63),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l2_weight_bias_dir,"weights_layer2_n63.mem"})
    ) neuron_63 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[63*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[63]),
        .out(out[63*data_width +: data_width]),
        .out_valid(out_valid[63])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(64),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l2_weight_bias_dir,"weights_layer2_n64.mem"})
    ) neuron_64 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[64*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[64]),
        .out(out[64*data_width +: data_width]),
        .out_valid(out_valid[64])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(65),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l2_weight_bias_dir,"weights_layer2_n65.mem"})
    ) neuron_65 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[65*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[65]),
        .out(out[65*data_width +: data_width]),
        .out_valid(out_valid[65])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(66),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l2_weight_bias_dir,"weights_layer2_n66.mem"})
    ) neuron_66 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[66*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[66]),
        .out(out[66*data_width +: data_width]),
        .out_valid(out_valid[66])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(67),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l2_weight_bias_dir,"weights_layer2_n67.mem"})
    ) neuron_67 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[67*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[67]),
        .out(out[67*data_width +: data_width]),
        .out_valid(out_valid[67])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(68),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l2_weight_bias_dir,"weights_layer2_n68.mem"})
    ) neuron_68 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[68*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[68]),
        .out(out[68*data_width +: data_width]),
        .out_valid(out_valid[68])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(69),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l2_weight_bias_dir,"weights_layer2_n69.mem"})
    ) neuron_69 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[69*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[69]),
        .out(out[69*data_width +: data_width]),
        .out_valid(out_valid[69])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(70),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l2_weight_bias_dir,"weights_layer2_n70.mem"})
    ) neuron_70 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[70*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[70]),
        .out(out[70*data_width +: data_width]),
        .out_valid(out_valid[70])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(71),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l2_weight_bias_dir,"weights_layer2_n71.mem"})
    ) neuron_71 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[71*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[71]),
        .out(out[71*data_width +: data_width]),
        .out_valid(out_valid[71])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(72),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l2_weight_bias_dir,"weights_layer2_n72.mem"})
    ) neuron_72 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[72*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[72]),
        .out(out[72*data_width +: data_width]),
        .out_valid(out_valid[72])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(73),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l2_weight_bias_dir,"weights_layer2_n73.mem"})
    ) neuron_73 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[73*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[73]),
        .out(out[73*data_width +: data_width]),
        .out_valid(out_valid[73])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(74),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l2_weight_bias_dir,"weights_layer2_n74.mem"})
    ) neuron_74 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[74*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[74]),
        .out(out[74*data_width +: data_width]),
        .out_valid(out_valid[74])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(75),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l2_weight_bias_dir,"weights_layer2_n75.mem"})
    ) neuron_75 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[75*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[75]),
        .out(out[75*data_width +: data_width]),
        .out_valid(out_valid[75])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(76),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l2_weight_bias_dir,"weights_layer2_n76.mem"})
    ) neuron_76 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[76*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[76]),
        .out(out[76*data_width +: data_width]),
        .out_valid(out_valid[76])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(77),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l2_weight_bias_dir,"weights_layer2_n77.mem"})
    ) neuron_77 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[77*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[77]),
        .out(out[77*data_width +: data_width]),
        .out_valid(out_valid[77])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(78),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l2_weight_bias_dir,"weights_layer2_n78.mem"})
    ) neuron_78 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[78*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[78]),
        .out(out[78*data_width +: data_width]),
        .out_valid(out_valid[78])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(79),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l2_weight_bias_dir,"weights_layer2_n79.mem"})
    ) neuron_79 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[79*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[79]),
        .out(out[79*data_width +: data_width]),
        .out_valid(out_valid[79])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(80),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l2_weight_bias_dir,"weights_layer2_n80.mem"})
    ) neuron_80 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[80*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[80]),
        .out(out[80*data_width +: data_width]),
        .out_valid(out_valid[80])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(81),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l2_weight_bias_dir,"weights_layer2_n81.mem"})
    ) neuron_81 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[81*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[81]),
        .out(out[81*data_width +: data_width]),
        .out_valid(out_valid[81])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(82),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l2_weight_bias_dir,"weights_layer2_n82.mem"})
    ) neuron_82 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[82*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[82]),
        .out(out[82*data_width +: data_width]),
        .out_valid(out_valid[82])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(83),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l2_weight_bias_dir,"weights_layer2_n83.mem"})
    ) neuron_83 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[83*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[83]),
        .out(out[83*data_width +: data_width]),
        .out_valid(out_valid[83])
    );

endmodule
