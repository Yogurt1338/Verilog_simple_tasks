`timescale 1ns / 1ns

module tb_bit;
    // Входные сигналы
    reg clk = 0;
    reg [N-1:0] data;
    
    // Выходные сигналы
    wire [$clog2(N)-1:0] position;

    // Параметры
    parameter N = 32;  // Ширина входных данных

    initial begin
        forever #5 clk = ~clk;
    end

    initial begin
        data = 0;
        #5
        data = 8'b10100100;
        #10;
        data = 8'b01100100;
        #10;
        data = 8'b00100100;
        #10;
        data = 8'b00010001;
        #10;
        data = 8'b00001000;
        #10;
        data = 8'b00000000;
        #10;
        data = 8'b01100100;
        #10;
        data = 8'b00100100;
        #20;
        data = 0;

        #20;
        data = 16'b1001000100010001;
        #10;
        data = 16'b0100100000010001;
        #10;
        data = 16'b0010000000010001;
        #10;
        data = 16'b0000000000000000;
        #20;
        data = 0;

        #20;
        data = 32'b10010001000100010010000000010001;
        #10;
        data = 32'b01001000000100010010000000010001;
        #10;
        data = 32'b00100000000100010010000000010001;
        #20;
        data = 0;

        #100; 
        $finish;
    end

    bit #(.N(N)) uut (
        .clk(clk),
        .data(data),
        .position(position)
    );

    initial begin
        $dumpfile("test.vcd");
        $dumpvars;
    end

endmodule
