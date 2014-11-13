/* Here is a bare-bones Arduino sketch to read the
   outputs of the photodiode detectors described
   in Figure 1 and Figure 2. The output pin of the
   circuit's opamp is connected to analog pin 0
   of the Arduino. The data are read every 0.1 second
   in this example. However, you can change the sampling
   rate by simply changing the argument of the
   delay() statement. */
 
#define N_ANALOG_INPUT_PINS 5
#define OVER_SAMPLING 3.
#define FS 5.
#define POWER_PIN 13
#define RISE_TIME_PHOTOTRANSISTOR 1// ms

int accum_ar[N_ANALOG_INPUT_PINS];

void setup(void) {
	Serial.begin(57600); 
	pinMode(POWER_PIN, OUTPUT);    
	
}

int read(void){
	
	for(int j =0; j < N_ANALOG_INPUT_PINS; j++){
		accum_ar[j] = 0;
	}
	
	for(int i =0; i < OVER_SAMPLING; i++){
		digitalWrite(POWER_PIN, HIGH);
		delay(RISE_TIME_PHOTOTRANSISTOR);
		
		for(int j =0; j < N_ANALOG_INPUT_PINS; j++){
			
			int pinRead = analogRead(j);
			accum_ar[j] = pinRead;
		}		
				
		digitalWrite(POWER_PIN, LOW);   
		
		float to_sleep_us = 1e6/(FS*OVER_SAMPLING) ;
		delay(1e-3 * to_sleep_us - RISE_TIME_PHOTOTRANSISTOR) ;
	}
}
void loop(void) {
  
	read();
	
	
	for(int j =0; j != N_ANALOG_INPUT_PINS; j++){
		
		Serial.print(accum_ar[j]);
		Serial.print(",");
	}
	
	
	Serial.print("\n");
	
}