`timescale 1ns / 1ps

module kogge_stone_adder #(parameter PRECISION = 8)(
    input  [PRECISION-1:0] operand_a_i,
    input  [PRECISION-1:0] operand_b_i,
    output [PRECISION-1:0] result_o,
    output overflow_o
);
    // Compute number of prefix stages (ceiling log2)
    function integer clog2;
        input integer value;
        integer i;
        begin
            clog2 = 0;
            for (i = value - 1; i > 0; i = i >> 1)
                clog2 = clog2 + 1;
        end
    endfunction
    
    localparam NUM_STEPS = clog2(PRECISION);
    
    // Wires for generate and propagate signals
    wire [(NUM_STEPS+1)*PRECISION-1:0] generates;
    wire [NUM_STEPS*PRECISION-1:0]     propagates;
    
    genvar k, i;
    
    // Stage 0: Initial Generate and Propagate
    generate
        for (i = 0; i < PRECISION; i = i + 1) begin : init_stage
            assign generates[i] = operand_a_i[i] & operand_b_i[i];
            assign propagates[i] = operand_a_i[i] ^ operand_b_i[i];
        end
    endgenerate
    
    // Prefix Stages (1 to NUM_STEPS-1)
    generate
        for (k = 1; k < NUM_STEPS; k = k + 1) begin : prefix_stage
            for (i = 0; i < PRECISION; i = i + 1) begin : prefix_bit
                if (i >= (1 << (k-1))) begin : update
                    assign generates[k*PRECISION + i] = generates[(k-1)*PRECISION + i] |
                        (propagates[(k-1)*PRECISION + i] & generates[(k-1)*PRECISION + i - (1 << (k-1))]);
                    assign propagates[k*PRECISION + i] = propagates[(k-1)*PRECISION + i] &
                        propagates[(k-1)*PRECISION + i - (1 << (k-1))];
                end else begin : passthrough
                    assign generates[k*PRECISION + i] = generates[(k-1)*PRECISION + i];
                    assign propagates[k*PRECISION + i] = propagates[(k-1)*PRECISION + i];
                end
            end
        end
    endgenerate
    
    // Final Stage
    generate
        for (i = 0; i < PRECISION; i = i + 1) begin : final_stage
            if (i >= (1 << (NUM_STEPS-1))) begin : update
                assign generates[NUM_STEPS*PRECISION + i] = generates[(NUM_STEPS-1)*PRECISION + i] |
                    (propagates[(NUM_STEPS-1)*PRECISION + i] & generates[(NUM_STEPS-1)*PRECISION + i - (1 << (NUM_STEPS-1))]);
            end else begin : passthrough
                assign generates[NUM_STEPS*PRECISION + i] = generates[(NUM_STEPS-1)*PRECISION + i];
            end
        end
    endgenerate
    
    // Sum Bits Computation
    assign result_o[0] = propagates[0];
    generate
        for (i = 1; i < PRECISION; i = i + 1) begin : sum_stage
            assign result_o[i] = propagates[i] ^ generates[NUM_STEPS*PRECISION + i - 1];
        end
    endgenerate
    
    // Overflow Detection
    assign overflow_o = (PRECISION > 1) ?
                        (generates[NUM_STEPS*PRECISION + PRECISION - 1] |
                         (propagates[PRECISION-1] & generates[NUM_STEPS*PRECISION + PRECISION - 2])) :
                        generates[NUM_STEPS*PRECISION];

endmodule
