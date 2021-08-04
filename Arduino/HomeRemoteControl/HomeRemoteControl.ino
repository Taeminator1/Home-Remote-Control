#define BUAD_RATE               115200    // b/s(bits per second)
#define BUTTONS_COUNT           2         // 0: for window, 1: for airconditioner
#define SWITCHS_COUNT           2         // 0: end of the actuator, 1: next to the motor
#define LOOP_DELAY              1000      // ms
#define STEPS_PER_REVOLUTION    200
#define STEP_SPEED              200
#define STEP_DELAY              1         // ms

#include <Arduino.h>
#include <ESP8266WiFiMulti.h>
#include <ESP8266HTTPClient.h>
#include <IRsend.h>
#include "CustomStepper.h"
#include "PersonalInfo.h"
#include "SamsungIR.h"
#include "Toggle.h"

// assign GPIO pins
const int driverPins[4] = {14, 12, 13, 15};
const int irPin = 10;
const int switchPins[SWITCHS_COUNT] = {5, 4};

ESP8266WiFiMulti WiFiMulti;
Toggle toggles[BUTTONS_COUNT];

CustomStepper stepper(STEPS_PER_REVOLUTION, driverPins, STEP_DELAY);
bool switchStates[SWITCHS_COUNT] = {false, };
IRsend irSend(irPin);


void setup() {
  Serial.begin(BUAD_RATE);
  Serial.println();

  stepper.setSpeed(STEP_SPEED);
  irSend.begin();
  
  for(int i = 0; i < 4; i++) {
    pinMode(driverPins[i], OUTPUT);
    digitalWrite(driverPins[i], HIGH);
  }
  
  for(int i = 0; i < SWITCHS_COUNT; i++)
    pinMode(switchPins[SWITCHS_COUNT], INPUT);
}

void loop() {
  
  if ((WiFiMulti.run() == WL_CONNECTED)) {    // check connection state
    WiFiClient client;
    HTTPClient http;
    
    if (http.begin(client, PersonalInfo::url)) {  // HTTP
      // start connection and send HTTP header
      int httpCode = http.GET();

      // httpCode will be negative on error
      if (httpCode > 0) {
        // HTTP header has been send and Server response header has been handled
        Serial.printf("[HTTP] GET... code: %d\n", httpCode);

        // file found at server
        if (httpCode == HTTP_CODE_OK || httpCode == HTTP_CODE_MOVED_PERMANENTLY) {
          const String payload = http.getString();
          const String target = "'label";                     // find String starting with "'label"
                                                              // in HTML(<label id = 'labelx'> xxxxx </label>)
          
          int toggleIndex = 0;
          // get states of buttons in HTML
          for (int i = 0; i < payload.length() - target.length(); i++) {
            if (payload.substring(i, i + target.length()) == target) {
              i += (target.length() + 4);
                  
              String buff = "false";
              buff = payload.substring(i, i + buff.length());

              if (buff == "true ")  { toggles[toggleIndex++].setExternalState(true); }
              else                  { toggles[toggleIndex++].setExternalState(false); }
              
              if (toggleIndex == BUTTONS_COUNT) break;
            }
          }

          // Action For Stepper
          if (toggles[0].isTurnedOn()) {
            Serial.println("Close the window.");
            stepper.rotateWithSwitch(switchPins[0], -STEPS_PER_REVOLUTION);     // go to the end of the actuator
            stepper.rotateWithSwitch(switchPins[1], STEPS_PER_REVOLUTION);      // return to the motor
            stepper.rotateRepeatedly(3, -STEPS_PER_REVOLUTION);                 // for margin from motor(repeat 3 times)

            for (int i = 0; i < 4; i++)
              digitalWrite(driverPins[i], HIGH);
          }
          else if (toggles[0].isTurnedOff()) {
            for (int i = 0; i < SWITCHS_COUNT; i++)
              switchStates[i] = digitalRead(switchPins[i]);
          }

          // Action for IRSender
          if (toggles[1].isTurnedOn()) {
            Serial.println("Turn on the Airconditioner");
            irSend.sendSamsungAC(SamsungIR::state[0]);
          }
          else if(toggles[1].isTurnedOff()) {
            Serial.println("Turn off the Airconditioner");
            irSend.sendRaw(SamsungIR::rawData, 349, 38);
          }
        }
      } else {
        Serial.printf("[HTTP] GET... failed, error: %s\n", http.errorToString(httpCode).c_str());
      }

      http.end();
      
    } else {
      Serial.println("[HTTP} Unable to connect");
    }
  } else {        // for connection to Wi-Fi
    Serial.printf("[SETUP] WAIT...\n");
    Serial.flush();
    delay(LOOP_DELAY);
  
    WiFi.mode(WIFI_STA);
    WiFiMulti.addAP(PersonalInfo::wifi_id, PersonalInfo::wifi_pw);
  }
  
  delay(LOOP_DELAY);
}
