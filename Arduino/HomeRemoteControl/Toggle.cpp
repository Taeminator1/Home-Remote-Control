//
//  Toggle.cpp
//  HomeRemoteControl
//
//  Create by Taemin Yun on 8/4/21
//

//  Source file to synchronize toggles in NodeMCU and Server

#include "Toggle.h"

Toggle::Toggle() {
  eState = false;
  iState = false;
}

void Toggle::setEState(bool state) {
  eState = state;
}

void Toggle::syncIStateWithEState() {
  iState = eState;
}

bool Toggle::isTurnedOn() {
  if (eState == true && iState == false) {
    iState = true;
    return true;
  }
  else {
    return false;
  }
}

bool Toggle::isTurnedOff() {
  if (eState == false && iState == true) {
    iState = false;
    return true;
  }
  else {
    return false;
  }
}
