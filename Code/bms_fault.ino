//Header File
#include <Wire.h>
#include <OneWire.h>
#include <DallasTemperature.h>
#include <LiquidCrystal.h>
LiquidCrystal lcd(2,3,4,5,6,7);
#include <SoftwareSerial.h>
SoftwareSerial mySerial(10, 11);

//Temperature Sensor Define I/O
#define ONE_WIRE_BUS1 A0
OneWire oneWire1(ONE_WIRE_BUS1);
DallasTemperature sensors1(&oneWire1);

#define ONE_WIRE_BUS2 A1
OneWire oneWire2(ONE_WIRE_BUS2);
DallasTemperature sensors2(&oneWire2);

int analogInPin1  = A2;    // Analog input pin PRIMARY
int sensorValue1;

//Key
int ke = A4;
int key = 0;
int keystatus = 0;

//Fire Sensor
int firev = A3;
int fire = 0;

// Vibration Sensor
int vibv = A5;
int vib = 0;

int buzzer = 13;
int motor = 11;
int fan = 12;
int on_d = 0;

int incomingByte = 0;

void setup() {
  // put your setup code here, to run once:
  //pinMode(analogtemp,INPUT);
  
  pinMode(analogInPin1, INPUT);
  pinMode(ke, INPUT);
  pinMode(firev, INPUT);
  pinMode(vibv, INPUT);
  pinMode(buzzer, OUTPUT);
  pinMode(fan, OUTPUT);
  pinMode(motor, OUTPUT);

  //Temp Sensor
  sensors1.begin();
  sensors2.begin();
  mySerial.begin(9600);

  Serial.begin(9600);  // begin serial port with baud rate 9600bps
  lcd.begin(16, 2);
  lcd.print(" IOT BASED EV ");
  lcd.setCursor(0, 1);
  lcd.print(" BATTERY MANAG.");
  delay(1900);
  digitalWrite(buzzer, HIGH);
  lcd.clear();
  delay(250);
  digitalWrite(buzzer, LOW);
  digitalWrite(motor, HIGH);
  digitalWrite(fan, HIGH);
}

void loop() {
  // put your main code here, to run repeatedly:

  //Key
  key = digitalRead(ke);

  fire = digitalRead(firev);

  vib = digitalRead(vibv);

  // Temperature Sensor
  sensors1.requestTemperatures();
  // Calculate the average value from all "j1" readings.
  int tempvv1 = sensors1.getTempCByIndex(0);

  sensors2.requestTemperatures();
  // Calculate the average value from all "j1" readings.
  int tempvv2 = sensors2.getTempCByIndex(0);

  //Bat 1
  sensorValue1 = analogRead(analogInPin1);
  float bvolt1 = (((sensorValue1 * 7) / 1024));

  //Bat 1 Percentage
  int batper1 = mapfloat(bvolt1, 1.8, 4.2, 0, 100); //2.8V as Battery Cut off Voltage & 4.2V as Maximum Voltage
  if (batper1 >= 100)
  {
    batper1 = 100;
  }
  if (batper1 <= 0)
  {
    batper1 = 1;
  }

  lcd.setCursor(0, 0);
  lcd.print("BT:");
  lcd.print(tempvv1);

  lcd.setCursor(0, 1);
  lcd.print("VT:");
  lcd.print(tempvv2);

  lcd.setCursor(6, 0);
  lcd.print("BV:");
  lcd.print(bvolt1);

  lcd.setCursor(6, 1);
  lcd.print("VV:");
  lcd.print(vib);

  lcd.setCursor(12, 1);
  lcd.print("F:");
  lcd.print(fire);

  if (key == HIGH) {
    if (keystatus == 0) {
      keystatus = 1;
      digitalWrite(buzzer, HIGH);
      delay(100);
      digitalWrite(buzzer, LOW);
      digitalWrite(motor, LOW);
      on_d = 1;
      //lcd.setCursor(8, 0);
      //lcd.print("K:ON");
    } else {
      keystatus = 0;
      digitalWrite(buzzer, HIGH);
      //lcd.setCursor(8, 0);
      //lcd.print("K:OF");
      digitalWrite(motor, HIGH);
      delay(500);
      digitalWrite(buzzer, LOW);
      on_d = 0;
    }
    delay(500);
  }

  if(tempvv1 >= 36){
    digitalWrite(buzzer, HIGH);
    digitalWrite(fan, LOW);
    delay(250);
    digitalWrite(buzzer, LOW);
    //lcd.setCursor(13, 0);
    //lcd.print("B:S");
  }
  else{
    digitalWrite(fan, HIGH);
    //lcd.setCursor(13, 0);
    //lcd.print("B:P");
  }

  if(bvolt1 <= 2){
    digitalWrite(motor, HIGH);
    digitalWrite(buzzer, HIGH);
    delay(250);
    digitalWrite(buzzer, LOW);
    //lcd.setCursor(13, 0);
    //lcd.print("B:S");
  }

  else if(tempvv2 >= 36){
    digitalWrite(motor, HIGH);
    digitalWrite(buzzer, HIGH);
    delay(250);
    digitalWrite(buzzer, LOW);
    delay(250);
  }
  else{
    digitalWrite(motor, LOW);
  }

  
  Serial.print(tempvv1);
  Serial.print(" ");
  Serial.print(tempvv2);
  Serial.print(" ");
  Serial.print(bvolt1);
  Serial.print(" ");
  Serial.print(fire);
  Serial.print(" ");
  Serial.print(vib);
  Serial.println();

  delay(1000);
}

float mapfloat(float x, float in_min, float in_max, float out_min, float out_max)
{
  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}
