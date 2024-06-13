#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <stdint.h>

void delay(int sec)
{
    int msec = (1000 * sec);
    clock_t start = clock();
    while (clock() < (start + msec))
    {
        ;
    }    
}
int state = 0;

int8_t a_real = 0, a_imag = 0, b_real = 0, b_imag = 0;
int16_t k1 = 0, k2 = 0, k3 = 0;
int16_t mult1 = 0, mult2 = 0, temp = 0;
int16_t res = 0, img = 0;
int16_t z_real = 0, z_imag = 0;

void multiply(){
    if (state == 1) {
        mult1 = a_real;
        mult2 = a_imag + b_imag;
    } else if (state == 2) {
        mult1 = b_imag;
        mult2 = a_real + b_real;
    } else if (state == 3) {
        mult1 = a_imag;
        mult2 = b_real - a_real;
    } else {
        mult1 = 0;
        mult2 = 0;
    }

temp = mult1 * mult2;
}

int update_result() {
switch (state) {
    case 1:
        k1 = temp;
        state = 2;
        return 0;
    case 2:
        k2 = temp;
        state = 3;
        return 0;
    case 3:
        k3 = temp;
        res = k1 - k2;
        img = k1 + k3;
        state = 1;
        return 0;
    default:
        break;
    }
    return 0;
}


int main() {
    
    state = 1;
    int counter = 0;

    while(1)
    {           
        if (counter > 10)
            exit(0);

        if (counter == 0){
            a_real = 1;
            a_imag = 2;
            b_real = 3; 
            b_imag = 4;
        }
        if (counter == 3){
            a_real = 2;
            a_imag = 4;
            b_real = 6; 
            b_imag = 8; 
        }
        if (counter == 6){
            a_real = 1;
            a_imag = 3;
            b_real = 5; 
            b_imag = 7; 
        }

        multiply();
        update_result();
                
        printf("Real = %d\n", res);
        printf("Img = %d\n", img);

        counter++;
        delay(50);
    }

    return 0;
}