int time_on = 5000;//us
int time_off = 200;
int light_pin = 6;
int sensor_pin = 4;
int N = 64;


void setup(){
	// put your setup code here, to run once:
	Serial.begin(57600);
	pinMode(light_pin,OUTPUT);
	pinMode(sensor_pin,INPUT);
	digitalWrite(light_pin,HIGH);
	analogReference(EXTERNAL);
}

void loop() {
	unsigned long t0 = millis();

	float accum = 0;
	
	digitalWrite(light_pin,HIGH);
	delayMicroseconds(time_on);
	
	//sample as many times as N
	for(int i = 0; i < N; i++) {
		// We increment the accumulator by the value in the phototransistor pin
		accum += analogRead(sensor_pin);
	}

	digitalWrite(light_pin, LOW);
	
	accum = accum / N;
	Serial.println(accum);

	unsigned long t1 = millis();
	unsigned long dt = t1 - t0;
	
	delay(time_off - dt);
}
