#include <Arduino.h>

#include <ESP8266WiFi.h>
#include <ESP8266WiFiMulti.h>
#include <ESP8266HTTPClient.h>
#include <WiFiClient.h>

#include <Stepper.h>

#include <IRsend.h>

#include "PersonalInfo.h"


ESP8266WiFiMulti WiFiMulti;

const int stepsPerRevolution = 200;                 // change this to fit the number of steps per revolution(+: return, -: go)
const uint16_t driverIN[4] = {14, 12, 13, 15};      // assign motor driver IN pin
Stepper myStepper(stepsPerRevolution, driverIN[0], driverIN[1], driverIN[2], driverIN[3]);

const uint16_t irSend = 10;
IRsend irsend(irSend);

// 0: end of the actuator, 1: next to the motor
const uint16_t limitSwitch[2] = {5, 4};
bool switchState[2] = {false, false};

// 0: the first web toggle, 1: the second web toggle
bool toggle[2] = {false, false};
bool buttonState[2] = {false, false};


// Mesg Desc.: Power: Off, Mode: 0 (Auto), Temp: 25C, Fan: 6 (Auto), Swing: Off, Beep: Off, Clean: Off, Quiet: Off, Powerful: Off, Breeze: Off, Light: On, Ion: Off
const uint16_t rawData[349] = {630, 17794,  3038, 8918,  542, 454,  538, 1452,  536, 480,  514, 478,  508, 486,  512, 482,  510, 484,  536, 458,  538, 456,  542, 1446,  544, 450,  542, 452,  542, 1446,  542, 1448,  542, 452,  540, 1450,  540, 1472,  516, 1474,  484, 1504,  510, 1478,  538, 454,  542, 452,  542, 452,  542, 450,  542, 452,  544, 450,  542, 452,  544, 450,  542, 454,  540, 454,  542, 454,  540, 456,  538, 478,  516, 478,  514, 480,  482, 510,  510, 484,  508, 484,  512, 482,  538, 454,  544, 450,  542, 450,  542, 452,  540, 452,  544, 452,  542, 450,  542, 452,  542, 452,  540, 456,  538, 456,  538, 480,  514, 478,  516, 478,  484, 510,  510, 1478,  536, 1452,  544, 2928,  3036, 8920,  542, 1446,  542, 452,  544, 450,  544, 452,  540, 452,  542, 454,  540, 456,  538, 456,  538, 478,  516, 1472,  486, 506,  512, 482,  536, 1450,  540, 454,  540, 1448,  542, 1446,  544, 1444,  542, 1446,  542, 1448,  542, 1448,  538, 458,  538, 476,  516, 478,  516, 478,  510, 484,  512, 482,  510, 484,  540, 454,  542, 452,  542, 450,  544, 450,  542, 452,  542, 450,  542, 450,  544, 452,  542, 452,  540, 454,  540, 454,  540, 456,  538, 478,  516, 478,  516, 480,  510, 484,  512, 482,  540, 456,  540, 452,  542, 450,  544, 450,  542, 450,  544, 450,  544, 450,  544, 450,  542, 452,  544, 452,  542, 452,  542, 454,  534, 2954,  3012, 8948,  520, 1470,  510, 484,  510, 482,  538, 456,  538, 454,  540, 454,  544, 450,  542, 452,  544, 450,  542, 1446,  544, 450,  544, 450,  544, 452,  542, 1450,  538, 1450,  538, 1472,  484, 510,  510, 1478,  538, 1452,  540, 1448,  542, 1446,  542, 1446,  544, 1444,  542, 1446,  542, 1448,  540, 456,  538, 454,  538, 478,  516, 1472,  512, 1476,  538, 1450,  540, 452,  544, 450,  544, 450,  542, 450,  544, 452,  544, 1444,  542, 452,  544, 452,  542, 1448,  540, 1448,  540, 478,  516, 1472,  484, 1502,  538, 456,  540, 454,  540, 452,  542, 450,  544, 450,  544, 450,  544, 450,  544, 450,  542, 454,  542, 452,  542, 1448,  540, 1450,  560};
// Mesg Desc.: Power: On, Mode: 1 (Cool), Temp: 20C, Fan: 5 (High), Swing: Off, Beep: Off, Clean: Off, Quiet: Off, Powerful: Off, Breeze: Off, Light: On, Ion: Off
const uint8_t state[1][14] = {
  { 0x02, 0x92, 0x0F, 0x00, 0x00, 0x00, 0xF0, 0x01, 0xC2, 0xFE, 0x71, 0x40, 0x1B, 0xF0 }
};

    
void setup() {

  Serial.begin(115200);
  Serial.println();
  
//  pinMode(LED_BUILTIN, OUTPUT);
//  digitalWrite(LED_BUILTIN, 0);     // turn on the LED Indicator in NodeMCU

  myStepper.setSpeed(200);

  for(int i = 0; i < 2; i++)
    pinMode(limitSwitch[i], INPUT);

  for(int i = 0; i < 4; i++) {
    pinMode(driverIN[i], OUTPUT);
    digitalWrite(driverIN[i], HIGH);
  }
  
  irsend.begin();
}

