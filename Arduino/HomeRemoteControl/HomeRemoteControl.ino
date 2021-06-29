#include <Arduino.h>

#include <ESP8266WiFiMulti.h>
#include <ESP8266HTTPClient.h>
#include <Stepper.h>
#include <IRsend.h>
#include "PersonalInfo.h"
#include "SamsungIR.h"

#define BUTTONS_COUNT 2

ESP8266WiFiMulti WiFiMulti;

const int loopDelay = 1000;                         // ms

const int stepsPerRevolution = 200;                 // change this to fit the number of steps per revolution(+: return, -: go)
const int stepSpeed = 200;    
const int stepDelay = 1;                            // ms     
const int driverPins[4] = {14, 12, 13, 15};         // assign GPIO pins for motor driver
Stepper stepper(stepsPerRevolution, driverPins[0], driverPins[1], driverPins[2], driverPins[3]);

const int irPin = 10;                               // assign GPIO pin for ir sensor
IRsend irsend(irPin);

// 0: end of the actuator, 1: next to the motor
const int switchPins[2] = {5, 4};                   // assign GPIO pin for limit switch
bool switchStates[2] = {false, };

// 0: the first web toggles, 1: the second web toggles
bool toggles[BUTTONS_COUNT] = {false, };
bool buttonStates[BUTTONS_COUNT] = {false, };
    
void setup() {

  Serial.begin(115200);
  Serial.println();

  stepper.setSpeed(stepSpeed);
  for(int i = 0; i < 4; i++) {
    pinMode(driverPins[i], OUTPUT);
    digitalWrite(driverPins[i], HIGH);
  }

  irsend.begin();
  
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
          for (int i = 0; i < payload.length(); i++) {
            if (payload.substring(i, i + 6) == "\"label") {           // find string starting with "\"label" in HTML
                  
              String buff = "false";
              buff = payload.substring(i + 10, i + 15);
              
              if (buff == "true ")  buttonStates[index++] = true;
              else                  buttonStates[index++] = false;
              
              if (index == BUTTONS_COUNT) break;
            }
          }

          if (buttonStates[0] == true && toggles[0] == false) {
            toggles[0] = true;
            while (switchStates[0] == 0) {     // go to the end of the actuator
              stepper.step(-stepsPerRevolution);
              switchStates[0] = digitalRead(switchPins[0]);
              delay(1);
            }

            // after closing the window, decide whether turn on or off air conditoner
            
            // Need to code
            
            while (switchStates[1] == 0) {     // return to the motor
              stepper.step(stepsPerRevolution);
              switchStates[1] = digitalRead(switchPins[1]);
              delay(stepDelay);
            }
            for (int i = 0; i < 3; i++) {     // for margin away motor
              stepper.step(-stepsPerRevolution);
              delay(stepDelay);
            }

            for (int i = 0; i < 4; i++)
              digitalWrite(driverPins[i], HIGH);
          }
          else if (buttonStates[0] == false) {
            toggles[0] = false;
            for (int i = 0; i < BUTTONS_COUNT; i++)
              switchStates[i] = digitalRead(switchPins[i]);
          }

          if (buttonStates[1] == true && toggles[1] == false) {
            toggles[1] = true;
            Serial.println("Turn on the air conditional");
            irsend.sendSamsungAC(SamsungIR::state[0]);
          }
          else if(buttonStates[1] == false && toggles[1] == true) {
            toggles[1] = false;
            Serial.println("Turn off the air conditional");
            irsend.sendRaw(SamsungIR::rawData, 349, 38);
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
    Serial.printf("[SETUP] WAIT ...\n");
    Serial.flush();
    delay(loopDelay);
  
    WiFi.mode(WIFI_STA);
    WiFiMulti.addAP(PersonalInfo::wifi_id, PersonalInfo::wifi_pw);
  }
  
  delay(loopDelay);
}
