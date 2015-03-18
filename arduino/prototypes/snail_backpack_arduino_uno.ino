int time_on = 5000;//us
int time_off = 200;
int light_pin = 6;
int sensor_pin = 4;
int N = 64;
//int oversampling_delay = 10;//us

void setup() {
  // put your setup code here, to run once:
Serial.begin(57600);
pinMode(light_pin,OUTPUT);
pinMode(sensor_pin,INPUT);
digitalWrite(light_pin,HIGH);
analogReference(EXTERNAL);

}


  void loop() {
    unsigned long t0 = millis();
    // put your main code here, to run repeatedly:
    
    float accum = 0;
    digitalWrite(light_pin,HIGH);
    delayMicroseconds(time_on);
  
      for(int i = 0; i < N; i++) {
        accum += analogRead(sensor_pin);
        //delayMicroseconds(oversampling_delay);
      }
  
  
  //sample as many times as N
  
  // We increment the accumulator by the value in the phototransistor pin
 digitalWrite(light_pin, LOW);

  accum = accum / N;
  Serial.println(accum);


unsigned long t1 = millis();
unsigned long dt = t1 - t0;
  
delay(time_off - dt);
  
 
  
}; //us
