`timescale 1ns / 1ns

module tb_filter();

reg clk = 0;
reg signed [7:0] data = 0;
reg signed [1:0] data_en = 0;
wire signed [17:0] result;

// Тактовый сигнал
initial
    forever #5 clk = ~clk;
    
initial
begin
    #5
    data_en <= 1;
    data <= 23;
    #10
    data <= 0;
    data_en <= 0;

    #90
    data_en <= 1;    
    data <= 1;
    #10
    data <= 0;
    data_en <= 0;
    
    #90
    data_en <= 1;    
    data <= 45;
    #10
    data <= 0;
    data_en <= 0;
    
    #90
    data_en <= 1;    
    data <= 11;
    #10
    data <= 0;
    data_en <= 0;

    #90
    data_en <= 1;    
    data <= 20;
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
