#if ARDUINO < 100
#include <WProgram.h>
#else
#include <Arduino.h>
#endif

#include "motor.h"

Motor::Motor(int p1, int p2){
    size = 2;
    enable_pin = p1;
    direction1_pin = p2;
}

Motor::Motor(int p1, int p2, int p3){
    size = 3;
    enable_pin = p1;
    direction1_pin = p2;
    direction2_pin = p3;
}

void Motor::setup(){
    pinMode(enable_pin, OUTPUT);
    pinMode(direction1_pin, OUTPUT);
    if (size == 3) pinMode(direction2_pin, OUTPUT);
}

void Motor::forward(int percent){
    hbridge(direction1_pin, direction2_pin, enable_pin, percent);
}

void Motor::reverse(int percent){
    hbridge(direction2_pin, direction1_pin, enable_pin, percent);
}

// Changes direction of motor
void Motor::invert(){
    int temp = direction1_pin;
    direction1_pin = direction2_pin;
    direction2_pin = temp;
}

void Motor::stop(){
    hbridge(direction1_pin, direction2_pin, enable_pin, 0);
}

void Motor::hbridge(int high, int low, int enable, int speed){
    speed = map(speed, 0, 100, 0, 255);
    Serial.println(speed);
    digitalWrite(high, HIGH);
    digitalWrite(low, LOW);
    analogWrite(enable, speed);
}