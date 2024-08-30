#include <Wire.h>
#include "SparkFun_BNO08x_Arduino_Library.h"  // CTRL+Click here to get the library: http://librarymanager/All#SparkFun_BNO08x
#include "relativeq.h"
#include "relativeq.c"
#include "FirebaseHandler.h"
#include "TemperatureHandler.h"

DeviceAddress tempDeviceAddress; 
BNO08x myIMU;
float tempC[2];

// For the most reliable interaction with the SHTP bus, we need
// to use hardware reset control, and to monitor the H_INT pin.
// The H_INT pin will go low when its okay to talk on the SHTP bus.
// Note, these can be other GPIO if you like.
// Define as -1 to disable these features.
#define BNO08X_INT  -1
//#define BNO08X_INT  -1
#define BNO08X_RST  -1
//#define BNO08X_RST  -1
Quaternion Q1; 
Quaternion Q2; 
Quaternion Relative;
Q_angle angle; 

#define PCAADDR 0x70

void pcaselect(uint8_t i) {
  if (i > 7) return;
 
  Wire.beginTransmission(PCAADDR);
  Wire.write(1 << i);
  Wire.endTransmission();  
}

#define BNO08X_ADDR 0x4B  // SparkFun BNO08x Breakout (Qwiic) defaults to 0x4B
//#define BNO08X_ADDR 0x4A // Alternate address if ADR jumper is closed

void setup() {
  Serial.begin(115200);
  
  while(!Serial) delay(10); // Wait for Serial to become available.
  // Necessary for boards with native USB (like the SAMD51 Thing+).
  // For a final version of a project that does not need serial debug (or a USB cable plugged in),
  // Comment out this while loop, or it will prevent the remaining code from running.
  
  Serial.println();
  Serial.println("BNO08x Read Example");

  Wire.begin();
  pcaselect(1);
  setupTemperatureSensor();

  //if (myIMU.begin() == false) {  // Setup without INT/RST control (Not Recommended)
  while (myIMU.begin(BNO08X_ADDR, Wire, BNO08X_INT, BNO08X_RST) == false) 
  {
    Serial.println("BNO08x not detected at default I2C address. Check your jumpers and the hookup guide. Freezing...");
    delay(1000);
  }
  Serial.println("BNO08x found!");

  // Wire.setClock(400000); //Increase I2C data rate to 400kHz

  setReports();

  Serial.println("Reading events");
  setupFirebase();
  delay(100);
}

// Here is where you define the sensor outputs you want to receive
void setReports(void) {
 // Serial.println("Setting desired reports");
  if (myIMU.enableRotationVector() == true) {
  //  Serial.println(F("Rotation vector enabled"));
   // Serial.println(F("Output in form i, j, k, real, accuracy"));
  } else {
   // Serial.println("Could not enable rotation vector");
  }
}

void loop() 
{
  delay(10);
  pcaselect(3);
  setReports();
  for(int i = 0; i<100 ; i++)
  {
  if (myIMU.getSensorEvent() == true) 
  {
    // is it the correct sensor data we want?
    if (myIMU.getSensorEventID() == SENSOR_REPORTID_ROTATION_VECTOR) 
    {
      Q1.x = myIMU.getQuatI();
      Q1.y = myIMU.getQuatJ();
      Q1.z = myIMU.getQuatK();
      Q1.w = myIMU.getQuatReal();
    }
  }
  }

  // Serial.println("The Values Of IMU 1");
  //  Serial.print(Q1.x, 2);
  //     Serial.print(F(","));
  //     Serial.print(Q1.y, 2);
  //     Serial.print(F(","));
  //     Serial.print(Q1.z, 2);
  //     Serial.print(F(","));
  //     Serial.print(Q1.w, 2);

   delay(100);
  pcaselect(1);

  setReports();
  

 for(int i = 0; i<100 ; i++)
  {
  if (myIMU.getSensorEvent() == true)
  {
    if (myIMU.getSensorEventID() == SENSOR_REPORTID_ROTATION_VECTOR) 
    {

      Q2.x = myIMU.getQuatI();
      Q2.y = myIMU.getQuatJ();
      Q2.z = myIMU.getQuatK();
      Q2.w = myIMU.getQuatReal();
    }
  }
  }
  //  Serial.println("The Values Of IMU 2");
  //  Serial.print(Q2.x, 2);
  //     Serial.print(F(","));
  //     Serial.print(Q2.y, 2);
  //     Serial.print(F(","));
  //     Serial.print(Q2.z, 2);
  //     Serial.print(F(","));
  //     Serial.print(Q2.w, 2);
  //     Serial.println(); 
   delay(10);


  Relative = relative_quaternion(Q1,Q2);
//  Serial.println("The Values Of Relative Q is:");
//       Serial.print(Relative.x, 2);
//       Serial.print(F(","));
//       Serial.print(Relative.y, 2);
//       Serial.print(F(","));
//       Serial.print(Relative.z, 2);
//       Serial.print(F(","));
//       Serial.print(Relative.w, 2);

     angle = quaternion_angle(Relative);
     Serial.print("angle is:");
     Serial.println(angle.w * 57.29);
     Serial.print("X-axis angle is:");
     Serial.println(angle.x);
     delay(10);
     Serial.print("Y-axis angle is:");
     Serial.println(angle.y);
     delay(10);
     Serial.print("Z-axis angle is:");
     Serial.println(angle.z);
     delay(10);

  sensors.requestTemperatures(); // Send the command to get temperatures
  
  // Loop through each device, print out temperature data
  for(int i=0;i<2; i++)
  {
    // Search the wire for address
    Serial.println(i);
    if(sensors.getAddress(tempDeviceAddress, i)){
      // Output the device ID
      Serial.print("Temperature for device: ");
      Serial.println(i,DEC);
      // Print the data
      tempC[i] = sensors.getTempC(tempDeviceAddress);
      Serial.print("Temp C: ");
      Serial.print(tempC[i]);
    }
    float mean = (tempC[0]+tempC[1])/2;
   if (Firebase.ready() && signupOK) 
            {
                writeFirebaseFloat(&fbdo,"Angle/Angle", angle.w );
                delay(10);
                writeFirebaseFloat(&fbdo,"Temp/mean", mean );
                delay(10);
            }
}
}
