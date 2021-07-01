#ifndef TOGGLE_H
#define TOGGLE_H

#include <Arduino.h>

class Toggle {
private:
  bool externalState;         // store data in NodeMCU
  bool internalState;         // get data from web page
public:
  Toggle();
  void setExternalState(bool state);
  bool isTurnedOn();
  bool isTurnedOff();
};

#endif
