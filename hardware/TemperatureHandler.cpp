// TemperatureHandler.cpp

#include <Arduino.h>
#include <OneWire.h>
#include <DallasTemperature.h>
#include "TemperatureHandler.h"

// GPIO where the DS18B20 is connected to
const int oneWireBus = 4; // Using GPIO2 for example

// Create instances of OneWire and DallasTemperature
OneWire oneWire(oneWireBus);
DallasTemperature sensors(&oneWire);

void setupTemperatureSensor() {
  Serial.begin(115200);
  // Configure GPIO2 as input with internal pull-up
  pinMode(oneWireBus, INPUT_PULLUP);
  
  // Start the DS18B20 sensor
  sensors.begin();
}

void loopTemperatureSensor() {
  sensors.requestTemperatures(); 
  float temperatureC = sensors.getTempCByIndex(0);
  float temperatureF = sensors.getTempFByIndex(0);
  Serial.print(temperatureC);
  Serial.println("ºC");
  Serial.print(temperatureF);
  Serial.println("ºF");
  delay(5000);
}

// function to print a device address
void printAddress(DeviceAddress deviceAddress) {
  for (uint8_t i = 0; i < 8; i++){
    if (deviceAddress[i] < 16) Serial.print("0");
      Serial.print(deviceAddress[i], HEX);
  }
}
