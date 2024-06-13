// Реализовать модуль, который выводит на экран 4 последних уникальных значения из входного потока данных.
// Значения на выходе должны быть отсортированы по времени, прошедшему с момента их получения. 
// Активные выходы должны быть отмечены сигналом валидности.

module uniq(
    input clk,
    input signed [7:0] data_in,
    input data_en,

    output reg signed [7:0] out_1,
    output reg signed [7:0] out_2,
    output reg signed [7:0] out_3,  
    output reg signed [7:0] out_4,

    output reg val_1,
    output reg val_2,
    output reg val_3,
    output reg val_4
    );

    reg found = 0;

    initial begin
        val_1 = 0;
        val_2 = 0;
        val_3 = 0;
        val_4 = 0;
        out_1 = 0;
        out_2 = 0;
        out_3 = 0;
        out_4 = 0;
    end

    always @(posedge clk) begin
        if (data_en) begin
            found = 0;

            // Проверяем, есть ли входное значение уже среди выходов
            if (data_in == out_1) begin
                found = 1;
            end else if (data_in == out_2) begin
                found = 1;
                out_2 = out_1;
            end else if (data_in == out_3) begin
                found = 1;
                out_3 = out_2;
                out_2 = out_1;
            end else if (data_in == out_4) begin
                found = 1;
                out_4 = out_3;
                out_3 = out_2;
                out_2 = out_1;
            end

            // Если значение найдено, обновляем его позицию
            if (found) begin
                out_1 = data_in;
            end else begin
            // Сдвигаем все значения вправо и вставляем новое значение в out_1
                out_4 = out_3;
                out_3 = out_2;
                out_2 = out_1;
                out_1 = data_in;
            end

            // Обновляем сигналы валидности
            val_1 = (out_1 != 0) ? 1 : 0;
            val_2 = (out_2 != 0) ? 1 : 0;
            val_3 = (out_3 != 0) ? 1 : 0;
            val_4 = (out_4 != 0) ? 1 : 0;
        end
    end

endmodule
