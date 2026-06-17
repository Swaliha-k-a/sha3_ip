`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.02.2025 11:33:49
// Design Name: 
// Module Name: test_sha3
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`define P 20

module test_sha3;
    // Inputs
    reg clk;
    reg reset;
    reg [31:0] in;
    reg in_ready;
    reg is_last;
    reg [1:0] byte_num;

    // Outputs
    wire buffer_full;
    wire [255:0] out;
    wire out_ready;

    // Var
    integer i;
    
    // Debug
    reg [31:0] test_number;

    // Instantiate the Unit Under Test (UUT)
    sha3 uut (
        .clk(clk),
        .reset(reset),
        .in(in),
        .in_ready(in_ready),
        .is_last(is_last),
        .byte_num(byte_num),
        .buffer_full(buffer_full),
        .out(out),
        .out_ready(out_ready)
    );

    // Add waveform dumping
    initial begin
        $dumpfile("sha3_test.vcd");
        $dumpvars(0, test_sha3);
    end

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 0;
        in = 0;
        in_ready = 0;
        is_last = 0;
        byte_num = 0;
        test_number = 0;

        // Wait 100 ns for global reset
        #100;

        // Add stimulus here
        @ (negedge clk);

        // Test Case 1: SHA3-256("The quick brown fox jumps over the lazy dog")
        test_number = 1;
        $display("\n=== Starting Test Case %0d ===", test_number);
        reset = 1; #(`P); reset = 0;
        in_ready = 1; is_last = 0;
        in = "The "; #(`P);
        in = "quic"; #(`P);
        in = "k br"; #(`P);
        in = "own "; #(`P);
        in = "fox "; #(`P);
        in = "jump"; #(`P);
        in = "s ov"; #(`P);
        in = "er t"; #(`P);
        in = "he l"; #(`P);
        in = "azy "; #(`P);
        in = "dog "; byte_num = 3; is_last = 1; #(`P);
        in_ready = 0; is_last = 0;
        while (out_ready !== 1)
            #(`P);
        check(256'h69070dda01975c8c120c3aada1b282394e7f032fa9cf32f4cb2259a0897dfc04);

        // Test Case 2: "The quick brown fox jumps over the lazy dog."
        test_number = 2;
        $display("\n=== Starting Test Case %0d ===", test_number);
        reset = 1; #(`P); reset = 0;
        in_ready = 1; is_last = 0;
        in = "The "; #(`P);
        in = "quic"; #(`P);
        in = "k br"; #(`P);
        in = "own "; #(`P);
        in = "fox "; #(`P);
        in = "jump"; #(`P);
        in = "s ov"; #(`P);
        in = "er t"; #(`P);
        in = "he l"; #(`P);
        in = "azy "; #(`P);
        in = "dog."; #(`P);
        in = 0; byte_num = 0; is_last = 1; #(`P);
        in_ready = 0; is_last = 0;
        while (out_ready !== 1)
            #(`P);
        check(256'ha80f839cd4f83f6c3dafc87feae470045e4eb0d366397d5c6ce34ba1739f734d);

        
        // Test Case 3: Empty string
        test_number = 3;
        $display("\n=== Starting Test Case %0d ===", test_number);
        reset = 1; #(`P); reset = 0;
        #(7*`P);
        in = 32'h12345678;
        byte_num = 0;
        in_ready = 1;
        is_last = 1;
        #(`P);
        in = 32'hddddd;
        in_ready = 1;
        is_last = 1;
        #(`P);
        in_ready = 0;
        is_last = 0;

        while (out_ready !== 1)
            #(`P);
        check(256'ha7ffc6f8bf1ed76651c14756a061d662f580ff4de43b49fa82d80a4b80f8434a);
        
        // Test Case 4: "keccak"
        test_number = 4;
        $display("\n=== Starting Test Case %0d: 'keccak' ===", test_number);
        reset = 1; #(`P); reset = 0;
        in_ready = 1; is_last = 0;
        byte_num = 0;
        
        in = "kecc"; #(`P);
        in = "ak  "; byte_num = 2; is_last = 1; #(`P);
        
        in_ready = 0; is_last = 0;
        while (out_ready !== 1)
            #(`P);
        check(256'h867d9376afcfd3c0ec7799d4eddd4f98f951eccd31a9232350d2ee42a953ae5b);

        // Test Case 5: "all glitters are not gold"
        test_number = 5;
        $display("\n=== Starting Test Case %0d: 'all glitters are not gold' ===", test_number);
        reset = 1; #(`P); reset = 0;
        in_ready = 1; is_last = 0;
        byte_num = 0;
        
        in = "all "; #(`P);
        in = "glit"; #(`P);
        in = "ters"; #(`P);
        in = " are"; #(`P);
        in = " not"; #(`P);
        in = " gol"; #(`P);
        in = "d   "; byte_num = 1; is_last = 1; #(`P);
        
        in_ready = 0; is_last = 0;
        while (out_ready !== 1)
            #(`P);
        check(256'h57976325d60fb1697f7fc979e5044f951cf44043798813a77c97e315f0d6a5c0);

        $display("\nAll enabled test cases completed!");
        $finish;
    end

    always #(`P/2) clk = ~ clk;

    // Enhanced error reporting
    task error;
        begin
              $display("Error in SHA3-256 Test Case %0d at time %t", test_number, $time);
              $display("Current state:");
              $display("  in = %h", in);
              $display("  byte_num = %d", byte_num);
              $display("  in_ready = %b", in_ready);
              $display("  is_last = %b", is_last);
              $display("  buffer_full = %b", buffer_full);
              $display("  out_ready = %b", out_ready);
              $finish;
        end
    endtask

    // Enhanced check task with better reporting
    task check;
        input [255:0] wish;
        begin
          if (out !== wish) begin
              $display("Error in Test Case %0d at time %t", test_number, $time);
              $display("Output hash does not match expected value:");
              $display("Got     : %h", out);
              $display("Expected: %h", wish);
              error;
          end else begin
              $display("Test Case %0d passed successfully!", test_number);
          end
        end
    endtask
endmodule

`undef P