void loop() {
  // wait for WiFi connection
  if ((WiFiMulti.run() == WL_CONNECTED)) {
    WiFiClient client;
    HTTPClient http;

    Serial.println("[HTTP] begin...");
    if (http.begin(client, PersonalInfo::url)) {                           // Enter your http page URL
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
            if (payload.charAt(i) == '\"' && 
                payload.charAt(i + 1) == 'l' && 
                payload.charAt(i + 2) == 'a' && 
                payload.charAt(i + 3) == 'b' && 
                payload.charAt(i + 4) == 'e' && 
                payload.charAt(i + 5) == 'l') {
                  
              String buff = "false";
              buff = payload.substring(i + 10, i + 15);
              
              if (buff == "true ")  buttonState[index] = true;
              else                  buttonState[index] = false;
              
              index++;
              if (index == 2) {
                index = 0;
                break;
              }
            }
          }

          if (buttonState[0] == true && toggle[0] == false) {
            toggle[0] = true;
            while (switchState[0] == 0) {     // go to the end of the actuator
              myStepper.step(-stepsPerRevolution);
              switchState[0] = digitalRead(limitSwitch[0]);
              delay(1);
            }

            // after closing the window, decide whether turn on or off air conditoner
            
            // Need to code
            
            while (switchState[1] == 0) {     // return to the motor
              myStepper.step(stepsPerRevolution);
              switchState[1] = digitalRead(limitSwitch[1]);
              delay(1);
            }
            for (int i = 0; i < 3; i++) {     // for margin away motor
              myStepper.step(-stepsPerRevolution);
              delay(1);
            }

            for (int i = 0; i < 4; i++)
              digitalWrite(driverIN[i], HIGH);
          }
          else if (buttonState[0] == false) {
            toggle[0] = false;
            for (int i = 0; i < 2; i++)
              switchState[i] = digitalRead(limitSwitch[i]);
          }

          if (buttonState[1] == true && toggle[1] == false) {
            toggle[1] = true;
            Serial.println("Turn on the air conditional");
            irsend.sendSamsungAC(state[0]);
          }
          else if(buttonState[1] == false && toggle[1] == true) {
            toggle[1] = false;
            Serial.println("Turn off the air conditional");
            irsend.sendRaw(rawData, 349, 38);
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
    for (uint8_t t = 4; t > 0; t--) {
      Serial.printf("[SETUP] WAIT %d...\n", t);
      Serial.flush();
      delay(1000);
    }
  
    WiFi.mode(WIFI_STA);
    WiFiMulti.addAP(PersonalInfo::wifi_id, PersonalInfo::wifi_pw);
  }
  
  delay(1000);
}
