/**
 * receive board
 */

int data = 2;
int clock = 3;
int latch = 4;
int speakerPin = 9;

char buffer[8];
int recvCount = 0;
float currentLoad = 0.0;
int numCores = 1;
float scale = 100.0; // e.g. a load of 100 actually equals 1.00

// these apply after the load has been normalised based on scale and number of cores
float ranges[] = {
  0.00,  // off
  0.10,  // green
  0.50,  // green
  0.75,  // green
  1.00,  // yellow
  1.50,  // yellow
  2.0,   // yellow
  4.0,   // red
  8.0    // red
};

int currentIndex = 0;

int values[] = {
  0, 1, 3, 7, 15, 31, 63, 127, 255
};

float alarmStart = 6.0;
float alarmStop = 1.0;
boolean alarm = false;

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
      currentLoad = (float)value / scale;
      currentLoad /= (float)numCores;
      Serial.println(currentLoad);
      for (int i = 8; i >= 0; i--) {
        if (currentLoad >= ranges[i]) {
          // got current load range, that'll do
          currentIndex = i;
          Serial.println(i);
          break;
        }
      }      
      for (int i = 0; i < 8; i++) {
        buffer[i] = '\0';
      }
      recvCount = 0;
    } else {
      recvCount ++;
    }
  }
  digitalWrite(latch, LOW);
  shiftOut(data, clock, MSBFIRST, values[currentIndex]);
  digitalWrite(latch, HIGH);
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
