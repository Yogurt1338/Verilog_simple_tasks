
// Реализовать БИХ фильтр вида yk+1 = a * yk+b * xk+1. 
// Размерность x, a, b составляет 8 бит, знаковые целые числа. a, b известны заранее, в процессе работы не меняются. 
// Обосновать размерность результата.
// Данные на вход поступают каждый такт. Операция умножения занимает два такта.

#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>

#define DEBUG 0

typedef int8_t int8;
typedef int16_t int16;
typedef int32_t int24;

typedef struct {
    int8 buffer1;
    int8 buffer2;
    int8 buffer3;

    int24 temp_1;
    int24 temp_2;
    int24 temp_3;
    int24 temp_4;

    int24 result_reg;
    int8 a;
    int8 b;

    int16 ab;
    int24 a2b;
    int24 a3;

    int8 flag;
} Filter;

void filter_init(Filter* filter) {

    filter->a = 3;
    filter->b = -4;

    filter->ab = filter->a * filter->b;
    filter->a2b = filter->a * filter->a * filter->b;
    filter->a3 = filter->a * filter->a * filter->a;

    filter->buffer1 = 0;
    filter->buffer2 = 0;
    filter->buffer3 = 0;

    filter->result_reg = 0;
    filter->temp_1 = 0;
    filter->temp_2 = 0;
    filter->temp_3 = 0;
    filter->temp_4 = 0;

    filter->flag = 0;
}

void filter_update(Filter* filter, int8 data, bool data_en) {
    
    if (data_en || filter->flag) {
        filter->temp_1 = filter->b * data;
        filter->temp_2 = filter->ab * filter->buffer3;
        filter->temp_3 = filter->a2b * filter->buffer2;
        filter->temp_4 = filter->a3 * filter->buffer1;
        filter->result_reg = filter->temp_1 + filter->temp_2 + filter->temp_3 + filter->temp_4;
    }

    if (data_en) {
        filter->flag = 4;
    } else {
        if (filter->flag) {
            filter->flag -= 1;
        } else {
            filter->result_reg = 0;
        }
    }

    filter->buffer1 = filter->buffer2;
    filter->buffer2 = filter->buffer3;
    filter->buffer3 = data;

    #if DEBUG == 1
        printf("temp_1: %d, temp_2: %d, temp_3: %d, temp_4: %d\n", filter->temp_1, filter->temp_2, filter->temp_3, filter->temp_4);
    #endif
}

int24 filter_get_result(Filter* filter) {
    return filter->result_reg;
}

int main(void){

    Filter filter;
    filter_init(&filter);

    // Массив тестовых значений
    int8 test_values[] = {1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 5, 6, 7};
    size_t num_values = sizeof(test_values) / sizeof(test_values[0]);
    size_t i = 0;
    bool data_en = false;
    
    while (i < num_values + 3) {
        int8 data = test_values[i];
        data_en = (data == 0) ? false : true;

        filter_update(&filter, data, data_en);
        int24 result = filter_get_result(&filter);

        printf("Input: %d, Result: %d\n", data, result);

        i++;
    }

    return 0;
}