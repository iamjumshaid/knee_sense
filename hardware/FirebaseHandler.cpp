// FirebaseHandler.cpp

#include <Arduino.h>
#include <WiFi.h>
#include <Firebase_ESP_Client.h>
#include "FirebaseHandler.h"
#include "addons/TokenHelper.h"
#include "addons/RTDBHelper.h"

// Insert your network credentials
#define WIFI_SSID "Abc"
#define WIFI_PASSWORD "hello world"

// Insert Firebase project API Key
#define API_KEY ""

// Insert RTDB URL
#define DATABASE_URL ""

// Define Firebase Data object
FirebaseData fbdo;

// Firebase Authentication and Config objects
FirebaseAuth auth;
FirebaseConfig config;

// Timing variables
unsigned long sendDataPrevMillis = 0;
unsigned long lastReadMillis = 0;
int count = 0;
bool signupOK = false;

void setupFirebase() {
  Serial.begin(115200);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  // Configure Firebase
  config.api_key = API_KEY;
  config.database_url = DATABASE_URL;

  // Set the callback function for token status
  config.token_status_callback = tokenStatusCallback;

  // Initialize Firebase
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);

  // Anonymous sign-in
  if (Firebase.signUp(&config, &auth, "", "")) {
    Serial.println("Anonymous sign-in successful");
    signupOK = true;
  } else {
    Serial.printf("Anonymous sign-in failed: %s\n", config.signer.signupError.message.c_str());
  }
}


void writeFirebaseFloat(FirebaseData* fbdo, const String& path, float value) {
  if (Firebase.RTDB.setFloat(fbdo, path, value))
    Serial.println("Writing FLOAT value PASSED");
  //  Serial.println("PATH: " + fbdo->dataPath());
  //  Serial.println("TYPE: " + fbdo->dataType());

}

