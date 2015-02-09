/*
Snail hear rate monitor
Quentin Geissmann [http://github.com/qgeissmann]
*/
 

// Every data point will be the sum of `OVER_SAMPLING` consecutive reads
#define OVER_SAMPLING 16

// The sampling frequency(in Hz). That is the actual number of point we output every second
#define FS 10.

// The digital pin controlling power
#define POWER_PIN 2

// How long should we leave the circuit on on before reading a value
#define RISE_TIME 5// ms

// The analogue pin from which phototransistor values are read
#define PHOTO_TRANSISTOR_PIN 1


// We define the time to sleep between actual reads (i.e. accounting for oversampling)
// as 1/ (Fse), where Fse is the actual sampling frequency, which is simply (FS x OVER_SAMPLING)
// Importantly, FS is in Hz(s^-1), whilst `delay()`expect ms, so we multiply the above expression by 1e3.
// In addition, we already ask the device to sleep (RISE_TIME ms) before reading values, so we subtract this value
// Finally, this value is not going to change during execution of the program,
// so we can define it as a constant (const)
const float time_to_sleep_ms = 1e3/(FS*OVER_SAMPLING) - RISE_TIME;


void setup(void) {
    // We set the baud rate to 57600 which should be more than enough
	Serial.begin(57600);

	// Then, we set the digital pin as an output pin that can take HIGH(5v) or LOW(0v) values.
	pinMode(POWER_PIN, OUTPUT);


}


void loop(void) {
    // We initialise an accumulator variable to 0. `unsigned` just means its value cannot be negative
    unsigned int accum = 0;

    // We are going to sample as many time as the value of `OVER_SAMPLING`
	for(int i =0; i < OVER_SAMPLING; i++){
	    // Turn the circuit ON
		digitalWrite(POWER_PIN, HIGH);
		// We wait for ce circuit to be in a stationary state
		delay(RISE_TIME);

		// we increment the accumulator by the value in the phototransistor pin
		accum +=  analogRead(PHOTO_TRANSISTOR_PIN);
		// Then, we immediately turn the circuit OFF
		digitalWrite(POWER_PIN, LOW);   

		// Now, the time to sleep in ms is
		delay(time_to_sleep_ms) ;
	}
	// we return the value of the accumulator, which is the oversampled sum of several consecutive reads
	Serial.println(accum);
}

