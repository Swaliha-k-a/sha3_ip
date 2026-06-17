`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.02.2025 11:28:46
// Design Name: 
// Module Name: test_padder1
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


// SHA3 Padder1 Testbench
module test_padder1;
    // Inputs
    reg [31:0] in;
    reg [1:0] byte_num;

    // Outputs
    wire [31:0] out;
    
    reg [31:0] wish;

    // Instantiate the Unit Under Test (UUT)
    padder1 uut (
        .in(in),
        .byte_num(byte_num),
        .out(out)
    );

    initial begin
        // Initialize Inputs
        in = 0;
        byte_num = 0;

        // Wait 100 ns for global reset
        #100;

        // Add stimulus here - Using SHA3-256 padding (0x06 instead of 0x01)
        in = 32'h90ABCDEF;
        byte_num = 0;
        wish = 32'h06000000;  // SHA3-256 padding
        check;
        byte_num = 1;
        wish = 32'h90060000;  // SHA3-256 padding
        check;
        byte_num = 2;
        wish = 32'h90AB0600;  // SHA3-256 padding
        check;
        byte_num = 3;
        wish = 32'h90ABCD06;  // SHA3-256 padding
        check;
        $display("SHA3-256 Padder1 Tests Passed!");
        $finish;
    end

    task check;
      begin
        #(`P);
        if (out !== wish)
          begin
            $display("Error in SHA3-256 Padder1 Test");
            $finish;
          end
      end
    endtask
endmodule

`undef P