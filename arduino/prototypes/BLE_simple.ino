/*
 * gatttool -b FC:F8:A1:62:36:40 -I -t random 
 * connect
 * char-read-uuid 2221
 * OR
 * gatttool -b FC:F8:A1:62:36:40  -t random  --char-read --handle=0x000e 
 * 2.55
 * */
#include <RFduinoBLE.h>
#define DEVICE_NAME "temp"

float counter = 0.0;
void setup() {

  RFduinoBLE.advertisementData = DEVICE_NAME;
  RFduinoBLE.begin();
}

void loop() {
  // sample once per second
  RFduino_ULPDelay( SECONDS(1) );
  // degrees f (-128.00 to +127.00)
  float temp = RFduino_temperature(CELSIUS);

  // send the sample to the iPhone
  RFduinoBLE.sendFloat(temp);
  counter += 1.0;
}
