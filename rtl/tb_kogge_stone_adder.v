`timescale 1ns / 1ps
module tb_kogge_stone_adder;

    localparam PRECISION = 8;
    localparam SIM_DELAY = 10;

    // Testbench signals
    reg  [PRECISION-1:0] tb_operand_a;
    reg  [PRECISION-1:0] tb_operand_b;
    wire [PRECISION-1:0] tb_result;
    wire                 tb_overflow;

    // Expected results for verification
    wire [PRECISION:0]   expected_sum;
    wire                 expected_overflow;

    assign expected_sum      = tb_operand_a + tb_operand_b;
    assign expected_overflow = expected_sum[PRECISION];

    // Instantiate DUT
    kogge_stone_adder #(
        .PRECISION(PRECISION)
    ) dut_inst (
        .operand_a_i(tb_operand_a),
        .operand_b_i(tb_operand_b),
        .result_o   (tb_result),
        .overflow_o (tb_overflow)
    );

    // Test stimulus
    initial begin
        $display("------------------------------------------------------------------------------------------------");
        $display("Starting Kogge-Stone Adder Testbench...");
        $display("PRECISION = %0d", PRECISION);
        $display("------------------------------------------------------------------------------------------------");
        $display("Time\t A \t + \t B \t | \t DUT Result \t DUT Ovflw \t | \t Expected \t Exp Ovflw \t Status");
        $display("------------------------------------------------------------------------------------------------");

        tb_operand_a = 0;
        tb_operand_b = 0;
        #SIM_DELAY;
        check_result(8'd0, 8'd0);

        check_result(8'd10, 8'd25);
        check_result(8'd88, 8'd42);
        check_result({PRECISION{1'b1}}, 8'd0); // Max value + 0
        check_result({PRECISION{1'b1}}, 8'd1); // Overflow test
        check_result(8'd150, 8'd150);          // Overflow test

        // Random test cases
        $display("\n--- Running 10 Random Test Cases ---");
        for (integer i = 0; i < 10; i = i + 1) begin
            check_result($random, $random);
        end
        $display("--- End of Random Test Cases ---\n");

        $display("------------------------------------------------------------------------------------------------");
        $display("Testbench simulation finished.");
        $display("------------------------------------------------------------------------------------------------");
        $finish;
    end

    // Self-checking task
    task check_result;
        input [PRECISION-1:0] a;
        input [PRECISION-1:0] b;
        begin
            tb_operand_a = a;
            tb_operand_b = b;
            #SIM_DELAY;

            if (tb_result === expected_sum[PRECISION-1:0] && tb_overflow === expected_overflow) begin
                $display("%0t\t %d\t + \t %d\t | \t\t %d \t\t %b \t\t | \t\t %d \t\t %b \t\t PASS",
                         $time, tb_operand_a, tb_operand_b, tb_result, tb_overflow,
                         expected_sum[PRECISION-1:0], expected_overflow);
            end
            else begin
                $error("MISMATCH DETECTED!");
                $display("%0t\t %d\t + \t %d\t | \t\t %d \t\t %b \t\t | \t\t %d \t\t %b \t\t FAIL",
                         $time, tb_operand_a, tb_operand_b, tb_result, tb_overflow,
                         expected_sum[PRECISION-1:0], expected_overflow);
            end
        end
    endtask

endmodule