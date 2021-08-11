//
//  PersonalInfo.h
//  HomeRemoteControl
//
//  Create by Taemin Yun on 7/28/21
//  Copyright © 2020 Taemin Yun. All rights reserved.
//

//  Header file for Personal Information about network

#ifndef PERSONAL_INFO_H
#define PERSONAL_INFO_H

#include <Arduino.h>

class PersonalInfo {
public:
  static char url[];
  static char wifi_id[];
  static char wifi_pw[];
};

#endif
