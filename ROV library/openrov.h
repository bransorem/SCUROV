#ifndef __OPENROV_H_
#define __OPENROV_H_

#include "motor.h"

class OpenROV {
  private:
    Motor _vertical;
    Motor _left;
    Motor _right;
    
  public:
    OpenROV(){};
    OpenROV(Motor v, Motor p, Motor s);
    void setup();
    void forward(int);
    void reverse(int);
    void left(int);
    void right(int);
    void up(int);
    void down(int);
    void stop();
    
    Motor getMotorV(){ return _vertical; };
    Motor getMotorL(){ return _left; };
    Motor getMotorR(){ return _right; };
};

#endif