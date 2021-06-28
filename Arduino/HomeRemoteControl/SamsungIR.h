#ifndef SAMSUNG_IR_H
#define SAMSUNG_IR_H

#include <Arduino.h>

class SamsungIR {
public:
  static uint16_t rawData[];
  static uint8_t state[][14];
};

#endif
