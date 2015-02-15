/*
Snail Heart Rate monitor
Quentin Geissmann [http://github.com/qgeissmann]
*/
 

// Every data point will be the sum of `OVER_SAMPLING` consecutive reads
#define OVER_SAMPLING 256

// The sampling frequency(in Hz). That is the actual number of point we output every second
#define FS 8.0

// The digital pin controlling power
#define POWER_PIN 2

// How long should we leave the circuit turned on  before reading a value
#define RISE_TIME 8// us

// The analogue pin from which phototransistor values are read
#define PHOTO_TRANSISTOR_PIN 1


// We define the time to sleep between actual reads (i.e. accounting for oversampling)
// as 1/ (Fse), where Fse is the actual sampling frequency, which is simply (FS x OVER_SAMPLING)
// Importantly, FS is in Hz(s^-1), whilst `delayMicroseconds()`expect us, so we multiply the above expression by 1e6
// In addition, we already ask the device to sleep (RISE_TIME us) before reading values, so we subtract this value
// Finally, since this value is not going to change during execution of the program,
// we can define it as a constant (const)
const float time_to_sleep_us = 1e6 / (FS * OVER_SAMPLING) - RISE_TIME;

void setup(void) {
    // We set the baud rate to 57600 which should be more than enough
	Serial.begin(57600);

	// Then, we set the digital pin as an output pin that can take HIGH(5V) or LOW(0V) values
	pinMode(POWER_PIN, OUTPUT);
}


void loop(void) {
    // We initialise an accumulator (float) variable to 0.
    float accum = 0;

    // We are going to sample as many time as the value of `OVER_SAMPLING`
	for(int i =0; i < OVER_SAMPLING; i++){
	    // Turn the circuit ON
		digitalWrite(POWER_PIN, HIGH);
		// We wait for the circuit to be in a stationary state
		delayMicroseconds(RISE_TIME);

		// We increment the accumulator by the value in the phototransistor pin
		accum +=  analogRead(PHOTO_TRANSISTOR_PIN);

		// Then, we immediately turn the circuit OFF
		digitalWrite(POWER_PIN, LOW);   

		// Now, we sleep.
                // delayMicroseconds() is not accurate above 16383 (2^14 - 1)
                // if we need to sleep longer, we use delay, and divide by 1000
                if(time_to_sleep_us > 16383)
          	      delay(time_to_sleep_us / 1e3);
                else
                    delayMicroseconds(time_to_sleep_us) ;
	}
	// We return the value of the accumulator, which is the oversampled sum of several consecutive reads
        accum /= OVER_SAMPLING;
	Serial.println(accum);
}

