#include "CustomStepper.h"

void CustomStepper::rotate(int stepVelocity) {
  step(stepVelocity);
  delay(stepDelay);
}

void CustomStepper::rotateWithSwitch(int switchPin, int stepVelocity) {
  while (digitalRead(switchPin) == 0)       // Until changing the state of pin
    rotate(stepVelocity);
}

void CustomStepper::rotateRepeatedly(int repeatNumber, int stepVelocity) {
  for (int i = 0; i < repeatNumber; i++)    // Repeat in specific times
    rotate(stepVelocity);
}
