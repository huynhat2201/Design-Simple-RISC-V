module Controller(
    input wire clk,                 // Clock
    input wire rst,                 // Reset đồng bộ
    input wire [2:0] opcode,        // Opcode từ Instruction Register
    //input wire is_zero,             // Tín hiệu Zero từ ALU
    output reg pc_enable,           // Điều khiển Program Counter
    output reg mux_select,          // Điều khiển Address Mux
    output reg load_ir,             // Điều khiển nạp Instruction Register
    output reg SKZ,
    output reg wr_en,
    output reg LDA,
    output reg load_register,
    output reg JMP,
    output reg imem_enable,         // Enable tín hiệu cho Instruction Memory
    output reg dmem_enable,         // Enable tín hiệu cho Data Memory
    output reg alu_enable,          // Enable tín hiệu cho ALU
    output reg acc_enable           // Enable tín hiệu cho Accumulator
);

    // Định nghĩa trạng thái
    reg [3:0] state;
    localparam INIT        = 4'b0000,
               FETCH       = 4'b0001,
               ALU         = 4'b0010,
               LOAD_ACC     = 4'b0011,
               WRITE_BACK  = 4'b0100,
               MEM_READ    = 4'b0101,
               LOAD_IR_DECODE = 4'b0110,
               SKIZ = 4'b0111,
               JUMP = 4'b1000,
               NEED_OPCODE = 4'b1001;
               



    // Chuyển trạng thái và logic điều khiển
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset state và các tín hiệu điều khiển
            state <= INIT;
            pc_enable <= 0;
            mux_select <= 0;
            wr_en <= 0;
            load_ir <= 0;
            load_register <= 0;
            SKZ <= 0;
            JMP <= 0;
            imem_enable <= 1;
            dmem_enable <= 1;
            alu_enable <= 0;
            acc_enable <= 0;
            LDA <=0;
            $display("State: INIT (Reset)");
        end else begin
            // FSM logic
            case (state)
                INIT: begin
                    // prepare for FETCH
                    pc_enable <= 0;
                    mux_select <= 1;
                    imem_enable <= 1;
                    dmem_enable <= 1;
                    alu_enable <= 0;
                    acc_enable <= 0;
                    load_ir <= 1;
                    state <= FETCH;
                    $display("State: INIT");
                end

                FETCH: begin
                    // prepare for LOAD_IR
                    pc_enable <= 0;
                    mux_select <= 0;
                    imem_enable <= 1;
                    load_ir <= 1;
                    dmem_enable <= 1;
                    alu_enable <= 0;
                    acc_enable <= 0;
                    load_register <=0;
                    LDA<=0;
                    state <= LOAD_IR_DECODE;
                    wr_en <= 0;
                    
                    $display("State: FETCH");
                end
                LOAD_IR_DECODE: begin
                    // PREPARE FOR ANOTHER STATE
                    $display("State: LOAD_IR_DECODE");
                    case (opcode)
                       
                         3'b000: begin
                            $finish;
                        end
                        default: begin  // include ADD, XOR, AND, LDA, JMP, STO
                        // prepare for MEM_READ
                        pc_enable <= 0;
                        mux_select <= 0;
                        imem_enable <= 1;
                        load_ir <= 1;
                        dmem_enable <= 1;
                        alu_enable <= 0;
                        acc_enable <= 0;
                        state <= NEED_OPCODE; // Other operations
                        end
                    endcase
                
                end
                NEED_OPCODE: begin

                    case (opcode)
                       
                         3'b000: begin
                            $finish;
                        end
                        default: begin  // include ADD, XOR, AND, LDA, JMP, STO
                        // prepare for MEM_READ
                        pc_enable <= 0;
                        mux_select <= 0;
                        imem_enable <= 1;
                        load_ir <= 1;
                        dmem_enable <= 1;
                        alu_enable <= 0;
                        acc_enable <= 0;
                        state <= MEM_READ; // Other operations
                        end
                    endcase
                end
                 MEM_READ: begin
                    // Prepare for ALU or LDA or JMP or STO
                    case (opcode)
                        3'b001: begin // SKZ
                        state <= SKIZ;
                            pc_enable <= 1;
                            mux_select <= 1;
                            imem_enable <= 1;
                            dmem_enable <= 1;
                            alu_enable <= 0;
                            acc_enable <= 0;
                            load_ir <= 1;
                            wr_en <= 0;
                         
                            load_register <= 0;
                            SKZ = 1; // Skip if zero
                            $display("Opcode: SKZ (Skip if zero)");
                        end
                        3'b101: begin // LDA
                        pc_enable <= 0;
                        mux_select <= 0;
                        imem_enable <= 1;
                        load_ir <= 1;
                        LDA <= 0;
                        dmem_enable <= 1;
                        alu_enable <= 1;
                        acc_enable <= 0;
                        state <= ALU;
                        end
                        3'b110: begin // STO
                            state <= WRITE_BACK;
                            pc_enable <= 0;
                            mux_select <= 0;
                            imem_enable <= 1;
                            load_ir <= 1;
                            dmem_enable <= 1;
                            alu_enable <= 0;
                            acc_enable <= 1;
                            wr_en <= 1;
                        end
                        3'b111: begin // JMP
                            state <= JUMP;
                            pc_enable <= 1;
                            mux_select <= 0;
                            imem_enable <= 1;
                            load_ir <= 1;
                            dmem_enable <= 1;
                            alu_enable <= 0;
                            acc_enable <= 0;
                            wr_en <= 0;
                            JMP <= 1;
                        end
                        default: begin // relate to calculate ALU
                            state <= ALU;
                            pc_enable <= 0;
                            mux_select <= 0;
                            imem_enable <= 1;
                            load_ir <= 1;
                            dmem_enable <= 0;
                            alu_enable <= 0;
                            acc_enable <= 0;
                        end
                    endcase
                    $display("MEM_READ");
                end
                ALU: begin
                    state <= LOAD_ACC;
                    pc_enable <= 0;
                    mux_select <= 0;
                    imem_enable <= 1;
                    load_ir <= 1;
                    dmem_enable <= 1;
                    alu_enable <= 1;
                    acc_enable <= 0;
                    load_register <=0;
                    $display("ALU");
                end
                LOAD_ACC: begin
                    

                    // AND ADD XOR LDA
                    pc_enable <= 1;
                    mux_select <= 1;
                    imem_enable <= 0;
                    dmem_enable <= 1;
                    alu_enable <= 0;
                    acc_enable <= 1;
                    state <= FETCH;
                   case(opcode) 
                    3'b101: begin
                    LDA<=1;
                    end
                    default: begin
                      load_register <= 1;  
                    end

                    endcase
                    
                    $display("State: LOAD_ACC");
                end

                WRITE_BACK: begin
                    // Kích hoạt ghi dữ liệu hoặc cập nhật trạng thái cuối cùng
                    pc_enable <= 1;
                    mux_select <= 1;
                    imem_enable <= 0;
                    dmem_enable <= 1;
                    alu_enable <= 0;
                    acc_enable <= 0;
                    load_register <= 0;
                    state <= FETCH; // Quay lại FETCH
                    $display("State: WRITE_BACK");
                end
                JUMP: begin
                    state <= FETCH;
                    pc_enable <= 0;
                    mux_select <= 1;
                    imem_enable <= 1;
                    load_ir <= 1;
                    dmem_enable <= 1;
                    alu_enable <= 0;
                    acc_enable <= 0;
                    wr_en <= 0;
                    JMP <= 0;
                    $display("State: JUMP");
                end
                SKIZ: begin
                    state <= FETCH;
                    pc_enable <= 0;
                    mux_select <= 1;
                    imem_enable <= 1;
                    load_ir <= 1;
                    dmem_enable <= 1;
                    alu_enable <= 0;
                    acc_enable <= 0;
                    wr_en <= 0;
                    SKZ <= 0;
                    $display("State: SKZ");
                end
                default: begin
                    state <= INIT; // Trạng thái an toàn
                    $display("State: DEFAULT (Unknown State)");
                end
            endcase
        end
    end
endmodule
