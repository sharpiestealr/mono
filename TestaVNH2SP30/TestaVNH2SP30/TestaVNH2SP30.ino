#include "Motor.h"

using Motor1 = Motor<2, A0, 4, 3, 5>; // En, Cs, InA, InB, Pwm
using Motor2 = Motor<7, A1, 8, 9, 10>; // En, Cs, InA, InB, Pwm

Motor1 motor_cadu;
Motor2 motor_vicky;

int16_t counter = 0; 

void setup() {
  motor_cadu.setup();
  motor_vicky.setup();
  motor_cadu.setEnable();
  motor_vicky.setEnable();
  Serial.begin(9600);
}

void loop() {
  int16_t pwm_1 = ((counter)%400);
  int16_t pwm_2 = ((counter+100)%400);
  if (pwm_1>200) pwm_1 = 400-pwm_1;
  if (pwm_2>200) pwm_2 = 400-pwm_2;
  pwm_1 -= 100;
  pwm_2 -= 100;
  pwm_1 *= 2;
  pwm_2 *= 2;
  Serial.print(pwm_1); Serial.print(" "); Serial.println(pwm_2);
  motor_cadu.setPwm( pwm_1 );
  motor_vicky.setPwm( pwm_2 );
  delay(10);
  counter++;
}