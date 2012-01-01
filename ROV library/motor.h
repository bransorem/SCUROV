#ifndef __MOTOR_H_
#define __MOTOR_H_

class Motor {
    private:
        int size;
        int enable_pin;
        int direction1_pin;
        int direction2_pin;
        void hbridge(int, int, int, int);
    
    public:
        Motor(){};
        Motor(int, int);
        Motor(int, int, int);
        void setup();
        void forward(int);
        void reverse(int);
        void invert();
        void stop();
};

#endif