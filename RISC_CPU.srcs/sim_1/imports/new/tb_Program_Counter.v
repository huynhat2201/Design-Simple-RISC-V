`timescale 1ns / 1ps

module Program_Counter_tb;

    // Inputs
    reg clk;
    reg reset;
    reg load;
    reg iszero;
    reg [4:0] PC_LOAD;

    // Outputs
    wire [4:0] PC_out;

    // Instantiate the Unit Under Test (UUT)
    Program_Counter uut (
        .clk(clk),
        .reset(reset),
        .load(load),
        .iszero(iszero),
        .PC_LOAD(PC_LOAD),
        .PC_out(PC_out)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize inputs
        clk = 0;
        reset = 0;
        load = 0;
        iszero = 0;
        PC_LOAD = 5'b00000;

        // Monitor outputs
        $monitor("Time=%0t | reset=%b | load=%b | iszero=%b | PC_LOAD=%b | PC_out=%b", 
                 $time, reset, load, iszero, PC_LOAD, PC_out);

        // Test case 1: Reset PC
        #10 reset = 1;
        #10 reset = 0;

        // Test case 2: Increment PC by 1
        #10;
        
        // Test case 3: Load PC with a specific value
        PC_LOAD = 5'b10101;
        load = 1;
        #10 load = 0;

        // Test case 4: Conditional `iszero` behavior
        iszero = 1;   // Should jump or load value
        #10 iszero = 0;

        // Test case 5: Increment PC by 2 (iszero = 0)
        #20;

        // End simulation
        $stop;
    end
endmodule
