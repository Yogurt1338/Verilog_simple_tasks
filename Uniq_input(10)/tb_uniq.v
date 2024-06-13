`timescale 1ns / 1ns

module tb_uniq;

    reg clk = 0;
    reg data_en = 0;
    reg signed [7:0] data_in = 0;

    wire signed [7:0] out_1;
    wire signed [7:0] out_2;
    wire signed [7:0] out_3;
    wire signed [7:0] out_4;
    wire val_1;
    wire val_2;
    wire val_3;
    wire val_4;

    // Тактовый сигнал
    initial begin
        forever #5 clk = ~clk;
    end

    initial begin

        #10
        data_en <= 1;
        data_in <= 1;

        #10
        data_in <= 2;       #10
        data_in <= 1;       #10
        data_in <= 2;       #10
        data_in <= 3;       #10
        data_in <= 4;       #10
        data_in <= 3;       #10
        data_in <= 2;       #10
        data_in <= 3;       #10
        data_in <= 4;       #10
        data_in <= 3;       #10
        data_in <= 4;       #10
        data_in <= 1;       #10
        data_in <= 2;       #10

        data_en <= 0;

        #100
        $finish;
    end

    uniq dut (
        .clk(clk),
        .data_in(data_in),
        .data_en(data_en),
        .out_1(out_1),
        .out_2(out_2),
        .out_3(out_3),
        .out_4(out_4),
        .val_1(val_1),
        .val_2(val_2),
        .val_3(val_3),
        .val_4(val_4)
    );

    initial
    begin
        $dumpfile("test.vcd");
        $dumpvars;
    end

endmodule
