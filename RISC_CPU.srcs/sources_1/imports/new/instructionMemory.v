module instructionMemory(
    input wire       clk,
    input wire [4:0] addr,       // 5-bit address, supports 32 locations
    input wire imem_enable,
    output reg [7:0] instruct    // 8-bit instruction output
    );

    // Declare 8-bit memory with 32 entries
    reg [7:0] Imem[31:0];

    // Initialize memory from an external file
    initial begin
        $readmemb("instruction_file.mem", Imem); 
    end
    // Synchronous read logic
    always @(posedge clk) begin
        if (imem_enable==1) begin
                 $display("IM_PC");
                instruct <= Imem[addr];
        end
    end

endmodule
