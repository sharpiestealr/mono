#include "mbed.h"
#include "MPU6050.h"
#include "HMC5883L.h"
#include "CalibrateMagneto.h"
#include "math.h"

#define dt 0.1f
#define Kp 2.0f         // proportional gain governs rate of convergence to accelerometer/magnetometer
#define Ki 0.01f       // integral gain governs rate of convergence of gyroscope biases
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
float phi=0.0;
float theta=0.0;
float psi=0.0;
int N=0;
const int tempo = 60/dt;
float vec1[tempo], vec2[tempo], vec3[tempo];

// Variaveis acelerometro e gyroscopio
int16_t ax, ay, az;
int16_t gx, gy, gz;
double pitch = 0.0, roll = 0.0;



int aux;

// Variaveis do Filtro de Kalman
double anglePitch = 0.0, angleRoll=0.0;
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
float zeroValues[5] = {0,0,0,0,0};

/* Kalman filter variables and constants */
const double Q_angle = 0.001; // Process noise covariance for the accelerometer - Sw
const double Q_gyro = 0.003; // Process noise covariance for the gyro - Sw
const double R_angle = 0.03; // Measurement noise covariance - Sv

double kalmanPitch(double newAnglePitch, double newRatePitch) {
    anglePitch += dt * (newRatePitch - biasPitch);
    
    // Update estimation error covariance - Project the error covariance ahead
    P_00Pitch += -dt * (P_10Pitch + P_01Pitch) + Q_angle * dt;
    P_01Pitch += -dt * P_11Pitch;
    P_10Pitch += -dt * P_11Pitch;
    P_11Pitch += +Q_gyro * dt;
    
    // Discrete Kalman filter measurement update equations - Measurement Update ("Correct")
    // Calculate Kalman gain - Compute the Kalman gain
    Sk = P_00Pitch + R_angle;
    K_0 = P_00Pitch / Sk;
    K_1 = P_10Pitch / Sk;
    
    // Calculate angle and resting rate - Update estimate with measurement zk
    y = newAnglePitch - anglePitch;
    anglePitch += K_0 * y;
    biasPitch += K_1 * y;
    
    // Calculate estimation error covariance - Update the error covariance
    P_00Pitch -= K_0 * P_00Pitch;
    P_01Pitch -= K_0 * P_01Pitch;
    P_10Pitch -= K_1 * P_00Pitch;
    P_11Pitch -= K_1 * P_01Pitch;
    
    return anglePitch;
}

double kalmanRoll(double newAngleRoll, double newRateRoll) {
    angleRoll += dt * (newRateRoll - biasRoll);
    
    // Update estimation error covariance - Project the error covariance ahead
    P_00Roll += -dt * (P_10Roll + P_01Roll) + Q_angle * dt;
    P_01Roll += -dt * P_11Roll;
    P_10Roll += -dt * P_11Roll;
    P_11Roll += +Q_gyro * dt;
    
    // Discrete Kalman filter measurement update equations - Measurement Update ("Correct")
    // Calculate Kalman gain - Compute the Kalman gain
    Sk = P_00Roll + R_angle;
    K_0 = P_00Roll / Sk;
    K_1 = P_10Roll / Sk;
    
    // Calculate angle and resting rate - Update estimate with measurement zk
    y = newAngleRoll - angleRoll;
    angleRoll += K_0 * y;
    biasRoll += K_1 * y;
    
    // Calculate estimation error covariance - Update the error covariance
    P_00Roll -= K_0 * P_00Roll;
    P_01Roll -= K_0 * P_01Roll;
    P_10Roll -= K_1 * P_00Roll;
    P_11Roll -= K_1 * P_01Roll;
    
    return angleRoll;
}                         


void calibrateSensors() {
    //LEDs = 0xF; // Turn all onboard LEDs on
    
    int16_t adc[5] = {0,0,0,0,0};
    for (uint8_t i = 0; i < 100; i++) { // Take the average of 100 readings
        mpu.getMotion6(&ax, &ay, &az, &gx, &gy, &gz);
        adc[0] += gx;  //gyrox.read();
        adc[1] += gy;  //gyroY.read();
        adc[2] += ax;  //accX.read();
        adc[3] += ay;  //accY.read();
        adc[4] += az;  //accZ.read();
        wait_ms(10);
    }
    zeroValues[0] = adc[0] / 100; // Gyro X-axis
    zeroValues[1] = adc[1] / 100; // Gyro Y-axis
    zeroValues[2] = adc[2] / 100; // Accelerometer X-axis
    zeroValues[3] = adc[3] / 100; // Accelerometer Y-axis
    zeroValues[4] = adc[4] / 100; // Accelerometer Z-axis
    
    //LEDs = 0x0; // Turn all onboard LEDs off
} 



// Interrupção
void inverte() {
    aux=1;
}


int main()
{ 
    pc.printf("MPU6050 test \n\r");
    pc.printf("MPU6050 initialize \n\r"); 
    mpu.setSleepEnabled(false);
    mpu.setI2CMasterModeEnabled(false);
    mpu.setI2CBypassEnabled(true);
    // Calibrate the gyro and accelerometer relative to ground 
    calibrateSensors();                         
    //bias = gyroBias;
    // Inicialização do sensor
    mpu.initialize();                           
    pc.printf("MPU6050 testConnection \n\r");
    
    bool mpu6050TestResult = mpu.testConnection();
    if(mpu6050TestResult) {
        pc.printf("MPU6050 test passed \n\r");
    } else {
        pc.printf("MPU6050 test failed \n\r");
    }
    calibrateSensors();                         
    bias = gyroBias;
    

    
    // Interrupção (Ts)
    tick.attach(&inverte, dt);     
                         
    while (true) {
        
        if(aux==1) {
        aux=0;
        mpu.getMotion6(&ax, &ay, &az, &gx, &gy, &gz);
        
        // Calibração
        //gx = gx - (int16_t)zeroValues[0];
        //gy = gy - (int16_t)zeroValues[1];
        //ax = ax - (int16_t)zeroValues[2];
        //ay = ay - (int16_t)zeroValues[3];
        //az = az - (int16_t)zeroValues[4];
        
        accAnglePitch = atan2(-1.0*az,sqrt(1.0*ay*ay+1.0*ax*ax));
        accAngleRoll = atan2(-1.0*ax,sqrt(1.0*az*az+1.0*ay*ay));
        gyroRatePitch = -(1.0*gx)*gyroConv;
        gyroRateRoll = -(1.0*gz)*gyroConv;
        
        // calculate the angle using a Kalman filter
        pitch = kalmanPitch(accAnglePitch, gyroRatePitch); 
        roll = kalmanRoll(accAngleRoll, gyroRateRoll);
            

        pc.printf("%f, %f\n\r", pitch*rad2deg, roll*rad2deg);
        //pc.printf("%d, %d, %d, %d, %d\n", zeroValues[0], zeroValues[1], zeroValues[2], zeroValues[3], zeroValues[4]);


        }
    }
}