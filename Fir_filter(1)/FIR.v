module filter(
    input clk,
    input signed [7:0] data,
    input signed [1:0] data_en,
    output signed [17:0] result
    );
    
    reg [7:0] c1 = 1;
    reg [7:0] c2 = 2;
    reg [7:0] c3 = 3;

    reg [2:0] flag = 0;

    reg signed [17:0] result_reg = 0;
    reg signed [15:0] mult1 = 0;
    reg signed [15:0] mult2 = 0;
    reg signed [15:0] temp = 0;
    reg signed [17:0] result_temp = 0;

    reg signed [7:0] buffer1 = 0;
    reg signed [7:0] buffer2 = 0;
    reg signed [7:0] buffer3 = 0;


always @(posedge clk) 

// multiply data 
begin
mult1 <= flag == 1 ? c1 : 
	flag == 2 ? c2 : 
    flag == 3 ? c3 : 0;

mult2 <= flag == 1 ? buffer1 : 
	flag == 2 ? buffer2 : 
    flag == 3 ? buffer3 : 0;

temp <= mult1 * mult2;  
end

always @(posedge clk) 
begin

// save result 
case (flag)
    1:
    begin 
        flag <= 2;
        result_temp <= result_temp + temp;        
    end
    2:
    begin 
        flag <= 3;
        result_temp <= result_temp + temp;
    end
    3:
    begin 
        flag <= 4;
        result_temp <= result_temp + temp;
    end
    4:
    begin 
        flag <= 5;
        result_temp <= result_temp + temp;
    end
    5:
    begin 
        flag <= 0;
        result_reg <= result_temp + temp;
        result_temp <= 0;
    end
    default:
        ;
endcase

// write input data in buffer 
    if(data_en)
    begin 
        buffer1 <= buffer2;
        buffer2 <= buffer3;
        buffer3 <= data;
        flag <= 1;
    end
end

assign result = result_reg;
endmodule
