
// Реализовать БИХ фильтр вида y[k+1] = a * y[k]+b * x[k+1]. 
// Размерность x, a, b составляет 8 бит, знаковые целые числа. 
// a, b известны заранее, в процессе работы не меняются. Обосновать размерность результата.
// Данные на вход поступают каждый такт. Операция умножения занимает два такта.

// y[k+1] = a * y[k] + b * x[k+1]
// y[n] = a * y[n-1] + b * x[n]

// y[n-1] = a * y[n-2] + b * x[n-1]
// y[n] = a * (a * y[n-2] + b * x[n-1]) + b * x[n] 
//      = a^2 * y[n-2] + a * b * x[n-1] + b * x[n]

// y[n-2] = a * y[n-3] + b * x[n-2]
// y[n] = a^2 * (a * y[n-3] + b * x[n-2]) + a * b * x[n-1] + b * x[n]
//      = a^3 * y[n-3] + a^2 * b * x[n-2] + a * b * x[n-1] + b * x[n]

// y[n] = b*x[n] + a*b*x[n-1] + a^2*b*x[n-2] + a^3*y[n-3]

// a = 3        -   8 бит
// b = -4       -   8 бит
// a*b = -12    -   16 бит
// a^2*b = -36  -   24 бит
// a^3 = 27     -   24 бит

// y[n] = -4*x[n] + -12*x[n-1] + -36*x[n-2] + 27*y[n-3]

`timescale 1ns/1ns
module filter (
    input clk,
    input signed [7:0] data,
    input signed [1:0] data_en,
    output signed [15:0] result
);

    reg signed [7:0] buffer1 = 0;
    reg signed [7:0] buffer2 = 0;
    reg signed [7:0] buffer3 = 0;
	reg signed [17:0] result_reg = 0;

	reg signed [7:0] a = 3;
    reg signed [7:0] b = -4;
    
	wire signed [15:0] ab = a * b;
	wire signed [23:0] a2b = a * a * b;
	wire signed [23:0] a3 = a * a * a;

    reg signed [23:0] temp_1 = 0;
    reg signed [23:0] temp_2 = 0;
    reg signed [23:0] temp_3 = 0;
    reg signed [23:0] temp_4 = 0;

	reg [2:0] state = 0;
    reg [3:0] flag = 0;
    reg signed [23:0] temp = 0;
    reg signed [23:0] y_reg = 0;

always @(posedge clk) begin
    buffer1 <= buffer2;
    buffer2 <= buffer3;
    buffer3 <= data;  
end

always @(posedge clk) begin
    if (data_en || flag) begin
        temp_1 <= b * data;
        temp_2 <= ab * buffer3;
        temp_3 <= a2b * buffer2;
        temp_4 <= a3 * buffer1;
        result_reg <= temp_1 + temp_2 + temp_3 + temp_4;
    end
end

always @(posedge clk) begin
    if (data_en) begin
        flag <= 4;
    end

    if (! data_en) begin
        if (flag) begin
            flag <= flag - 1;
        end else begin
            result_reg <= 0;
        end
    end
end

assign result = result_reg;
endmodule
