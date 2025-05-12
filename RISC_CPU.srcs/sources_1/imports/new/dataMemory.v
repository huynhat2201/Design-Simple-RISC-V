module dataMemory(
    input wire clk,                // Clock signal
    input wire [4:0] addr,         // 5-bit address bus
    inout wire [7:0] data,         // 8-bit bidirectional data bus
    input wire wr_en,              // Write enable signal
    input wire dmem_enable         // Enable data memory
);
    reg [7:0] mem [0:31];          // Define 32x8 memory
    reg [7:0] data_out;            // Register to hold read data
    
    // Initialize memory from external file
    initial begin
        $readmemb("data_init.mem", mem); // Load values from file
    end

    // Assign data bus for read/write operation
    assign data = (dmem_enable && !wr_en) ? data_out : 8'bz; // High impedance when not enabled or not reading

    always @(posedge clk) begin
        if (dmem_enable) begin
            $display("DMEM_ACTIVE");
            if (wr_en) begin
                // Write operation
                mem[addr] <= data;
            end else begin
                // Read operation
                data_out <= mem[addr];
            end
        end
    end
endmodule
