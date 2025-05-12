module addr_mux(
    input [4:0] program_counter,       // 5-bit input from Program Counter
    input [4:0] operand_address_in,   // 5-bit input for Operand Address
    input mux_select,                 // Control signal to select input
    output reg [4:0] instruction_address, // Output to Instruction Memory
    output reg [4:0] operand_address_out, // Output to Data Memory
    input clk                         // Clock signal for synchronization
    );

    // Sử dụng xung clock để điều khiển sự thay đổi của các tín hiệu đầu ra
    always @(posedge clk) begin
      $display("run_MUX");
        if (!mux_select) begin
            //instruction_address <= 5'b00000;       // No active output to instruction memory
            operand_address_out = operand_address_in; // Select operand address
        end else begin
            instruction_address = program_counter;    // Select program counter
            //operand_address_out <= 5'b00000;       // No active output to operand memory
        end
    end

endmodule