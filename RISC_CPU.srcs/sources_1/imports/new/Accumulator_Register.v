module Accumulator_Register (
    input clk,
    input reset,
    input LDA,
    input load_register,          // Tín hiệu load, khi load = 1 thì giá trị đầu vào sẽ ghi vào thanh ghi
    input acc_enable,             // Tín hiệu enable cho Accumulator
    input [7:0] data_in,          // Dữ liệu đầu vào 8-bit
    input [7:0] data_in2,         // Dữ liệu đầu vào 8-bit
    output reg [7:0] data_out     // Dữ liệu đầu ra 8-bit
);

    // Hoạt động khi có cạnh dương của clk hoặc tín hiệu reset
    always @(posedge clk or posedge reset) begin
        $display("ACCRES_PC");
        if (reset) begin
            data_out <= 8'b0000_0000;  // Đặt thanh ghi về 0 khi reset
        end else if (acc_enable) begin
            if (load_register) begin
                data_out <= data_in;       // Ghi giá trị data_in vào data_out khi load_register được bật
            end else if (LDA) begin
                data_out <= data_in2;      // Ghi giá trị data_in2 vào data_out khi LDA được bật
            end
        end
        // Nếu acc_enable = 0, giữ nguyên giá trị hiện tại của data_out
    end

endmodule
