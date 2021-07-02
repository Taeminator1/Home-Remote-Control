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
  void rotateWithSwitch(int switchPin, int stepVelocity);
  void rotateRepeatedly(int repeatNumber, int stepVelocity);
};

#endif
