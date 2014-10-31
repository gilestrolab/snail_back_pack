/* Here is a bare-bones Arduino sketch to read the
   outputs of the photodiode detectors described
   in Figure 1 and Figure 2. The output pin of the
   circuit's opamp is connected to analog pin 0
   of the Arduino. The data are read every 0.1 second
   in this example. However, you can change the sampling
   rate by simply changing the argument of the
   delay() statement. */
 
#define inPin0 0
#define  OVER_SAMPLING 5.
#define  FS 5.
 
void setup(void) {
   Serial.begin(9600);     
}
 
void loop(void) {
  
	float accum = 0; 
	for(int i =0; i !=OVER_SAMPLING; ++i){
		int pinRead0 = analogRead(inPin0);
		accum += pinRead0;
		delay(1000.0/(FS*OVER_SAMPLING));
	}
	int out = (int) accum / OVER_SAMPLING;
	Serial.print(out);
	Serial.println();
	
}