`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.02.2025 11:23:47
// Design Name: 
// Module Name: test_padder
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

module test_padder;
    // Inputs
    reg clk;
    reg reset;
    reg [31:0] in;
    reg in_ready;
    reg is_last;
    reg [1:0] byte_num;
    reg f_ack;

    // Outputs
    wire buffer_full;
    wire [1087:0] out;  // Changed from 575:0 for SHA3-256 (rate = 1088 bits)
    wire out_ready;

    // Var
    integer i;

    // Instantiate the Unit Under Test (UUT)
    padder uut (
        .clk(clk),
        .reset(reset),
        .in(in),
        .in_ready(in_ready),
        .is_last(is_last),
        .byte_num(byte_num),
        .buffer_full(buffer_full),
        .out(out),
        .out_ready(out_ready),
        .f_ack(f_ack)
    );

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;
        in = 0;
        in_ready = 0;
        is_last = 0;
        byte_num = 0;
        f_ack = 0;

        // Wait 100 ns for global reset
        #100;

        // Add stimulus here
        @ (negedge clk);

        // Test Case 1: pad an empty string
        reset = 1; #(`P); reset = 0;
        #(7*`P); // wait some cycles
        if (buffer_full !== 0) error;
        in_ready = 1;
        is_last = 1;
        #(`P);
        in_ready = 1; // next input
        is_last = 1;
        #(`P);
        in_ready = 0;
        is_last = 0;

        while (out_ready !== 1)
            #(`P);
        // Using 0x06 (SHA3) padding with block size adjusted for SHA3-256
        check({8'h6, 1072'h0, 8'h80});
        f_ack = 1; #(`P); f_ack = 0;
        for(i=0; i<5; i=i+1)
          begin
            #(`P);
            if (buffer_full !== 0) error;
          end

        // Test Case 2: pad a (1088-8) bit string
        reset = 1; #(`P); reset = 0;
        #(4*`P);
        in_ready = 1; is_last = 0;
        byte_num = 3;
        
        // Fill 17 64-bit blocks (1088 bits = 17*64)
        for (i=0; i<16; i=i+1)
          begin
            in = 32'h12345678; #(`P);
            in = 32'h90ABCDEF; #(`P);
          end
        in = 32'h12345678; #(`P);
        in = 32'h90ABCDEF; is_last = 1; #(`P);
        in_ready = 0;
        is_last = 0;
        
        // SHA3-256 padding for last byte with full block
        check({ {17{64'h1234567890ABCDEF}}, 8'h6, 56'h0 });

        // Test Case 3: pad a (1088-64) bit string
        reset = 1; #(`P); reset = 0;
        in_ready = 1; is_last = 0;
        byte_num = 1;
        
        // Fill 16 64-bit blocks (1024 bits)
        for (i=0; i<16; i=i+1)
          begin
            in = 32'h12345678; #(`P);
            in = 32'h90ABCDEF; #(`P);
          end
        is_last = 1;
        byte_num = 0;
        #(`P);
        in_ready = 0;
        is_last = 0;
        #(`P);
        
        // SHA3-256 padding when there's exactly one 64-bit word left
        check({ {16{64'h1234567890ABCDEF}}, 64'h0600000000000080 });

        // Test Case 4: pad a (1088*2-16) bit string
        reset = 1; #(`P); reset = 0;
        in_ready = 1;
        byte_num = 7;
        is_last = 0;
        
        // Fill first block completely
        for (i=0; i<17; i=i+1)
          begin
            in = 32'h12345678; #(`P);
            in = 32'h90ABCDEF; #(`P);
          end
        if (out_ready !== 1) error;
        check({17{64'h1234567890ABCDEF}});
        #(`P/2);
        if (buffer_full !== 1) error;
        #(`P/2);
        in = 64'h999;
        #(`P/2);
        if (buffer_full !== 1) error;
        #(`P/2);
        f_ack = 1; #(`P); f_ack = 0;
        if (out_ready !== 0) error;
        
        // Feed next (1088-16) bit
        for (i=0; i<16; i=i+1)
          begin
            in = 32'h12345678; #(`P);
            in = 32'h90ABCDEF; #(`P);
          end
        in = 32'h12345678; #(`P);
        byte_num = 2;
        is_last = 1;
        in = 32'h90ABCDEF; #(`P);
        if (out_ready !== 1) error;
        
        // SHA3-256 padding for a block with 2 bytes missing
        check({ {16{64'h1234567890ABCDEF}}, 64'h1234567890AB0680 });
        is_last = 0;
        f_ack = 1; #(`P); f_ack = 0;
        
        in_ready = 0;
        is_last = 0;
        for (i=0; i<10; i=i+1)
          begin
            if (out_ready === 1) error;
            #(`P);
          end
        in_ready = 0;

        $display("SHA3-256 Padder Tests Passed!");
        $finish;
    end

    always #(`P/2) clk = ~ clk;

    task error;
        begin
              $display("Error in SHA3-256 Padder Test");
              $finish;
        end
    endtask

    task check;
        input [1087:0] wish;  // Changed from 575:0 for SHA3-256
        begin
          if (out !== wish)
            begin
              $display("out:%h wish:%h", out, wish);
              error;
            end
        end
    endtask
endmodule