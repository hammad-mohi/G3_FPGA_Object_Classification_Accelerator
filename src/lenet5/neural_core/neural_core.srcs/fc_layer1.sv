
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: fc_layer1
// Description: Create a fully connected layer by instantiating neurons
//                Layer 1:
//                  activation:           ReLU
//                  # neurons:            120
//                  # weights per neuron: 512
//////////////////////////////////////////////////////////////////////////////////

`include "nc_defines.vh"

module fc_layer1 #(
    parameter num_neurons=`fc_hidden_l1_nn,
    parameter num_weights=`l1_num_weights,
    parameter data_width=`input_data_width,
    parameter layer_idx=1,
    parameter weight_int_width_fp=`fixed_pt_int_width,
    parameter activation_type=`l1_activation_type
)
(
    input                               clk,
    input                               rst,
    input  [data_width-1:0]             in,
    input                               in_valid,
    output [num_neurons*data_width-1:0] out,
    output [num_neurons-1:0]            out_valid // array of valid signals from each neuron
);

//    always @(posedge clk) begin
//        $display("out= %h", out);
//    end
    
    // weights for all neurons in this layer are in 1 file
    //reg [data_width-1:0] i_weights [0:num_neurons*num_weights-1];
    reg [data_width*num_neurons*num_weights-1:0] i_weights;
    wire i_weight_valid;
    reg [2*data_width-1:0] biases [0:`l1_num_biases-1];
    
    //int wfile_basename = "weights_layer1_n";
    
    // read weights & biases from files for this layer
    initial begin
//        int i;
//        for (i=0; i<num_neurons*num_weights;i++) begin
//            i_weights[i*data_width+:data_width] <= 'd1;
//        end
        //$readmemh(`l1_weight_file, i_weights);
        $readmemh(`l1_bias_file, biases);
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
//                //.wfile                ($sformat(`l1_weight_bias_dir,wfile_basename,i,".mem"))
//                //.wfile                ("weight_bias/layer1/weights_layer1_n0.mem")
//                //.wfile                ("./weight_bias/layer1/weights_layer1_n0.mem")
//                .wfile                ({`l1_weight_bias_dir,"weights_layer1_n0.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n0.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n1.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n2.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n3.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n4.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n5.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n6.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n7.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n8.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n9.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n10.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n11.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n12.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n13.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n14.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n15.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n16.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n17.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n18.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n19.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n20.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n21.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n22.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n23.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n24.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n25.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n26.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n27.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n28.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n29.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n30.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n31.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n32.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n33.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n34.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n35.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n36.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n37.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n38.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n39.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n40.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n41.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n42.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n43.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n44.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n45.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n46.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n47.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n48.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n49.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n50.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n51.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n52.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n53.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n54.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n55.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n56.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n57.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n58.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n59.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n60.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n61.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n62.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n63.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n64.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n65.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n66.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n67.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n68.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n69.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n70.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n71.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n72.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n73.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n74.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n75.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n76.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n77.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n78.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n79.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n80.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n81.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n82.mem"})
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
        .wfile({`l1_weight_bias_dir,"weights_layer1_n83.mem"})
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

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(84),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l1_weight_bias_dir,"weights_layer1_n84.mem"})
    ) neuron_84 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[84*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[84]),
        .out(out[84*data_width +: data_width]),
        .out_valid(out_valid[84])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(85),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l1_weight_bias_dir,"weights_layer1_n85.mem"})
    ) neuron_85 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[85*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[85]),
        .out(out[85*data_width +: data_width]),
        .out_valid(out_valid[85])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(86),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l1_weight_bias_dir,"weights_layer1_n86.mem"})
    ) neuron_86 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[86*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[86]),
        .out(out[86*data_width +: data_width]),
        .out_valid(out_valid[86])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(87),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l1_weight_bias_dir,"weights_layer1_n87.mem"})
    ) neuron_87 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[87*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[87]),
        .out(out[87*data_width +: data_width]),
        .out_valid(out_valid[87])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(88),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l1_weight_bias_dir,"weights_layer1_n88.mem"})
    ) neuron_88 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[88*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[88]),
        .out(out[88*data_width +: data_width]),
        .out_valid(out_valid[88])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(89),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l1_weight_bias_dir,"weights_layer1_n89.mem"})
    ) neuron_89 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[89*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[89]),
        .out(out[89*data_width +: data_width]),
        .out_valid(out_valid[89])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(90),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l1_weight_bias_dir,"weights_layer1_n90.mem"})
    ) neuron_90 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[90*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[90]),
        .out(out[90*data_width +: data_width]),
        .out_valid(out_valid[90])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(91),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l1_weight_bias_dir,"weights_layer1_n91.mem"})
    ) neuron_91 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[91*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[91]),
        .out(out[91*data_width +: data_width]),
        .out_valid(out_valid[91])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(92),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l1_weight_bias_dir,"weights_layer1_n92.mem"})
    ) neuron_92 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[92*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[92]),
        .out(out[92*data_width +: data_width]),
        .out_valid(out_valid[92])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(93),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l1_weight_bias_dir,"weights_layer1_n93.mem"})
    ) neuron_93 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[93*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[93]),
        .out(out[93*data_width +: data_width]),
        .out_valid(out_valid[93])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(94),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l1_weight_bias_dir,"weights_layer1_n94.mem"})
    ) neuron_94 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[94*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[94]),
        .out(out[94*data_width +: data_width]),
        .out_valid(out_valid[94])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(95),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l1_weight_bias_dir,"weights_layer1_n95.mem"})
    ) neuron_95 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[95*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[95]),
        .out(out[95*data_width +: data_width]),
        .out_valid(out_valid[95])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(96),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l1_weight_bias_dir,"weights_layer1_n96.mem"})
    ) neuron_96 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[96*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[96]),
        .out(out[96*data_width +: data_width]),
        .out_valid(out_valid[96])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(97),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l1_weight_bias_dir,"weights_layer1_n97.mem"})
    ) neuron_97 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[97*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[97]),
        .out(out[97*data_width +: data_width]),
        .out_valid(out_valid[97])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(98),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l1_weight_bias_dir,"weights_layer1_n98.mem"})
    ) neuron_98 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[98*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[98]),
        .out(out[98*data_width +: data_width]),
        .out_valid(out_valid[98])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(99),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l1_weight_bias_dir,"weights_layer1_n99.mem"})
    ) neuron_99 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[99*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[99]),
        .out(out[99*data_width +: data_width]),
        .out_valid(out_valid[99])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(100),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l1_weight_bias_dir,"weights_layer1_n100.mem"})
    ) neuron_100 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[100*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[100]),
        .out(out[100*data_width +: data_width]),
        .out_valid(out_valid[100])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(101),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l1_weight_bias_dir,"weights_layer1_n101.mem"})
    ) neuron_101 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[101*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[101]),
        .out(out[101*data_width +: data_width]),
        .out_valid(out_valid[101])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(102),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l1_weight_bias_dir,"weights_layer1_n102.mem"})
    ) neuron_102 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[102*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[102]),
        .out(out[102*data_width +: data_width]),
        .out_valid(out_valid[102])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(103),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l1_weight_bias_dir,"weights_layer1_n103.mem"})
    ) neuron_103 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[103*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[103]),
        .out(out[103*data_width +: data_width]),
        .out_valid(out_valid[103])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(104),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l1_weight_bias_dir,"weights_layer1_n104.mem"})
    ) neuron_104 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[104*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[104]),
        .out(out[104*data_width +: data_width]),
        .out_valid(out_valid[104])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(105),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l1_weight_bias_dir,"weights_layer1_n105.mem"})
    ) neuron_105 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[105*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[105]),
        .out(out[105*data_width +: data_width]),
        .out_valid(out_valid[105])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(106),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l1_weight_bias_dir,"weights_layer1_n106.mem"})
    ) neuron_106 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[106*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[106]),
        .out(out[106*data_width +: data_width]),
        .out_valid(out_valid[106])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(107),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l1_weight_bias_dir,"weights_layer1_n107.mem"})
    ) neuron_107 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[107*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[107]),
        .out(out[107*data_width +: data_width]),
        .out_valid(out_valid[107])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(108),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l1_weight_bias_dir,"weights_layer1_n108.mem"})
    ) neuron_108 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[108*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[108]),
        .out(out[108*data_width +: data_width]),
        .out_valid(out_valid[108])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(109),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l1_weight_bias_dir,"weights_layer1_n109.mem"})
    ) neuron_109 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[109*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[109]),
        .out(out[109*data_width +: data_width]),
        .out_valid(out_valid[109])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(110),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l1_weight_bias_dir,"weights_layer1_n110.mem"})
    ) neuron_110 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[110*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[110]),
        .out(out[110*data_width +: data_width]),
        .out_valid(out_valid[110])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(111),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l1_weight_bias_dir,"weights_layer1_n111.mem"})
    ) neuron_111 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[111*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[111]),
        .out(out[111*data_width +: data_width]),
        .out_valid(out_valid[111])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(112),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l1_weight_bias_dir,"weights_layer1_n112.mem"})
    ) neuron_112 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[112*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[112]),
        .out(out[112*data_width +: data_width]),
        .out_valid(out_valid[112])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(113),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l1_weight_bias_dir,"weights_layer1_n113.mem"})
    ) neuron_113 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[113*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[113]),
        .out(out[113*data_width +: data_width]),
        .out_valid(out_valid[113])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(114),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l1_weight_bias_dir,"weights_layer1_n114.mem"})
    ) neuron_114 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[114*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[114]),
        .out(out[114*data_width +: data_width]),
        .out_valid(out_valid[114])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(115),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l1_weight_bias_dir,"weights_layer1_n115.mem"})
    ) neuron_115 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[115*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[115]),
        .out(out[115*data_width +: data_width]),
        .out_valid(out_valid[115])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(116),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l1_weight_bias_dir,"weights_layer1_n116.mem"})
    ) neuron_116 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[116*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[116]),
        .out(out[116*data_width +: data_width]),
        .out_valid(out_valid[116])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(117),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l1_weight_bias_dir,"weights_layer1_n117.mem"})
    ) neuron_117 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[117*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[117]),
        .out(out[117*data_width +: data_width]),
        .out_valid(out_valid[117])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(118),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l1_weight_bias_dir,"weights_layer1_n118.mem"})
    ) neuron_118 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[118*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[118]),
        .out(out[118*data_width +: data_width]),
        .out_valid(out_valid[118])
    );

    neuron #(
        .layer_idx(layer_idx),
        .neuron_idx(119),
        .num_weights(num_weights),
        .data_width(data_width),
        .weight_int_width_fp(weight_int_width_fp),
        .activation_type(activation_type),
        .wfile({`l1_weight_bias_dir,"weights_layer1_n119.mem"})
    ) neuron_119 (
        .clk(clk),
        .rst(rst),
        .in(in),
        .in_valid(in_valid),
        .i_weight(i_weights[119*num_weights +: num_weights*data_width]),
        .i_weight_valid(i_weight_valid),
        .bias(biases[119]),
        .out(out[119*data_width +: data_width]),
        .out_valid(out_valid[119])
    );

endmodule
