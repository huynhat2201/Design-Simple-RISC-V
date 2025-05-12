`timescale 1ns / 1ps

module Program_Counter_ALU_tb;

    // Tín hiệu cho Program Counter
    reg clk;
    reg reset;
    reg load;
    //reg iszero;
    wire SKZ;
    reg [4:0] PC_LOAD;
    wire [4:0] PC_out;

    // Tín hiệu cho ALU
    reg [2:0] opcode;
    reg [7:0] inB;
    reg [7:0] accumulator;
    wire [7:0] ALU_result;
    wire is_zero;

    // Khởi tạo module Program Counter
    Program_Counter PC_inst (
        .clk(clk),
        .reset(reset),
        .load(load),
        .iszero(is_zero),
        .PC_LOAD(PC_LOAD),
        .PC_out(PC_out),
        .SKZ(SKZ)
    );

    // Khởi tạo module ALU
    ALU ALU_inst (
        .clk(clk),
        .opcode(opcode),
        .inB(inB),
        .accumulator(accumulator),
        .ALU_result(ALU_result),
        .is_zero(is_zero)
    );
    assign SKZ = (opcode == 3'b001) ? 1'b1 : 1'b0;
    // Tạo tín hiệu clock
    always #5 clk = ~clk; // Tín hiệu clock với chu kỳ 10ns
    // Dãy kiểm tra
    initial begin
        // Khởi tạo tín hiệu đầu vào
        clk = 0;
        reset = 1;
        load = 0;
        //iszero = 0;
        PC_LOAD = 5'b00000;
        opcode = 3'b010; // Mặc định ADD
        inB = 8'd0;
        accumulator = 8'd0;
        // Bật reset để khởi tạo Program Counter
        #10 reset = 0; // Tắt reset sau 10ns

        // Kiểm tra đầu tiên: ADD trong ALU và tăng Program Counter
        $display("Kiểm tra 1: ADD và tăng PC");
        opcode = 3'b010; // ADD
        accumulator = 8'd0; // Accumulator = 5
        inB = 8'd0; // Memory data = 10
        load = 0; // Không load PC, tăng dần
        PC_LOAD = 5'b00000; // Giá trị load nếu cần
        #10 // Đợi một chu kỳ clock
        $display("PC_out = %d, ALU_result = %d, is_zero = %b", PC_out, ALU_result, is_zero);

        // Kiểm tra thứ hai: AND trong ALU và nhảy (load) PC
        $display("Kiểm tra 2: SKZ và load PC");
        opcode = 3'b001; // SKZ
        accumulator = 8'b11001100; // Accumulator = 0xCC
        inB = 8'b10101010; // Memory data = 0xAA
        load = 0; // Load PC
        PC_LOAD = 5'b00101; // Tải giá trị vào PC
        #10 // Đợi một chu kỳ clock
        $display("PC_out = %d, ALU_result = %b, is_zero = %b", PC_out, ALU_result, is_zero);
         
         $display("Kiểm tra 2: SKZ và load PC");
        opcode = 3'b001; // SKZ
        accumulator = 8'b11001100; // Accumulator = 0xCC
        inB = 8'b10101010; // Memory data = 0xAA
        load = 0; // Load PC
        PC_LOAD = 5'b00101; // Tải giá trị vào PC
        #10 // Đợi một chu kỳ clock
        $display("PC_out = %d, ALU_result = %b, is_zero = %b", PC_out, ALU_result, is_zero);

        // Kiểm tra thứ ba: XOR trong ALU và kiểm tra is_zero
        $display("Kiểm tra 3: XOR và kiểm tra is_zero");
        opcode = 3'b010; // XOR
        accumulator = 8'b11110000; // Accumulator = 0xF0
        inB = 8'b11110000; // Memory data = 0xF0 (kết quả = 0)
        load = 0; // Không load PC
        #10; // Đợi một chu kỳ clock
        $display("PC_out = %d, ALU_result = %b, is_zero = %b", PC_out, ALU_result, is_zero);
        
//        $display("Kiểm tra 3: XOR và kiểm tra is_zero");
//        opcode = 3'b100; // XOR
//        accumulator = 8'b11110000; // Accumulator = 0xF0
//        inB = 8'b11110000; // Memory data = 0xF0 (kết quả = 0)
//        load = 0; // Không load PC
//        #10; // Đợi một chu kỳ clock
//        $display("PC_out = %d, ALU_result = %b, is_zero = %b", PC_out, ALU_result, is_zero);
        
//        // Kiểm tra lệnh SKZ
//        $display("Kiểm tra 5: SKZ (Skip if Zero)");
//        opcode = 3'b001; // SKZ;
//        accumulator = 8'd10; // Accumulator = 10
//        inB = -8'd10; // Giá trị trong bộ nhớ = -10, tổng = 0
//        #10; // Đợi một chu kỳ PC hoạt động

//        $display("PC_out = %d, ALU_result = %d, is_zero = %b", PC_out, ALU_result, is_zero);

//        // Trường hợp không bỏ qua lệnh nếu `is_zero` = 0
//        $display("Kiểm tra 6: Không bỏ qua nếu is_zero = 0");
//        opcode = 3'b010; // ADD
//        accumulator = 8'd10; // Accumulator = 10
//        inB = 8'd5; // Giá trị trong bộ nhớ = 5, tổng = 15
//        #10; // Đợi một chu kỳ ALU hoạt động
//        #10; // Đợi một chu kỳ PC hoạt động
        
        $display("PC_out = %d, ALU_result = %b, is_zero = %b", PC_out, ALU_result, is_zero);

        // Kết thúc mô phỏng
        $stop;
    end

endmodule
