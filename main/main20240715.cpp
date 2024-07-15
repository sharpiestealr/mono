#include "mbed.h"
#include "math.h"
#include "MPU6050.h"
#include "HMC5883L.h"
#include "CalibrateMagneto.h"
#include "math.h"

#define dt 0.1f
#define Kp 2.0f
#define Ki 0.01f
#define pi 3.141592653589793f
#define gyroConv 1.3323e-04f
#define magConv 3.1746e-04f
#define accConv 5.9815e-04f
#define rad2deg 57.295779513082323f

I2C i2c(PTE25, PTE24);
HMC5883L mag(PTE25, PTE24);
CalibrateMagneto calib;
MPU6050 mpu;
Ticker tick;
Serial pc(USBTX, USBRX);

// Variaveis do programa
float phi = 0.0;
float theta = 0.0;
float psi = 0.0;
int N = 0;
const int tempo = 60 / dt;
float vec1[tempo], vec2[tempo], vec3[tempo];

// Variaveis acelerometro e gyroscopio
int16_t ax, ay, az;
int16_t gx, gy, gz;
double pitch = 0.0, roll = 0.0;

int aux;

// Variaveis do Filtro de Kalman
double anglePitch = 0.0, angleRoll = 0.0;
float accAnglePitch = 0.0, accAngleRoll = 0.0;
double gyroRatePitch = 0.0, gyroRateRoll = 0.0;
double biasPitch = 0.0, biasRoll = 0.0;
double P_00Pitch = 0.0, P_01Pitch = 0.0, P_10Pitch = 0.0, P_11Pitch = 0.0;
double P_00Roll = 0.0, P_01Roll = 0.0, P_10Roll = 0.0, P_11Roll = 0.0;
double K_0, K_1;
double y, Sk;

double gyroBias = 0.0;
double bias = 0.0;

// Variaveis de calibração
float zeroValues[5] = { 0,0,0,0,0 };

/* Kalman filter variables and constants */
const double Q_angle = 0.001;
const double Q_gyro = 0.003;
const double R_angle = 0.03;

double kalmanPitch(double newAnglePitch, double newRatePitch) {
    anglePitch += dt * (newRatePitch - biasPitch);

    P_00Pitch += -dt * (P_10Pitch + P_01Pitch) + Q_angle * dt;
    P_01Pitch += -dt * P_11Pitch;
    P_10Pitch += -dt * P_11Pitch;
    P_11Pitch += +Q_gyro * dt;

    Sk = P_00Pitch + R_angle;
    K_0 = P_00Pitch / Sk;
    K_1 = P_10Pitch / Sk;

    y = newAnglePitch - anglePitch;
    anglePitch += K_0 * y;
    biasPitch += K_1 * y;

    P_00Pitch -= K_0 * P_00Pitch;
    P_01Pitch -= K_0 * P_01Pitch;
    P_10Pitch -= K_1 * P_00Pitch;
    P_11Pitch -= K_1 * P_01Pitch;

    return anglePitch;
}

double kalmanRoll(double newAngleRoll, double newRateRoll) {
    angleRoll += dt * (newRateRoll - biasRoll);

    P_00Roll += -dt * (P_10Roll + P_01Roll) + Q_angle * dt;
    P_01Roll += -dt * P_11Roll;
    P_10Roll += -dt * P_11Roll;
    P_11Roll += +Q_gyro * dt;

    Sk = P_00Roll + R_angle;
    K_0 = P_00Roll / Sk;
    K_1 = P_10Roll / Sk;

    y = newAngleRoll - angleRoll;
    angleRoll += K_0 * y;
    biasRoll += K_1 * y;

    P_00Roll -= K_0 * P_00Roll;
    P_01Roll -= K_0 * P_01Roll;
    P_10Roll -= K_1 * P_00Roll;
    P_11Roll -= K_1 * P_01Roll;

    return angleRoll;
}


void calibrateSensors() {

    int16_t adc[5] = { 0,0,0,0,0 };
    for (uint8_t i = 0; i < 100; i++) {
        mpu.getMotion6(&ax, &ay, &az, &gx, &gy, &gz);
        adc[0] += gx;
        adc[1] += gy;
        adc[2] += ax;
        adc[3] += ay;
        adc[4] += az;
        wait_ms(10);

    }

    zeroValues[0] = adc[0] / 100;
    zeroValues[1] = adc[1] / 100;
    zeroValues[2] = adc[2] / 100;
    zeroValues[3] = adc[3] / 100;
    zeroValues[4] = adc[4] / 100;

}

void inverte() {
    aux = 1;
}

DigitalOut inA2(D4); DigitalOut inB2(D3);  //w
DigitalOut inA1(D8); DigitalOut inB1(D9);  //r
PwmOut pwmw(D5); PwmOut pwmr(D10);

void ccw(int motor) {
    if (motor == 1) { inA1 = 1; inB1 = 0; }
    else if (motor == 2) { inA2 = 1; inB2 = 0; }
}

void cw(int motor) {
    if (motor == 1) { inA1 = 0; inB1 = 1; }
    else if (motor == 2) { inA2 = 0; inB2 = 1; }
}

void makeitspin(float pitch, float roll) {
    if (pitch > 0 && pitch >= 1.0) { ccw(2); }
    else if (pitch < 0 && pitch <= -1.0) { cw(2); }
    if (roll > 0 && roll >= 1.0) { ccw(1); }
    else if (roll < 0 && roll <= -1.0) { cw(1); }
}

int main()
{
    pwmw.period(0.0001);
    pwmr.period(0.0001);

    while (1)
    {
        aux = 0;
        mpu.getMotion6(&ax, &ay, &az, &gx, &gy, &gz);

        accAnglePitch = atan2(-1.0 * az, sqrt(1.0 * ay * ay + 1.0 * ax * ax));
        accAngleRoll = atan2(-1.0 * ax, sqrt(1.0 * az * az + 1.0 * ay * ay));
        gyroRatePitch = -(1.0 * gx) * gyroConv;
        gyroRateRoll = -(1.0 * gz) * gyroConv;

        pitch = kalmanPitch(accAnglePitch, gyroRatePitch);
        roll = kalmanRoll(accAngleRoll, gyroRateRoll);

        pc.printf("%f, %f\n\r", pitch * rad2deg, roll * rad2deg);

        makeitspin(pitch, roll);
    }
}