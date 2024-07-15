/*
template<int T_EN, int T_PWM, int T_A, int T_B>
class Motor{
  Motor()
}
*/
int pwmr = 9; int a2 = 7; int b2 = 8; //2
int pwmw = 11; int a1 = 5; int b1 = 6; //1

void setup() {
  pinMode(pwmw, OUTPUT); pinMode(a1, OUTPUT); pinMode(b1, OUTPUT); //1
  pinMode(pwmr, OUTPUT); pinMode(a2, OUTPUT); pinMode(b2, OUTPUT); //2

  pinMode(2, OUTPUT); pinMode(3, OUTPUT); //enables
  digitalWrite(2,HIGH); digitalWrite(3,HIGH);
}

int c = 50; bool flag = 0;

void loop() {

  c+=10;
  
  if (c>250) {c=50; flag = !flag;}
  if (flag) {digitalWrite(b2,LOW); digitalWrite(a2,HIGH); digitalWrite(b1,LOW); digitalWrite(a1,HIGH);}
  else {digitalWrite(a2,LOW); digitalWrite(b2,HIGH); digitalWrite(a1,LOW); digitalWrite(b1,HIGH);}

  analogWrite(pwmr, c); analogWrite(pwmw, c);
  
  delay(500);
}