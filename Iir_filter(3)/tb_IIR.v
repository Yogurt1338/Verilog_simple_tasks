`timescale 1ns / 1ns

module tb_filter();

reg clk = 0;
reg signed [15:0] data = 0;
reg signed [1:0] data_en = 0;
wire signed [23:0] result;

// Тактовый сигнал
initial
    forever #5 clk = ~clk;
    
initial
begin
    #5
    data_en <= 1;
    data <= 1;
    #10
    data <= 0;
    data_en <= 0;

    data_en <= 1;    
    data <= 2;
    #10
    data <= 0;
    data_en <= 0;
    
    data_en <= 1;    
    data <= 3;
    #10
    data <= 0;
    data_en <= 0;
    
    data_en <= 1;    
    data <= 4;
    #10
    data <= 0;
    data_en <= 0;

    #80

    data_en <= 1;    
    data <= 1;
    #10
    data <= 0;
    data_en <= 0;

    data_en <= 1;    
    data <= 2;
    #10
    data <= 0;
    data_en <= 0;

    data_en <= 1;    
    data <= 3;
    #10
    data <= 0;
    data_en <= 0;

    data_en <= 1;    
    data <= 4;
    #10
    data <= 0;
    data_en <= 0;


    data_en <= 1;    
    data <= 5;
    #10
    data <= 0;
    data_en <= 0;

    data_en <= 1;    
    data <= 6;
    #10
    data <= 0;
    data_en <= 0;

    data_en <= 1;    
    data <= 7;
    #10
    data <= 0;
    data_en <= 0;

    #100
    $finish;
end

filter dut (
    .clk(clk),
    .data_en(data_en),
    .data(data),
    .result(result)
);

initial
begin
    $dumpfile("test.vsd");
    $dumpvars;
end

endmodule