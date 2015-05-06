int time_on = 25;//ms
int sampling_frequency_sec = 2;
int time_off = sampling_frequency_sec *1000; // sampling periode ms
int temperature_sensor_pin = 5;
int N = 64; //oversampling
float over_sampling_delay(sampling_frequency_sec/N);

#define aref_voltage 3.3;  // we tie 3.3V to ARef and measure it with a multimeter!
float temperature_raw;

void setup() {
	// put your setup code here, to run once:
	Serial.begin(57600);
        pinMode(temperature_sensor_pin,INPUT);
	analogReference(EXTERNAL); //to set aref at 3.3V
}

void loop() {
        
        unsigned long t0 = millis();
        float accum = 0;
        
        for(int i = 0; i < N; i++) {
	   accum += analogRead(temperature_sensor_pin); // increment the accumulator by the value in the phototransistor pin
	   delay(over_sampling_delay);
           }

        accum = accum / N;
        
        float voltage = accum * aref_voltage; //float voltage = temperature_raw;//convert raw temperature reading to degrees celcius
        voltage /= 1024.0; 
        float temperature_C = (voltage - 0.5) * 100 ; //converting from 10 mv per degree wit 500 mV offset
        Serial.println(temperature_C); // now print out the temperature //Serial.println(" degrees C");
        
        unsigned long t1 = millis();
        unsigned long dt = t1 - t0;
	
        delay(time_off - dt);
          

}

