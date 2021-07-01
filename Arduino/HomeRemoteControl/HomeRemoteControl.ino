#define BUTTONS_COUNT 2
#define LOOP_DEALY 1000                             // ms
#define STEPS_PER_REVOLUTION 200
#define STEP_SPEED 200
#define STEP_DELAY 1                                // ms

#include <Arduino.h>
#include <ESP8266WiFiMulti.h>
#include <ESP8266HTTPClient.h>
#include <Stepper.h>
#include <IRsend.h>
#include "PersonalInfo.h"
#include "SamsungIR.h"
#include "Toggle.h"

ESP8266WiFiMulti WiFiMulti;
     
const int driverPins[4] = {14, 12, 13, 15};         // assign GPIO pins for motor driver
Stepper stepper(STEPS_PER_REVOLUTION, driverPins[0], driverPins[1], driverPins[2], driverPins[3]);

const int irPin = 10;                               // assign GPIO pin for ir sensor
IRsend irSend(irPin);

// 0: end of the actuator, 1: next to the motor
const int switchPins[2] = {5, 4};                   // assign GPIO pin for limit switch
bool switchStates[2] = {false, };

Toggle toggles[BUTTONS_COUNT];
    
void setup() {
  Serial.begin(115200);
  Serial.println();

  stepper.setSpeed(STEP_SPEED);
  for(int i = 0; i < 4; i++) {
    pinMode(driverPins[i], OUTPUT);
    digitalWrite(driverPins[i], HIGH);
  }

  irSend.begin();
  
  for(int i = 0; i < 2; i++)
    pinMode(switchPins[i], INPUT);
}

void loop() {
  // wait for WiFi connection
  if ((WiFiMulti.run() == WL_CONNECTED)) {
    WiFiClient client;
    HTTPClient http;

    Serial.println("[HTTP] begin...");
    if (http.begin(client, PersonalInfo::url)) {  // HTTP
      Serial.println("[HTTP] GET...");
      
      // start connection and send HTTP header
      int httpCode = http.GET();

      // httpCode will be negative on error
      if (httpCode > 0) {
        // HTTP header has been send and Server response header has been handled
        Serial.printf("[HTTP] GET... code: %d\n", httpCode);

        // file found at server
        if (httpCode == HTTP_CODE_OK || httpCode == HTTP_CODE_MOVED_PERMANENTLY) {
          String payload = http.getString();
          
          int index = 0;
          for (int i = 0; i < payload.length() - 6; i++) {
            if (payload.substring(i, i + 6) == "\"label") {           // find string starting with "\"label" in HTML
                  
              String buff = "false";
              buff = payload.substring(i + 10, i + 15);

              if (buff == "true ")  { toggles[index++].setExternalState(true); }
              else                  { toggles[index++].setExternalState(false); }
              
              if (index == BUTTONS_COUNT) break;
            }
          }

          // Action For Stepper
          if (toggles[0].isTurnedOn()) {
            Serial.println("ddd");
            rotateMotorWithSwitch(switchPins[0], -STEPS_PER_REVOLUTION);     // go to the end of the actuator
            rotateMotorWithSwitch(switchPins[1], STEPS_PER_REVOLUTION);      // return to the motor
            rotateMotorRepeatedly(3, -STEPS_PER_REVOLUTION);                 // for margin from motor

            for (int i = 0; i < 4; i++)
              digitalWrite(driverPins[i], HIGH);
          }
          else if (toggles[0].isTurnedOff()) {
            for (int i = 0; i < BUTTONS_COUNT; i++)
              switchStates[i] = digitalRead(switchPins[i]);
          }

          // Action for IRSender
          if (toggles[1].isTurnedOn())
            irSend.sendSamsungAC(SamsungIR::state[0]);
          else if(toggles[1].isTurnedOff())
            irSend.sendRaw(SamsungIR::rawData, 349, 38);
        }
      } else {
        Serial.printf("[HTTP] GET... failed, error: %s\n", http.errorToString(httpCode).c_str());
      }

      http.end();
      
    } else {
      Serial.println("[HTTP} Unable to connect");
    }
  } else {        // for connection to Wi-Fi
    Serial.printf("[SETUP] WAIT ...\n");
    Serial.flush();
    delay(LOOP_DEALY);
  
    WiFi.mode(WIFI_STA);
    WiFiMulti.addAP(PersonalInfo::wifi_id, PersonalInfo::wifi_pw);
  }
  
  delay(LOOP_DEALY);
}

void rotateMotor(int velocity) {
  stepper.step(velocity);
  delay(STEP_DELAY);
}

void rotateMotorWithSwitch(int switchPin, int velocity) {
  while (digitalRead(switchPin) == 0)
    rotateMotor(velocity);
}

void rotateMotorRepeatedly(int repeatNumber, int velocity) {
  for (int i = 0; i < repeatNumber; i++)
    rotateMotor(velocity);
}
