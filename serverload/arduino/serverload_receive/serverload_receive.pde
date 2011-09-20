/**
 * ServerLoad - receive sketch
 *
 * This sketch is responsible for receiving data via Serial (XBee or USB) and interpreting
 * the values received as server loads. It then activates up to 8 LEDs based on the load
 * as well as an alarm if the load is particularly dangerous.
 */

// pin stuff
int data       = 2;
int clock      = 3;
int latch      = 4;
int speakerPin = 9;

char buffer[8];
int recvCount     = 0;
float currentLoad = 0.0;
int numCores      = 1;     // how many cores does the target server have?
float scale       = 100.0; // e.g. a load of 100 actually equals 1.00

// these apply after the load has been normalised based on scale and number of cores
float ranges[] = {
  0.00,  // off
  0.10,  // green
  0.25,  // green
  0.50,  // green
  0.75,  // yellow
  1.00,  // yellow
  1.75,  // yellow
  2.00,  // red
  5.00   // red
};

int shiftVal = 0;
float alarmStart = 2.0;
float alarmStop = 1.0;
boolean alarmTriggered = false;

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
      
      // for simplicity, the input is scaled from 1.00 -> 100
      // so scale it back down
      currentLoad = (float)value / scale;
      
      // now divide it by the number of cores to normalise it
      currentLoad /= (float)numCores;
      
      // debug output showing the normalised load average
      Serial.println(currentLoad);
      
      // work out the highest range this load average fits into
      for (int i = 8; i >= 0; i--) {
        if (currentLoad >= ranges[i]) {
          Serial.println(i);
          if (i > 0) {
            shiftVal = (1 << i) -1;
          } else {
            // bit shifting doesn't work if i is 0
            shiftVal = 0;
          }
          break;
        }
      }
     
      // reset the input buffer 
      memset(buffer, '\0', sizeof(buffer));
      recvCount = 0;
      
      // alarm stuff
      if (alarmTriggered && currentLoad <= alarmStop) {
        // do any one time "hooray, panic over" stuff here
        alarmTriggered = false;
      } else if (!alarmTriggered && currentLoad >= alarmStart) {
        // do any one time "uh oh, meltdown" stuff here
        alarmTriggered = true;
      }
    } else {
      // if we didn't get a carriage return then make sure the
      // next byte we read in is added to the correct buffer slot
      recvCount ++;
    }
  }
  
  // write the current value to the shift register
  digitalWrite(latch, LOW);  
  shiftOut(data, clock, MSBFIRST, shiftVal);
  digitalWrite(latch, HIGH);
  
  // alarm mode? play some annoying stuff
  if (alarmTriggered) {
    playNote('f', 250);
    playNote('d', 250);
  }
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
