`timescale 1ns/1ps

module Controller_tb;

    // Inputs
    reg clk;
    reg rst;
    reg [2:0] opcode;
    reg is_zero;

    // Outputs
    wire pc_enable;
    wire mux_select;
    wire load_ir;
    wire SKZ;
    wire wr_en;
    wire LDA;
    wire load_register;
    wire JMP;
    wire imem_enable;
    wire dmem_enable;
    wire alu_enable;
    wire acc_enable;

    // Internal signals
    wire [3:0] state; // FSM state
    localparam INIT          = 4'b0000,
               FETCH         = 4'b0001,
               ALU           = 4'b0010,
               LOAD_ACC      = 4'b0011,
               WRITE_BACK    = 4'b0100,
               MEM_READ      = 4'b0101,
               LOAD_IR_DECODE = 4'b0110,
               SKIP          = 4'b0111,
               JUMP          = 4'b1000;

    // Instantiate the Controller module
    Controller uut (
        .clk(clk),
        .rst(rst),
        .opcode(opcode),
        .is_zero(is_zero),
        .pc_enable(pc_enable),
        .mux_select(mux_select),
        .load_ir(load_ir),
        .SKZ(SKZ),
        .wr_en(wr_en),
        .LDA(LDA),
        .load_register(load_register),
        .JMP(JMP),
        .imem_enable(imem_enable),
        .dmem_enable(dmem_enable),
        .alu_enable(alu_enable),
        .acc_enable(acc_enable)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns clock period
    end

    // Test sequence
    initial begin
        // Initialize inputs
        rst = 1;
        opcode = 3'b000; // Default opcode
        is_zero = 0;

        // Apply reset
        #20;
        rst = 0;

        // Test LDA opcode (3'b101)
        $display("Test LDA opcode (3'b101)");
        opcode = 3'b101;
        wait_for_state(MEM_READ);
        wait_for_state(LOAD_ACC);
        wait_for_state(FETCH);
        $display("LDA operation completed\n");

        // Test STO opcode (3'b110)
        $display("Test STO opcode (3'b110)");
        opcode = 3'b110;
        wait_for_state(MEM_READ);
        wait_for_state(WRITE_BACK);
        wait_for_state(FETCH);
        $display("STO operation completed\n");

        // Test SKZ opcode (3'b001)
        $display("Test SKZ opcode (3'b001)");
        opcode = 3'b001;
        is_zero = 1; // Set is_zero flag
        wait_for_state(FETCH);
        $display("SKZ operation completed\n");

        // Test JMP opcode (3'b111)
        $display("Test JMP opcode (3'b111)");
        opcode = 3'b111;
        wait_for_state(JUMP);
        wait_for_state(FETCH);
        $display("JMP operation completed\n");

        // Test ALU operation (3'b010)
        $display("Test ALU opcode (3'b010)");
        opcode = 3'b010;
        wait_for_state(MEM_READ);
        wait_for_state(ALU);
        wait_for_state(LOAD_ACC);
        wait_for_state(FETCH);
        $display("ALU operation completed\n");

        // Finish simulation
        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("Time=%0t | State=%b | opcode=%b | pc_enable=%b | mux_select=%b | load_ir=%b | SKZ=%b | wr_en=%b | LDA=%b | JMP=%b | alu_enable=%b | acc_enable=%b", 
                 $time, uut.state, opcode, pc_enable, mux_select, load_ir, SKZ, wr_en, LDA, JMP, alu_enable, acc_enable);
    end

    // Define states as parameters for easier reference
    
    // Task to wait for a specific state with timeout
    task wait_for_state(input [3:0] target_state);
        integer timeout;
        timeout = 1000; // Set timeout limit (1000 clock cycles)
        while (uut.state != target_state && timeout > 0) begin
            @(posedge clk);
            timeout = timeout - 1;
        end
        if (timeout == 0) begin
            $display("ERROR: Timeout while waiting for state %b at time %0t", target_state, $time);
            $stop;
        end
    endtask

endmodule
