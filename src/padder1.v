`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.02.2025 11:01:26
// Design Name: 
// Module Name: padder1
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

// padder1.v - Modified for SHA3
module padder1(in, byte_num, out);
    input      [31:0] in;
    input      [1:0]  byte_num;
    output reg [31:0] out;
    
    always @ (*)
      case (byte_num)
        0: out = 32'h6000000;  // Changed from 0x1000000 to 0x6000000 for SHA3
        1: out = {in[31:24], 24'h060000};
        2: out = {in[31:16], 16'h0600};
        3: out = {in[31:8],   8'h06};
      endcase
endmodule
