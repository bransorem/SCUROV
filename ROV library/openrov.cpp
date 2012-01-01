#include "openrov.h"
#include "motor.h"

OpenROV::OpenROV(Motor v, Motor p, Motor s){
  _vertical = v;
  _left = p;
  _right = s;
}

void OpenROV::setup(){
  _vertical.setup();
  _left.setup();
  _right.setup();
}

void OpenROV::forward(int percent){
  _left.forward(percent);
  _right.forward(percent);
}
void OpenROV::reverse(int percent){
  _left.reverse(percent);
  _right.reverse(percent);
}
void OpenROV::left(int percent){
  _left.reverse(percent);
  _right.forward(percent);
}
void OpenROV::right(int percent){
  _left.forward(percent);
  _right.reverse(percent);
}
void OpenROV::up(int percent){
  _vertical.forward(percent);
}
void OpenROV::down(int percent){
  _vertical.reverse(percent);
}
void OpenROV::stop(){
  _vertical.stop();
  _left.stop();
  _right.stop();
}