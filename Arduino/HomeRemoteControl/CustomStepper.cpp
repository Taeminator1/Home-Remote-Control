//
//  CustomStepper.cpp
//  HomeRemoteControl
//
//  Create by Taemin Yun on 7/22/21
//  Copyright © 2020 Taemin Yun. All rights reserved.
//

//  Source file to control Stepper

#include "CustomStepper.h"

void CustomStepper::rotate(int stepVelocity) {
  step(stepVelocity);
  delay(stepDelay);
}

void CustomStepper::rotateWithSwitch(int switchPin, int stepVelocity) {
  while (digitalRead(switchPin) == 0)
    rotate(stepVelocity);
}

void CustomStepper::rotateRepeatedly(int repeatNumber, int stepVelocity) {
  for (int i = 0; i < repeatNumber; i++)
    rotate(stepVelocity);
}
