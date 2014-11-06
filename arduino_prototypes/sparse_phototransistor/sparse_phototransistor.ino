/* Here is a bare-bones Arduino sketch to read the
   outputs of the photodiode detectors described
   in Figure 1 and Figure 2. The output pin of the
   circuit's opamp is connected to analog pin 0
   of the Arduino. The data are read every 0.1 second
   in this example. However, you can change the sampling
   rate by simply changing the argument of the
   delay() statement. */
 
#define IN_PIN 0
#define OVER_SAMPLING 5.
#define FS 5.
#define POWER_PIN 13
#define RISE_TIME_PHOTOTRANSISTOR 300 // us
 
void setup(void) {
	Serial.begin(9600); 
	pinMode(POWER_PIN, OUTPUT);    
}

int read(void){
	int accum = 0; 
	for(int i =0; i !=OVER_SAMPLING; ++i){
		digitalWrite(POWER_PIN, HIGH);   
		delayMicroseconds(RISE_TIME_PHOTOTRANSISTOR);
		int pinRead0 = analogRead(IN_PIN);
		digitalWrite(POWER_PIN, LOW);   
		accum += pinRead0;
		delayMicroseconds(1e6/(FS*OVER_SAMPLING) - RISE_TIME_PHOTOTRANSISTOR);
	}
	int out = (int) accum / OVER_SAMPLING;
	return out;
}
void loop(void) {
  
	
	Serial.print(read());
	Serial.println();
	
}