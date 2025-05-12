`timescale 1ns / 1ps

module tb_instructionMemory;

    // Inputs to Imemory
    reg clk;
    reg [4:0] addr;

    // Outputs from Imemory
    wire [7:0] instruct;

    // Instantiate the Imemory module
    instructionMemory uut (
        .clk(clk),
        .addr(addr),
        .instruct(instruct)
    );

    // Generate clock signal
    always begin
        #5 clk = ~clk;  // Toggle clk every 5ns (period = 10ns, frequency = 100MHz)
    end

    // Test procedure
    initial begin
        // Initialize Inputs
        clk = 0;
        addr = 5'b00000;  // Start from address 0

        // Monitor outputs
        $monitor("At time %t, addr = %d, instruct = %h", $time, addr, instruct);

        // Wait for some time
        #10;

        // Test reading from addresses 0 to 5
        addr = 5'b00000; // Address 0
        #10;
        addr = 5'b00001; // Address 1
        #10;
        addr = 5'b00010; // Address 2
        #10;
        addr = 5'b00011; // Address 3
        #10;
        addr = 5'b00100; // Address 4
        #10;
        addr = 5'b00101; // Address 5
        #10;

        // Test with more addresses
        addr = 5'b11111; // Test last address 31
        #10;

        // Finish simulation after testing
        $finish;
    end

endmodule