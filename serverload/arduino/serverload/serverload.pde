/**
 * receive board
 */

int data = 2;
int clock = 3;
int latch = 4;
int speakerPin = 9;

char buffer[8];
int recvCount = 0;
int currentLoad = 0;

void setup() {
  pinMode(data, OUTPUT);
  pinMode(clock, OUTPUT);
  pinMode(latch, OUTPUT);
  pinMode(speakerPin, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  if (Serial.available()) {      
      buffer[recvCount] = Serial.read();
      if (buffer[recvCount] == 13) {
        buffer[recvCount] = 0;
        // got delimter, so process the input
        int value = atoi(buffer);  
        currentLoad = value;
        for (int i = 0; i < 8; i++) {
          buffer[i] = '\0';
        }
        //Serial.println("got carriage return");
        recvCount = 0;
      } else {
        recvCount ++;
      }
    }
  //for (int i = 0; i < 256; i++) {
    digitalWrite(latch, LOW);
    shiftOut(data, clock, MSBFIRST, currentLoad);
    digitalWrite(latch, HIGH);
    //playNote('c', 100);
    //Serial.println("played note");
    
   // delay(900);
  //}
}

/**
 * Note / tone logic courtesy of: http://ardx.org/src/circ/CIRC06-code.txt
 */
void playTone(int tone, int duration) {
  for (long i = 0; i < duration * 1000L; i += tone * 2) {
    digitalWrite(speakerPin, HIGH);
    delayMicroseconds(tone);
    digitalWrite(speakerPin, LOW);
    delayMicroseconds(tone);
  }
}

void playNote(char note, int duration) {
  char names[] = { 'c', 'd', 'e', 'f', 'g', 'a', 'b', 'C' };
  int tones[] = { 1915, 1700, 1519, 1432, 1275, 1136, 1014, 956 };
  
  // play the tone corresponding to the note name
  for (int i = 0; i < 8; i++) {
    if (names[i] == note) {
      playTone(tones[i], duration);
    }
  }
}
