//
//  SamsungIR.h
//  HomeRemoteControl
//
//  Create by Taemin Yun on 7/22/21
//  Copyright © 2020 Taemin Yun. All rights reserved.
//

//  Header file for IR Signal to control the Samsung airconditioner

#ifndef SAMSUNG_IR_H
#define SAMSUNG_IR_H

#include <Arduino.h>

class SamsungIR {
public:
  static uint16_t rawData[];
  static uint8_t state[][14];
};

#endif
