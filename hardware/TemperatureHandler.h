// TemperatureHandler.h

#ifndef TEMPERATURE_HANDLER_H
#define TEMPERATURE_HANDLER_H

#include <OneWire.h>
#include <DallasTemperature.h>

// GPIO where the DS18B20 is connected to
extern const int oneWireBus;

// Create instances of OneWire and DallasTemperature
extern OneWire oneWire;
extern DallasTemperature sensors;

// Function declarations
void setupTemperatureSensor();
void loopTemperatureSensor();
void printAddress(DeviceAddress deviceAddress);

#endif // TEMPERATURE_HANDLER_H
