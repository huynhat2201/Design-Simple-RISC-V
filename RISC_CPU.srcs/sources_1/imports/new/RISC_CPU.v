module RISC_CPU (
    input wire clk,               // Clock signal
    input wire rst,               // Reset signal

    // Outputs for observation
    output wire [4:0] program_counter_out,  // Program Counter output
    output wire [4:0] operand_address_out,  // Operand Address output from addr_mux
    output wire [7:0] instruction,          // Instruction from Instruction Memory
    output wire [2:0] opcode,               // Opcode from Instruction Register
    output wire [4:0] operand_address,      // Operand address from Instruction Register
    output wire [7:0] memory_data,          // Data read from Data Memory
    output wire [7:0] alu_result,           // Result from ALU
    output wire is_zero,                    // Zero flag from ALU
    output wire [7:0] accumulator_out,      // Output from Accumulator Register

    // Control signals for observation
    output wire pc_enable,
    output wire mux_select,
    output wire load_register,
    output wire wr_en,
    output wire load_ir,
    output wire SKZ,
    output wire JUMP,
    output wire LDA,
    output wire alu_enable,
    output wire acc_enable
);

    // Internal wires and registers
    wire [4:0] instruction_address;    // Address for Instruction Memory
     wire [7:0] dmem_data; // Inout wire for DMEM
wire imem_enable;
    wire dmem_enable;
   // Memory data handling (inout)
    assign dmem_data = (wr_en) ? accumulator_out : 8'bz; // Write to DMEM
    assign memory_data = dmem_data;                      // Read from DMEM
    // Controller Module
    Controller CTRL (
        .clk(clk),
        .rst(rst),
        .opcode(opcode),               // Connect opcode from Instruction Register
        .pc_enable(pc_enable),
        .mux_select(mux_select),
        .wr_en(wr_en),
        .load_ir(load_ir),
        .load_register(load_register),
        .SKZ(SKZ),
        .JMP(JUMP),
        .LDA(LDA),
        .imem_enable(imem_enable),    // Instruction Memory enable
        .dmem_enable(dmem_enable),    // Data Memory enable
        .alu_enable(alu_enable),      // ALU enable
        .acc_enable(acc_enable)       // Accumulator enable
    );
    
    // Program Counter
    Program_Counter PC (
        .clk(clk),
        .reset(rst),
        .pc_enable(pc_enable),
        .PC_jump_addr(operand_address_out),
        .PC_out(program_counter_out),
        .iszero(is_zero),
        .SKZ(SKZ),
        .JUMP(JUMP)
    );
    
    // Address MUX
    addr_mux AMUX (
        .program_counter(program_counter_out),
        .operand_address_in(operand_address),
        .mux_select(mux_select),
        .instruction_address(instruction_address),
        .operand_address_out(operand_address_out),
        .clk(clk)
    );
    
    // Instruction Memory with enable
    instructionMemory IMEM (
        .clk(clk),  // Enable Instruction Memory
        .imem_enable(imem_enable),
        .addr(instruction_address),
        .instruct(instruction)
    );
    
    // Instruction Register
    Instruction_Register IR (
        .clk(clk),
        .rst(rst),
        .load_instruct(load_ir),
        .instruct_in(instruction),
        .opcode(opcode),
        .operand_address(operand_address)
    );
    
    // Data Memory with enable
    dataMemory DMEM (
        .clk(clk),
        .dmem_enable(dmem_enable),
        .addr(operand_address_out),
        .data(dmem_data), // accumulator out
        .wr_en(wr_en)
    );
    
    // ALU with enable
    ALU ALU (
        .clk(clk),   // Enable ALU
        .alu_enable(alu_enable),
        .opcode(opcode),
        .inB(memory_data),
        .accumulator(accumulator_out),
        .ALU_result(alu_result),
        .is_zero(is_zero)
    );
    
    // Accumulator Register with enable
    Accumulator_Register ACC (
        .clk(clk),   // Enable Accumulator Register
        .reset(rst),
        .acc_enable(acc_enable),
        .load_register(load_register),
        .LDA(LDA),
        .data_in(alu_result),
        .data_in2(memory_data),
        .data_out(accumulator_out)
    );

endmodule
