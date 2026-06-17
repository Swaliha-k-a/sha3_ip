
`define P 20

module test_rconst;

    // Inputs
    reg [23:0] i;

    // Outputs
    wire [63:0] rc;

    // Instantiate the Unit Under Test (UUT)
    rconst uut (
        .i(i), 
        .rc(rc)
    );

    initial begin
        // Initialize Inputs
        i = 0;

        // Wait 100 ns for global reset to finish
        #100;
        
        // Add stimulus here - SHA-3 round constants (same for all SHA3 variants)
        i=0; i[0] = 1;
        #(`P);
        if(rc !== 64'h0000000000000001) begin $display("E"); $finish; end
        i=0; i[1] = 1;
        #(`P);
        if(rc !== 64'h0000000000008082) begin $display("E"); $finish; end
        i=0; i[2] = 1;
        #(`P);
        if(rc !== 64'h800000000000808A) begin $display("E"); $finish; end
        i=0; i[3] = 1;
        #(`P);
        if(rc !== 64'h8000000080008000) begin $display("E"); $finish; end
        i=0; i[4] = 1;
        #(`P);
        if(rc !== 64'h000000000000808B) begin $display("E"); $finish; end
        i=0; i[5] = 1;
        #(`P);
        if(rc !== 64'h0000000080000001) begin $display("E"); $finish; end
        i=0; i[6] = 1;
        #(`P);
        if(rc !== 64'h8000000080008081) begin $display("E"); $finish; end
        i=0; i[7] = 1;
        #(`P);
        if(rc !== 64'h8000000000008009) begin $display("E"); $finish; end
        i=0; i[8] = 1;
        #(`P);
        if(rc !== 64'h000000000000008A) begin $display("E"); $finish; end
        i=0; i[9] = 1;
        #(`P);
        if(rc !== 64'h0000000000000088) begin $display("E"); $finish; end
        i=0; i[10] = 1;
        #(`P);
        if(rc !== 64'h0000000080008009) begin $display("E"); $finish; end
        i=0; i[11] = 1;
        #(`P);
        if(rc !== 64'h000000008000000A) begin $display("E"); $finish; end
        i=0; i[12] = 1;
        #(`P);
        if(rc !== 64'h000000008000808B) begin $display("E"); $finish; end
        i=0; i[13] = 1;
        #(`P);
        if(rc !== 64'h800000000000008B) begin $display("E"); $finish; end
        i=0; i[14] = 1;
        #(`P);
        if(rc !== 64'h8000000000008089) begin $display("E"); $finish; end
        i=0; i[15] = 1;
        #(`P);
        if(rc !== 64'h8000000000008003) begin $display("E"); $finish; end
        i=0; i[16] = 1;
        #(`P);
        if(rc !== 64'h8000000000008002) begin $display("E"); $finish; end
        i=0; i[17] = 1;
        #(`P);
        if(rc !== 64'h8000000000000080) begin $display("E"); $finish; end
        i=0; i[18] = 1;
        #(`P);
        if(rc !== 64'h000000000000800A) begin $display("E"); $finish; end
        i=0; i[19] = 1;
        #(`P);
        if(rc !== 64'h800000008000000A) begin $display("E"); $finish; end
        i=0; i[20] = 1;
        #(`P);
        if(rc !== 64'h8000000080008081) begin $display("E"); $finish; end
        i=0; i[21] = 1;
        #(`P);
        if(rc !== 64'h8000000000008080) begin $display("E"); $finish; end
        i=0; i[22] = 1;
        #(`P);
        if(rc !== 64'h0000000080000001) begin $display("E"); $finish; end
        i=0; i[23] = 1;
        #(`P);
        if(rc !== 64'h8000000080008008) begin $display("E"); $finish; end

        $display("SHA3-256 Round Constants Test Passed!");
        $finish;
    end
      
endmodule

`undef P