
`ifndef nc_defines_vh
`define nc_defines_vh

    // when want to use separate weight files for each neuron
    `define use_per_neuron_wfiles
    //`define use_dsp
    //`define weight_bias_base_dir          "weight_bias/"
    //`define weight_bias_base_dir          "/home/mehdi/Desktop/ece532/project/lenet/neural_core/neural_core.srcs/sources_1/new/weight_bias/"
    `define weight_bias_base_dir          "C:/ECE532/Project/final_demo/lenet/neural_core/neural_core.srcs/sources_1/new/weight_bias/"
    
    
    `define input_data_width              16
    `define conv_kernel_width             3
    // FIXME: double check this
    `define fixed_pt_int_width            0 // width of integer part of fixed point #
    `define fc_num_inputs                 512 // 2x2x128 from last maxpool
    
    `define conv_layer_wb_dir             {`weight_bias_base_dir,"cnn/"}
    
    // layer 1
    `define fc_hidden_l1_nn               120
    `define l1_num_weights                512
    `define l1_num_biases                 120
    `define l1_activation_type            "relu"
    `define l1_weight_file                "layer1_weights.mem"
    `define l1_weight_bias_dir            {`weight_bias_base_dir,"layer1/"}
    `define l1_bias_file                  {`l1_weight_bias_dir,"biases_layer1.mem"}
    
    // layer 2
    `define fc_hidden_l2_nn               84
    `define l2_num_weights                120
    `define l2_num_biases                 84
    `define l2_activation_type            "relu"
    `define l2_weight_file                "layer2_weights.mem"
    `define l2_weight_bias_dir            {`weight_bias_base_dir,"layer2/"}
    `define l2_bias_file                  {`l2_weight_bias_dir,"biases_layer2.mem"}
    
    // output layer
    `define fc_out_layer_nn               43
    `define out_layer_num_weights         84
    `define out_layer_num_biases          43
    `define out_layer_activation_type     "softmax"
    `define output_layer_weight_file      "output_layer_weights.mem"
    `define output_layer_weight_bias_dir  {`weight_bias_base_dir,"output_layer/"}
    `define output_layer_bias_file        {`output_layer_weight_bias_dir,"biases_output_layer.mem"}

`endif // nc_defines_vh