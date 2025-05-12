`timescale 1ns / 1ps

module tb_Instruction_Register;

    // Testbench signals
    reg clk;
    reg rst;
    reg load_instruct;
    reg [7:0] instruct_in;
    wire [2:0] opcode;
    wire [4:0] operand_address;

    // Instantiate the Instruction_Register module
    Instruction_Register uut (
        .clk(clk),
        .rst(rst),
        .load_instruct(load_instruct),
        .instruct_in(instruct_in),
        .opcode(opcode),
        .operand_address(operand_address)
    );

    // Generate clock signal
    always begin
        #5 clk = ~clk;  // 10 time unit clock period
    end

    // Stimulus
    initial begin
        // Initialize signals
        clk = 0;
        rst = 0;
        load_instruct = 0;
        instruct_in = 8'b00000000;

        // Test 1: Reset the register
        $display("Test 1: Resetting the register");
        rst = 1; #10;
        rst = 0; #10;

        // Test 2: Load instruction with opcode = 3'b101 and operand_address = 5'b01100
        $display("Test 2: Load instruction with opcode = 101 and operand_address = 01100");
        instruct_in = 8'b10101100;
        load_instruct = 1; #10;
        load_instruct = 0; #10;

        // Test 3: Change input but don't load (check if the output retains the old value)
        $display("Test 3: Change input but don't load (output should retain previous values)");
        instruct_in = 8'b11111111; #10;

        // Test 4: Load new instruction with opcode = 3'b010 and operand_address = 5'b10010
        $display("Test 4: Load new instruction with opcode = 010 and operand_address = 10010");
        instruct_in = 8'b01010010;
        load_instruct = 1; #10;
        load_instruct = 0; #10;

        // Test 5: Reset again
        $display("Test 5: Resetting the register");
        rst = 1; #10;
        rst = 0; #10;

        // Finish the simulation
        $finish;
    end

    // Monitor the outputs
    initial begin
        $monitor("At time %t, rst = %b, load_instruct = %b, instruct_in = %b, opcode = %b, operand_address = %b", 
                 $time, rst, load_instruct, instruct_in, opcode, operand_address);
    end

endmodule
