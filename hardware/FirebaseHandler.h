// FirebaseHandler.h

#ifndef FIREBASE_HANDLER_H
#define FIREBASE_HANDLER_H

#include <Firebase_ESP_Client.h>

// Define Firebase Data object
extern FirebaseData fbdo;

// Firebase Authentication and Config objects
extern FirebaseAuth auth;
extern FirebaseConfig config;

// Timing variables
extern unsigned long sendDataPrevMillis;
extern unsigned long lastReadMillis;
extern int count;
extern bool signupOK;

// Function to initialize WiFi and Firebase
void setupFirebase();

// Function to handle writing data to Firebase
void writeFirebaseFloat(FirebaseData* fbdo, const String& path, float value);

#endif // FIREBASE_HANDLER_H
