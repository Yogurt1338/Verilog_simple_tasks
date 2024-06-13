#include <stdio.h>
#include <time.h>
#include <stdlib.h>

void delay(int sec)
{
    int msec = (1000 * sec);
    clock_t start = clock();
    while (clock() < (start + msec))
    {
        ;
    }    
}

char c1 = 1;
char c2 = 2;
char c3 = 3;
char call = 0;

int flag = 0;
int array[5] = {23, 01, 45, 11, 20};
int mult1 = 0, mult2 = 0, temp = 0;
int buffer1 = 0, buffer2 = 0, buffer3 = 0;
int result_temp = 0;
int result = 0;

void multiply(){
    if (flag == 1) {
        mult1 = c1;
        mult2 = buffer1;
    } else if (flag == 2) {
        mult1 = c2;
        mult2 = buffer2;
    } else if (flag == 3) {
        mult1 = c3;
        mult2 = buffer3;
    } else {
        mult1 = 0;
        mult2 = 0;
    }

temp = mult1 * mult2;
}

void move(
    int *buffer1, int *buffer2, int *buffer3, int counter) {
    
    *buffer1 = *buffer2;
    *buffer2 = *buffer3;
    *buffer3 = array[counter];

    flag = 1;

    if (counter > 4)
        exit(0);
}

void update_result() {
    switch (flag) {
        case 1:
            flag = 2;
            result_temp += temp;
            break;
        case 2:
            flag = 3;
            result_temp += temp;
            break;
        case 3:
            flag = 4;
            result_temp += temp;
            break;
        case 4:
            flag = 5;
            result_temp += temp;
            break;
        case 5:
            flag = 0;
            result = result_temp + temp;
            result_temp = 0;
            break;
        default:
            break;
    }
}

int main()
{
    char counter = 0;
    int i = 0;

    while(1)
    {   
        if (i == 10)
        {
            move(&buffer1, &buffer2, &buffer3, counter);
            i = 0;
            counter++;
        }
        i++;

        multiply();
        update_result();
        printf("%d\n", result);

        delay(50);
    }

return 0;
}
