module Program_Counter (
    input wire clk,                 // Clock signal to synchronize the counter
    input wire reset,               // Synchronous reset signal, active-high
    input wire pc_enable,           // Enable signal to update the program counter
    input wire iszero,              // Zero flag from the ALU
    input wire SKZ,                 // Skip-on-zero signal
    input wire JUMP,                // Jump signal
    input wire [4:0] PC_jump_addr,  // Target address for jump
    output reg [4:0] PC_out         // Program counter output value
);
    
    // Always block triggered on rising edge of clock or reset
    always @(posedge clk or posedge reset) begin
       $display("run_PC");
        if (reset) begin
            // Reset the program counter to 0
            PC_out <= 5'b00000;
        end else if (pc_enable) begin
            // If pc_enable is high, update the program counter
            $display("PC.v: pc_enable = %b, PC_out = %b", pc_enable, PC_out);

            if (SKZ && iszero) begin
                // Skip the next instruction if SKZ is high and the ALU result is zero
                PC_out = PC_out + 5'b00010;
            end else if (JUMP) begin
                // Jump to the specified address if JUMP is high
                PC_out <= PC_jump_addr;
            end else begin
                // Default increment by 1 for normal instruction execution
                PC_out = PC_out + 5'b00001;
            end
        end
        // If pc_enable is low, the program counter holds its value
    end

endmodule