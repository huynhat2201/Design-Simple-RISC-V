`timescale 1ns / 1ps

module tb_dataMemory;

    reg clk;
    reg [4:0] addr;
    reg write_en;
    wire [7:0] data;

    reg [7:0] data_in;       // Input driver for data bus
    wire [7:0] data_out;     // Output from memory

    // Bidirectional connection for data
    assign data = (write_en) ? data_in : 8'bz; // High impedance when not writing
    assign data_out = (write_en == 0) ? data : 8'bz;

    // Instantiate Dmemory module
    dataMemory uut (
        .clk(clk),
        .addr(addr),
        .data(data),
        .wr_en(write_en)
    );

    // Generate clock signal
    always begin
        #5 clk = ~clk;
    end

    initial begin
        // Initialize signals
        clk = 0;
        addr = 0;
        write_en = 0;
        data_in = 8'b0;

        $display("Time\tclk\twr_en\taddr\tdata_in\tdata_out");
        $monitor("%0t\t%b\t%b\t%0d\t%0h\t%0h", $time, clk, write_en, addr, data_in, data_out);

        // Write data to address 0
        #10;
        $display("Write to address 0");
        write_en = 1;
        addr = 5'b00000;
        data_in = 8'b10101010;  // Write value 0xAA
        #10;

        // Write data to address 1
        $display("Write to address 1");
        write_en = 1;
        addr = 5'b00001;
        data_in = 8'b11110000;  // Write value 0xF0
        #10;

        // Read data from address 0
        $display("Read from address 0");
        write_en = 0;
        addr = 5'b00000;
        #10;

        // Read data from address 1
        $display("Read from address 1");
        write_en = 0;
        addr = 5'b00001;
        #10;

        $finish;
    end

endmodule