int time_on = 25;//ms
int time_off = 200; // sampling periode ms
int light_pin = 2; //LED light pin
int light_sensor_pin = 4; //light sensor pin
int N = 64; //oversampling

#define aref_voltage 3.3;  // we tie 3.3V to ARef and measure it with a multimeter!

void setup() {
	// put your setup code here, to run once:
	Serial.begin(57600);
	pinMode(light_pin,OUTPUT); 
	digitalWrite(light_pin,HIGH);
	pinMode(light_sensor_pin,INPUT);
	analogReference(EXTERNAL); //to set aref at 3.3V
}

void loop() {
	unsigned long t0 = millis();

	float accum = 0;
	
	digitalWrite(light_pin,HIGH);
	delay(time_on);
	
	    //sample as many times as N
	    for(int i = 0; i < N; i++) {
	  	accum += analogRead(light_sensor_pin); // increment the accumulator by the value in the phototransistor pin
	    }

        digitalWrite(light_pin, LOW);
	
	accum = accum / N;

        Serial.println(accum); //sensor pin reading

        unsigned long t1 = millis();
        unsigned long dt = t1 - t0;
	
        delay(time_off - dt);

}

