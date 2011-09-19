/**
 * serverload - relay data from serial input to XBEE out
 */
#include <stdlib.h>
char buffer[8];
int recvCount = 0;

void setup() {
  Serial.begin(9600);
  Serial.println("Starting up...");
}

void loop() {  
  if (Serial.available()) {      
    buffer[recvCount] = Serial.read();
    if (buffer[recvCount] == 13) { 
      Serial.print(buffer);
      for (int i = 0; i < 8; i++) {
        buffer[i] = '\0';
      }
      recvCount = 0;
    } else {
      recvCount ++;
    }
  }    
}
