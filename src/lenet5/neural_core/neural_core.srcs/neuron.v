
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: neuron
// Description: Implement a neuron
//                function:   w.x + b
//                activation: ReLU / Softmax
//////////////////////////////////////////////////////////////////////////////////

`include "nc_defines.vh"

module neuron #(
    parameter layer_idx=0,
    parameter neuron_idx=0,
    parameter num_weights=3,
    parameter data_width=`input_data_width,
    parameter weight_int_width_fp=`fixed_pt_int_width,
	parameter activation_type="relu",
    parameter wfile=""
)
(
    input                               clk,
    input                               rst,
    input  [data_width-1:0]             in,
    input                               in_valid,
    input  [data_width*num_weights-1:0] i_weight,
    input                               i_weight_valid,
    input  [2*data_width-1:0]           bias,
    output [data_width-1:0]             out,
    output reg                          out_valid
);

    localparam addr_width = $clog2(num_weights);
    
    // for weight buffer
    wire rden;
    reg [addr_width:0]                  rdaddr;
    //reg wren = 'd0;
    //reg [addr_width-1:0] wraddr = 'd0;
    //reg [data_width-1:0] i_weight_val = 'd0;
    //reg [data_width*num_weights-1:0] i_weight_ff = 'd0;
    
    wire [data_width-1:0] weight;
//    reg  [data_width-1:0]               weight = 'd0;
    reg                                 weight_valid;
    reg  [2*data_width-1:0]             mult;
    reg                                 mult_valid;
    reg  [2*data_width-1:0]             sum;
    wire [2*data_width-1:0]             sum_bias_acc;
    wire [2*data_width-1:0]             sum_mult_acc;
    reg  [data_width-1:0]               delayed_in;
    
    wire                                mux_ctrl_pipelined_mult;
    reg                                 mux_ctrl_sma; // choose sum_mult_acc
    reg                                 mux_ctrl_sba; // choose sum_bias_acc
    
    // pipeline activation valid signal; used to generate out_valid
    reg                                 activation_valid;
    
    
    assign mux_ctrl_pipelined_mult = mult_valid; // account for mult pipeline
    assign rden = in_valid & (rdaddr < num_weights); // read request to fc_weight_buffer
    
    // multiply accum
    assign sum_mult_acc = mult + sum;
    assign sum_bias_acc = bias + sum;
    
    // generate read address for fc_weight_buffer
    always @(posedge clk) begin
        //if(rst | out_valid | rdaddr >= num_weights) rdaddr <= 'd0;
        if(rst | out_valid) rdaddr <= 'd0;
        //else if(in_valid & ~mux_ctrl_sba & ~(rdaddr==num_weights & ~mux_ctrl_pipelined_mult)) rdaddr <= rdaddr + 'd1;
        else if(in_valid & ~mux_ctrl_sba) rdaddr <= rdaddr + 'd1;
    end
    
    // mult pipeline
    // $signed: let verilog figure out the 2's complement math
    always @(posedge clk) begin
//        mult <= $signed(delayed_in) * $signed(weight);
        mult <= delayed_in * weight;
    end
    
    // sum + overflow + underflow logic
    // add the bias when done
    always @(posedge clk) begin
        if (rst | out_valid) sum <= 'd0;
        // done; add the bias
        else if ((rdaddr == num_weights) & mux_ctrl_sba) begin
            // overflow logic: check for sign-bit mismatch
            if (~bias[2*data_width-1] & ~sum[2*data_width-1] & sum_bias_acc[2*data_width-1]) begin
                // saturation
                sum[2*data_width-1] <= 0;
                sum[2*data_width-2:0] <= {2*data_width-1{1'b1}};
            end
            // underflow logic: check for sign-bit mismatch
            else if (bias[2*data_width-1] & sum[2*data_width-1] & ~sum_bias_acc[2*data_width-1]) begin
                // saturation
                sum[2*data_width-1] <= 1;
                sum[2*data_width-2:0] <= 'd0;
            end
            // no overflow/underflow
            else sum <= sum_bias_acc;
        end
        else if (mux_ctrl_pipelined_mult) begin
            // overflow logic: check for sign-bit mismatch
            if (~sum[2*data_width-1] & ~sum[2*data_width-1] & sum_mult_acc[2*data_width-1]) begin
                // saturation
                sum[2*data_width-1] <= 0;
                sum[2*data_width-2:0] <= {2*data_width-1{1'b1}};
            end
            // underflow logic: check for sign-bit mismatch
            else if (~sum[2*data_width-1] & ~sum[2*data_width-1] & sum_mult_acc[2*data_width-1]) begin
                // saturation
                sum[2*data_width-1] <= 1;
                sum[2*data_width-2:0] <= 'd0;
            end
            // no overflow/underflow
            else sum <= sum_mult_acc;
        end
    end
    
    // manage the delays and pipeline stages
    always @(posedge clk) begin
		if (rst) begin
        	delayed_in <= 0;
        	weight_valid <= 0;
        	mult_valid <= 0;
        	activation_valid <= 0;
        	out_valid <= 0;
        	mux_ctrl_sma <= 0;
        	mux_ctrl_sba <= 0;
		end
		else begin
        	delayed_in <= in;
        	weight_valid <= in_valid;
        	mult_valid <= weight_valid;
        	activation_valid <= ((rdaddr == num_weights) & mux_ctrl_sba);
        	//activation_valid <= mux_ctrl_sba;
        	out_valid <= activation_valid;
        	mux_ctrl_sma <= mux_ctrl_pipelined_mult;
        	mux_ctrl_sba <= ~mux_ctrl_pipelined_mult & mux_ctrl_sma;
		end
    end
    
//    // store input weights in buffer instead of mem file
//    always @(posedge clk) begin
//        if (rst) begin
//            // init to all 1's so it rolls over to 0 when storing 1st weight
//            wraddr <= {addr_width{1'b1}};
//            wren <= 1'b0;
//            i_weight_ff <= i_weight;
//        end
//        else if (i_weight_valid) begin
//            i_weight_val <= i_weight_ff[wraddr];
//            wren <= 1'b1;
//            wraddr <= wraddr + 'd1;
//        end
//        else wren <= 1'b0;
//    end
        
    // instantiate the weight buffer
    fc_weight_buffer #(
        .num_weights(num_weights),
        .addr_width(addr_width),
        .data_width(data_width),
        .wfile(wfile)
    ) fcwbuf0 (
        .clk(clk),
        .rden(rden),
        .rdaddr(rdaddr),
        .wren(),
        .wraddr(),
        .i_weight_val(),
        .weight(weight)
    );
    
//    // feed weights into the multiplier
//    localparam IDLE = 'd0;
//    localparam SHIFT = 'd1;
    
//    reg  [data_width*num_weights-1:0] i_weight_shift_reg = 'd0;
//    //initial i_weight_shift_reg = i_weight;
    
//    reg il_state = 'd0;
//    //integer il_counter;
//    always @(posedge clk) begin
//        if (rst) begin
//            il_state <= IDLE;
//            i_weight_shift_reg <= 'd0;
//            //il_counter <= 0;
//        end
//        else begin
            
//            case (il_state)
//                IDLE: begin
//                    //il_counter <= 0;
//                    i_weight_shift_reg <= i_weight;
//                    //if (i_weight_valid & in_valid) begin // FIXME: double check logic
//                    if (in_valid) begin // FIXME: double check logic
//                        //i_weight_shift_reg <= i_weight;
//                        il_state <= SHIFT;
//                    end
//                end
//                SHIFT: begin
//                    //il_out <= i_weight_shift_reg[`input_data_width-1:0];
//                    weight <= i_weight_shift_reg[data_width-1:0];
//                    i_weight_shift_reg <= i_weight_shift_reg >> data_width;
//                    //il_counter <= il_counter + 1;
//                    if (rdaddr == num_weights) begin
//                        il_state <= IDLE;
//                    end
//                end
//            endcase
//        end
//    end
    
    // decide on type of activation function
    generate
        if (activation_type == "relu") begin
            relu #(
                .data_width(data_width),
                .weight_int_width_fp(weight_int_width_fp)
            ) relu0 (
                .clk(clk),
                .in(sum),
                .out(out) // output of this neuron after activation
            );
        end
        
        else begin
            // FIXME: double check this
            // output of this neuron without activation
            assign out = sum[2*data_width-1-weight_int_width_fp -: data_width];
        end
    
    endgenerate

endmodule
