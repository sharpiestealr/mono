template<uint8_t Tp_En, uint8_t Tp_Cs, uint8_t Tp_InA, uint8_t Tp_InB, uint8_t Tp_Pwm>
class Motor{
  public:
  Motor(){};
  void setup(){
    pinMode(Tp_En, OUTPUT);
    pinMode(Tp_Cs, OUTPUT);
    pinMode(Tp_InA, OUTPUT);
    pinMode(Tp_InB, OUTPUT);
    pinMode(Tp_Pwm, OUTPUT);
  };
  void setEnable(bool val=true){
    digitalWrite(Tp_En, val);
  };
  void setPwm(int16_t val){
    if (val>255) val=255;
    if (val<-255) val=-255;
    if (0 < val){
      digitalWrite(Tp_InA, true); 
      digitalWrite(Tp_InB, false);
      analogWrite(Tp_Pwm, val);
      return;
    }
    digitalWrite(Tp_InA, false); 
    digitalWrite(Tp_InB, true);
    analogWrite(Tp_Pwm, -val);
  };
};
