// Реализовать физический уровень приемника SPI Peripheral с поддержкой операции записи.
// SPI интерфейс содержит 4 провода – SCK, CS, COPI, CIPO.

// Команда      Адрес       Данные
// 7... 0      23...0       31...0

// Команда записи может быть любая фиксированная. 
// Все остальные значения этого поля необходимо игнорировать.

module spi (
    input wire sck,
    input wire cs,
    input wire copi,
    output wire wr_en_out,
    output wire [31:0] wr_data_out,
    output wire [23:0] wr_address_out
);

    parameter WRITE_COMMAND = 8'hA1;  // команда записи

    reg [7:0] command;
    reg [23:0] address;
    reg [31:0] data;
    reg [5:0] bit_count;
    reg [31:0] reg_wr_data_out;
    reg [23:0] reg_wr_address_out;
    reg reg_wr_en_out;
    reg state;

    initial begin
        data = 0;
        command = 0;
        address = 0;
        bit_count = 0;
        reg_wr_data_out = 0;
        reg_wr_address_out = 0;
        reg_wr_en_out = 0;
        state = 0;
    end

    always @(posedge sck or posedge cs) begin
        if (cs) begin // CS
            state <= 0;
            bit_count <= 0;
            reg_wr_en_out <= 0;
        end else begin

            // Прием данных по SPI
            if (state == 0) begin
                // команда
                command[7 - bit_count] <= copi;
                bit_count <= bit_count + 1;
                
                if (bit_count == 7) begin
                    state <= 1;
                    bit_count <= 0;
                end
            
            end else if (state == 1) begin
                
                if (command == WRITE_COMMAND) begin
                    
                    if (bit_count < 24) begin
                        // адрес
                        address[23 - bit_count] <= copi;
                    end else if (bit_count < 56) begin
                        // данные
                        data[55 - bit_count] <= copi;
                    end
                    
                    bit_count <= bit_count + 1;

                    if (bit_count == 55) begin
                        reg_wr_en_out <= 1;
                        reg_wr_address_out <= address;
                        reg_wr_data_out <= data;
                    end
                end
            end
        end
    end

    // Сброс сигнала при опускании cs
    always @(negedge cs) begin
        reg_wr_en_out <= 0;
    end

    assign wr_en_out = reg_wr_en_out;
    assign wr_address_out = reg_wr_address_out;
    assign wr_data_out = reg_wr_data_out;

endmodule
