`timescale 1ns / 1ps

module Accumulator_Register_tb;

    // Inputs
    reg clk;
    reg reset;
    reg LDA;
    reg load_register;
    reg [7:0] data_in;
    reg [7:0] data_in2;

    // Output
    wire [7:0] data_out;

    // Instantiate the Unit Under Test (UUT)
    Accumulator_Register uut (
        .clk(clk),
        .reset(reset),
        .LDA(LDA),
        .load_register(load_register),
        .data_in(data_in),
        .data_in2(data_in2),
        .data_out(data_out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Test sequence
    initial begin
        // Initialize inputs
        reset = 1;
        LDA = 0;
        load_register = 0;
        data_in = 8'h00;
        data_in2 = 8'h00;

        // Apply reset
        #10;
        reset = 0;
        $display("Reset released. data_out=%h", data_out);

        // Test load_register
        #10;
        load_register = 1;
        data_in = 8'h55; // Example value
        #10;
        load_register = 0;
        $display("Loaded data_in. data_out=%h", data_out);

        // Test LDA
        #10;
        LDA = 1;
        data_in2 = 8'hAA; // Example value
        #10;
        LDA = 0;
        $display("Loaded data_in2 via LDA. data_out=%h", data_out);

        // Keep current value
        #10;
        $display("Hold data_out. data_out=%h", data_out);

        // Reset again
        #10;
        reset = 1;
        #10;
        reset = 0;
        $display("Reset performed. data_out=%h", data_out);

        // Test multiple signals
        #10;
        load_register = 1;
        data_in = 8'hFF;
        LDA = 1;
        data_in2 = 8'hBB;
        #10;
        load_register = 0;
        LDA = 0;
        $display("Loaded both signals. data_out=%h", data_out);

        // Finish simulation
        #20;
        $finish;
    end

    // Monitor the data_out signal
    initial begin
        $monitor("Time=%0t | clk=%b | reset=%b | load_register=%b | LDA=%b | data_in=%h | data_in2=%h | data_out=%h",
                 $time, clk, reset, load_register, LDA, data_in, data_in2, data_out);
    end

endmodule
