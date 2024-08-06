#include "mbed.h"

DigitalOut En2(D7); DigitalOut Cs2(D6); PwmOut pwmw(D5); DigitalOut inA2(D4); DigitalOut inB2(D3);    //w
DigitalOut En1(D12); DigitalOut Cs1(D11); PwmOut pwmr(D10); DigitalOut inA1(D8); DigitalOut inB1(D9); //r

int count = 0;
int giros = 10;

void ccw(int motor) { // gira no sentido anti-horário
    if (motor == 1) { inA1 = 1; inB1 = 0; }
    else if (motor == 2) { inA2 = 1; inB2 = 0; }
}

void cw(int motor) { // gira no sentido horário
    if (motor == 1) { inA1 = 0; inB1 = 1; }
    else if (motor == 2) { inA2 = 0; inB2 = 1; }
}

int main()
{
    En1 = 1; En2 = 1;
    pwmw.period(0.0001);
    pwmr.period(0.0001);

    while (1)
    {
        while (count != giros)
        {
            cw(1); cw(2);
            pwmw.write(.5f); pwmr.write(.5f);
            count++; wait(.5);
        }

        pwmw.write(0); pwmr.write(0);
        wait(5);

        while (count != 0)
        {
            ccw(1); ccw(2);
            pwmw.write(.5f); pwmr.write(.5f);
            count--; wait(.5);
        }

        pwmw.write(0); pwmr.write(0);
        wait(5);
    }
}