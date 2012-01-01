#include <motor.h>
#include <openrov.h>
#include <PS2X_lib.h>

PS2X ps2x;

Motor v(11, 12, 13);
Motor l(6, 7, 8);
Motor r(3, 4, 5);
OpenROV rov(v, l, r);

int error = 0;
byte vibrate = 0;

byte leftY;
byte leftX;
byte rightY;
byte rightX;
byte led = 9;
boolean started;

// range math
byte deadband;
byte trimL, trimR, trimV;
byte centerL, centerR, centerV;
byte nullTopL, nullTopR, nullTopV;   
byte nullBottomL, nullBottomR, nullBottomV;

void setup(){
 
  // initialize the serial communication:
  Serial.begin(57600);
  
  rov.setup();
  
  // Setup Eric's functions - don't remove!!
  setup_ps2();
}

void loop(){
  
  // Eric's work - don't remove!!
  check_ps2();

  analogWrite(led, leftX);
}



void check_ps2(){
  ps2x.read_gamepad(false, vibrate);
  
  if (ps2x.Button(PSB_START)){
    started = true;
  }
  
  if (started){
    leftY = ps2x.Analog(PSS_LY);
    rightY = ps2x.Analog(PSS_RY);
    leftX = ps2x.Analog(PSS_LX);

    /* ************************************************** */
    /* ************* Set trim for thrusters ************* */
    if (ps2x.Button(PSB_L1) && ps2x.Button(PSB_R1)){
      set_ps2_defaults((255 - leftY), (255 - rightY), (255 - leftX), deadband);
    }
    
    // Cancel (aka reset to defaults)
    if (ps2x.ButtonPressed(PSB_RED)){
      set_ps2_defaults(127, 127, 127, deadband);
    }
    
    /* ************************************************** */
    /* ************* Control ROV thrusters ************** */
    if (!(leftY == 255 && rightY == 255 && leftX == 255)){
      vertical();
      left();
      right();
    }
  }
  
  delay(20);
}

void vertical(){
  // UP
  if (leftX < nullBottomV){
    int velocity = map(leftX, nullBottomV, 0, 0, 255);
    rov.up(velocity);
  }
  // DOWN
  if (leftX > nullTopV){
    int velocity = map(leftX, nullTopV, 255, 0, 255);
    rov.down(velocity);
  }
}

void left(){
  // Left stick forward
  if (leftY < nullBottomL){
    int velocity = map(leftY, nullBottomL, 0, 0, 255);
    rov.getMotorL().forward(velocity);
  }
  // Left stick backward
  else if (leftY > nullTopL){
    int velocity = map(leftY, nullTopL, 255, 0, 255);
    rov.getMotorL().reverse(velocity);
  }
}

void right(){
  // Right stick forward
  if (rightY < nullBottomR){
    int velocity = map(rightY, nullBottomR, 0, 0, 255);
    rov.getMotorR().forward(velocity);
  }
  // Right stick backward
  else if (rightY > nullTopR){
    int velocity = map(rightY, nullTopR, 255, 0, 255);
    rov.getMotorR().reverse(velocity);
  }
}

void setup_ps2(){
  // Setup PS2 controller
  error = ps2x.config_gamepad(17, 15, 14, 16, true, true); 
  
  started = true;  // make false to check for start button pressed at beginning

  // initialize the pins as an outputs:
  for (int i = 2; i < 9; i++)
    pinMode(i, OUTPUT);
  for (int i = 11; i < 14; i++)
    pinMode(i, OUTPUT);
    
  // SET DEADBAND DEFAULT
  deadband = 20;
    
  set_ps2_defaults(127, 127, 127, deadband);
  trimV = 0;
  trimL = 0;
  trimR = 0;
}

void set_ps2_defaults(byte cL, byte cR, byte cV, byte dband){
  
  centerL = cL;
  nullTopL = centerL + dband;   
  nullBottomL = centerL - dband;
  
  centerR = cR;
  nullTopR = centerR + dband;   
  nullBottomR = centerR - dband;
  
  centerV = cV;
  nullTopV = centerV + dband;   
  nullBottomV = centerV - dband;
}
