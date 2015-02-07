/*

*/
 

#define OVER_SAMPLING 5.
#define FS 3.
#define POWER_PIN 2
#define RISE_TIME_PHOTOTRANSISTOR 5// ms
#define PHOTO_TRANSISTOR_PIN 1



void setup(void) {
	Serial.begin(57600); 
	pinMode(POWER_PIN, OUTPUT);    
	
}


void loop(void) {
  
        uint accum = 0;
	for(int i =0; i < OVER_SAMPLING; i++){
		digitalWrite(POWER_PIN, HIGH);
		delay(RISE_TIME_PHOTOTRANSISTOR);
		accum +=  analogRead(PHOTO_TRANSISTOR_PIN);
				
		digitalWrite(POWER_PIN, LOW);   
		
		float to_sleep_us = 1e6/(FS*OVER_SAMPLING) ;
		delay(1e-3 * to_sleep_us - RISE_TIME_PHOTOTRANSISTOR) ;
	}
	
	
	
	
	Serial.println(accum);
	
}
