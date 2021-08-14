//
//  CustomStepper.h
//  HomeRemoteControl
//
//  Create by Taemin Yun on 7/22/21
//

//  Header file to control Stepper

#ifndef CUSTOM_STEPPER_H
#define CUSTOM_STEPPER_H

#include <Arduino.h>
#include <Stepper.h>

class CustomStepper : public Stepper {
private:
  int stepDelay;
public:
  CustomStepper(int steps, const int pins[], int stepDelay) : Stepper(steps, pins[0], pins[1], pins[2], pins[3]) {
    this->stepDelay = stepDelay;
  };
  void rotate(int stepVelocity);
  // Rotate until changing the state of pin
  void rotateWithSwitch(int switchPin, int stepVelocity);
  // Rotate repeatedly in specific times
  void rotateRepeatedly(int repeatNumber, int stepVelocity);
};

#endif
