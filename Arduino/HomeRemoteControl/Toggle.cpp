#include "Toggle.h"

Toggle::Toggle() {
  externalState = false;
  internalState = false;
}

void Toggle::setExternalState(bool state) {
  externalState = state;
}

bool Toggle::isTurnedOn() {
  if (externalState == true && internalState == false) {
    internalState = true;
    return true;
  }
  else {
    return false;
  }
}

bool Toggle::isTurnedOff() {
  if (externalState == false && internalState == true) {
    internalState = false;
    return true;
  }
  else {
    return false;
  }
}
