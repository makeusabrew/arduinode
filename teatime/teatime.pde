
float scale = 3.92157;  // this is between the FSR's max reading (0-1000) and the range of analogWrite (0-255)

void setup() {
  Serial.begin(9600);
  pinMode(2, INPUT);
}

void loop() {
  int val = analogRead(2);
  int final = (int)(val / scale);
  Serial.print(val);
  Serial.print(" - ");
  Serial.println(final);
  analogWrite(6, final);
  delay(100);
}
