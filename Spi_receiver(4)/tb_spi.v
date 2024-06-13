`timescale 1ns / 1ns

module tb_spi;

    // Входные сигналы
    reg sck = 0;
    reg cs = 1;
    reg copi = 0;
    
    // Выходные сигналы
    wire wr_en_out;
    wire [31:0] wr_data_out;
    wire [23:0] wr_address_out;

    integer i = 0;

    initial begin
        forever #5 sck = ~sck;
    end

    initial begin
        #5;
        cs = 1;
        copi = 0;
        #20;
        
        // Тест
        cs = 0;
        // Команда
        send_byte(8'hA4);
        // Адрес
        send_byte(8'h12);  
        send_byte(8'h34);
        send_byte(8'h56);
        // Данные
        send_byte(8'hDE);
        send_byte(8'hAD);
        send_byte(8'hBE);
        send_byte(8'hEF);
        cs = 1;

        #100;

        // Тест
        cs = 0;
        // Команда
        send_byte(8'hA1);
        // Адрес
        send_byte(8'h12);  
        send_byte(8'h34);
        send_byte(8'h56);
        // Данные
        send_byte(8'hDE);
        send_byte(8'hAD);
        send_byte(8'hBE);
        send_byte(8'hEF);
        cs = 1;
        
        #100;
        $finish;
    end

    // Процедура отправки байта
    task send_byte(input [7:0] byte);
        begin
            for (i = 7; i >= 0; i = i - 1) begin
                copi = byte[i];
                #10;
            end
        end
    endtask

    spi uut (
        .sck(sck),
        .cs(cs),
        .copi(copi),
        .wr_en_out(wr_en_out),
        .wr_data_out(wr_data_out),
        .wr_address_out(wr_address_out)
    );

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, tb_spi);
    end

endmodule
