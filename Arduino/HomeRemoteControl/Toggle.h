#ifndef TOGGLE_H
#define TOGGLE_H

#include <Arduino.h>

class Toggle {
private:
  bool eState;                // Extenernal State:  get data from web page
  bool iState;                // Internal State:    store data in NodeMCU
public:
  Toggle();
  void setEState(bool state);
  void syncIStateWithEState();
  bool isTurnedOn();
  bool isTurnedOff();
};

#endif
