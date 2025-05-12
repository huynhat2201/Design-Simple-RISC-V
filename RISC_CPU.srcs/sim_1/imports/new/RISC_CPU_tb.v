`timescale 1ns / 1ps

module RISC_CPU_tb;

    // Testbench signals
    reg clk;
    reg rst;

    // Outputs for observation
    wire [4:0] program_counter_out;
    wire [4:0] operand_address_out;
    wire [7:0] instruction;
    wire [2:0] opcode;
    wire [4:0] operand_address;
    wire [7:0] memory_data;
    wire [7:0] alu_result;
    wire is_zero;
    wire [7:0] accumulator_out;

    // Control signals
    wire pc_enable;
    wire mux_select;
    wire load_register;
    wire wr_en;
    wire load_ir;
    wire SKZ;
    wire JUMP;
    wire LDA;
    wire alu_enable;
    wire acc_enable;
    // Instantiate the RISC_CPU module
    // Instantiate the RISC_CPU module
    RISC_CPU uut (
        .clk(clk),
        .rst(rst),
        .program_counter_out(program_counter_out),
        .operand_address_out(operand_address_out),
        .instruction(instruction),
        .opcode(opcode),
        .operand_address(operand_address),
        .memory_data(memory_data),
        .alu_result(alu_result),
        .is_zero(is_zero),
        .accumulator_out(accumulator_out),
        .pc_enable(pc_enable),
        .mux_select(mux_select),
        .load_register(load_register),
        .wr_en(wr_en),
        .load_ir(load_ir),
        .SKZ(SKZ),
        .JUMP(JUMP),
        .LDA(LDA),
        .alu_enable(alu_enable),
        .acc_enable(acc_enable)
    );
    // Clock generation (10ns clock period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Clock with 10ns period
    end

    // Test sequence
    initial begin
        // Initialize reset
        rst = 1;      // Assert reset
        #15 rst = 0;  // Release reset after 15ns

        // Wait for a few clock cycles to observe CPU operation
        #1000; // Wait for 200ns to observe the behavior

        // Optionally you can modify the testbench to inject a few instructions here
        // Load instruction into memory using a predefined memory file or write some instructions manually.

        // Finish simulation after some time
        $finish;
    end
   
    // Monitor outputs
initial begin
    $monitor("Time: %0t | PC_out: %0d | Opcode: %b | Operand: %b | Instr: %h | Data_Mem: %h | ALU_Result: %0d | Accumulator: %0d | Is_Zero: %b | Wr_En: %b | Mux_Sel: %b | PC_En: %b | Load_Reg: %b | Load_IR: %b | SKZ: %b | JUMP: %b | LDA: %b | ALU_En: %b | Acc_En: %b",
             $time, 
             program_counter_out, opcode, operand_address, instruction, memory_data, 
             alu_result, accumulator_out, is_zero, wr_en, mux_select, pc_enable, 
             load_register, load_ir, SKZ, JUMP, LDA, alu_enable, acc_enable);
end


    // Initialize memory with test data (Optional)
    initial begin
        // Example: Load instructions into instruction memory
        // This requires a pre-generated instruction memory file
        // Uncomment the following line if you have an instruction file
        //$readmemb("instruction_file.mem", uut.IMEM.memory);

        // Example: Load data into data memory (Optional)
        // Uncomment the following line if you have a data memory file
        //$readmemb("data_file.mem", uut.DMEM.memory);

        $display("Memory initialized.");
    end

endmodule
