#include <Servo.h> 
#include <TimerOne.h>

volatile int Counts= 0;  //This variable will increase or decrease depending on the rotation of encoder

double SetSpeed = 1;
double CurrentSpeed = 0;
double Output = 0;
double temp = 0;

double errSum = 0;
double lastErr = 0;

double Kp = 130;
double Kd = 70;
double Ki = 0;

double PID_Frequency = 10;

Servo steerServo;
Servo driveServo;
int steerPin = 8;
int drivePin = 9;

double lastCounts = 0;

void setup()
{
  Serial.begin(9600);

  InitialiseActuators();
  InitialiseEncoder();

  Timer1.initialize(1000000*1/PID_Frequency); // set a timer of length 100000 microseconds (or 0.1 sec - or 10Hz => the led will blink 5 times, 5 cycles of on-and-off, per second)
  Timer1.attachInterrupt(ComputePID); // attach the service routine here
}

void loop()
{ 
  PrintStatus();
}

void PrintStatus() {
  Serial.print("SetSpeed: ");
  Serial.print(SetSpeed);
  Serial.print("\t CurrentSpeed: ");
  Serial.print(CurrentSpeed);
  Serial.print("\t MotorOutput: ");
  Serial.println(temp);
}

void InitialiseActuators() {
  //pinMode(drivePin, OUTPUT);
  //analogWrite(drivePin,0); // turn off drive motor

  driveServo.attach(drivePin);
  driveServo.write(0);
  
  steerServo.attach(steerPin); // attach steer servo
  steerServo.write(90); // set servo to center
}

void InitialiseEncoder() {
  pinMode(2, INPUT);           // set pin to input
  pinMode(3, INPUT);           // set pin to input
  digitalWrite(2, HIGH);       // turn on pullup resistors
  digitalWrite(3, HIGH);       // turn on pullup resistors
  
  //A rising pulse from encodenren activated ai0(). AttachInterrupt 0 is DigitalPin 2 on moust Arduino.
  attachInterrupt(0, EncoderInterrupt0, RISING);
  //B rising pulse from encodenren activated ai1(). AttachInterrupt 1 is DigitalPin 3 on moust Arduino.
  attachInterrupt(1, EncoderInterrupt1, RISING);
}

void EncoderInterrupt0() {
  // Activated if DigitalPin 2 is going from LOW to HIGH, Rising Edge
  // Check pin 3 to determine the direction
  if (digitalRead(3) == LOW) {
    Counts++;
  } else {
    Counts--;
  }
}

void EncoderInterrupt1() {
  // Activated if DigitalPin 3 is going from LOW to HIGH, Rising Edge
  // Check with pin 2 to determine the direction
  if (digitalRead(2)==LOW) {
    Counts--;
  } else {
    Counts++;
  }
}

void ComputePID() {
  CurrentSpeed = (lastCounts - Counts) * 0.00008307095959 * PID_Frequency;
  lastCounts = Counts;
  
  double error = SetSpeed - CurrentSpeed;
  errSum += error;
  double dErr = (error - lastErr);

  /*Compute PID Output*/
  Output = Kp * error + Ki * errSum + Kd * dErr;
  temp = map(Output,0,255,1505,1550);
  driveServo.write(temp);

  /*Remember some variables for next time*/
  lastErr = error;
}



