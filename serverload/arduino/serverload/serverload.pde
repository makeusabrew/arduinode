/**
 * shift register
 */

int data = 2;
int clock = 3;
int latch = 4;

void setup() {
  pinMode(data, OUTPUT);
  pinMode(clock, OUTPUT);
  pinMode(latch, OUTPUT);
}

void loop() {
  for (int i = 0; i < 256; i++) {
    digitalWrite(latch, LOW);
    shiftOut(data, clock, MSBFIRST, i);
    digitalWrite(latch, HIGH);
    
    delay(1000);
  }
}
