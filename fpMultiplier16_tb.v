`timescale 1ns / 1ps

module float_multi_tb;

  // Inputs
  reg [15:0] num1, num2;

  // Outputs
  wire [15:0] result;
  wire overflow, zero, NaN, precisionLost;

  // Instantiate the Unit Under Test (UUT)
  float_multi uut (
    .num1(num1),
    .num2(num2),
    .result(result),
    .overflow(overflow),
    .zero(zero),
    .NaN(NaN),
    .precisionLost(precisionLost)
  );

  // Task for printing results
  task print_result;
    begin
      $display("Time = %0t | num1 = 0x%h | num2 = 0x%h => result = 0x%h | Overflow: %b | Zero: %b | NaN: %b | PrecisionLost: %b",
        $time, num1, num2, result, overflow, zero, NaN, precisionLost);
    end
  endtask

  initial begin
    $display("Starting 16-bit Floating Point Multiplier Testbench...");

    // Test 1: 1.5 * 2.0 (normal * normal)
    num1 = 16'b0_01111_1000000000; // 1.5
    num2 = 16'b0_10000_0000000000; // 2.0
    #10; print_result;

    // Test 2: 0 * 1.25
    num1 = 16'b0_00000_0000000000; // 0
    num2 = 16'b0_01111_0100000000; // 1.25
    #10; print_result;

    // Test 3: -3.5 * 1.0
    num1 = 16'b1_10000_1100000000; // -3.5
    num2 = 16'b0_01111_0000000000; // 1.0
    #10; print_result;

    // Test 4: Infinity * 1.0
    num1 = 16'b0_11111_0000000000; // +Inf
    num2 = 16'b0_01111_0000000000; // 1.0
    #10; print_result;

    // Test 5: NaN * 1.0
    num1 = 16'b0_11111_0000000001; // NaN
    num2 = 16'b0_01111_0000000000; // 1.0
    #10; print_result;

    // Test 6: Subnormal * normal
    num1 = 16'b0_00000_0000000001; // Smallest subnormal
    num2 = 16'b0_01111_0000000000; // 1.0
    #10; print_result;

    // Test 7: Overflow test (large * large)
    num1 = 16'b0_11110_1111111111; // Largest normal
    num2 = 16'b0_11110_1111111111; // Largest normal
    #10; print_result;

    // Test 8: Precision loss test
    num1 = 16'b0_01111_0000000001; // 1.000...01 (tiny LSB)
    num2 = 16'b0_01111_0000000001; // same
    #10; print_result;

    $display("Testbench completed.");
    $finish;
  end

endmodule
