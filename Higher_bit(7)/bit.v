// Реализовать модуль, который находит позицию старшего единичного бита в входном числе.
// Пример – вход 8’b00100100, выход – 3’d5.

// а) Продемонстрировать, каким образом полученное решение масштабируется при
// неограниченном росте размерности входа (Достаточно показать на примере входа 32 или 64
// бита). Данные поступают каждый такт.

// б) Реализовать модуль, где ширина входных данных будет задаваться как параметр.


module bit #(parameter N = 8) (
    input clk,
    input [N-1:0] data,
    output reg [$clog2(N)-1:0] position
);

    integer i;
    reg state;

    initial begin
        position = 0;
        i = 0;
        state = 0;
    end

    always @(posedge clk) begin
        for (i = N-1; i >= 0; i = i - 1) begin
            if ((data[i] == 1) && (state == 0)) begin
                position = i;
                state = 1;
            end
        end
        if (state == 0) begin
            position = 0;
        end
        state <= 0; 
    end

endmodule
