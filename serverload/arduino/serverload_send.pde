/**
 * serverload - relay data from serial input to XBee output
 */
char buffer[8];
int recvCount = 0;

void setup() {
  Serial.begin(9600);
  Serial.println("Starting up...");
}

void loop() {  
  if (Serial.available()) {
    // N.B Serial is USB serial, NOT XBee    
    buffer[recvCount] = Serial.read();
    
    // ASCII code 13 is a carriage return - our delimiter
    if (buffer[recvCount] == 13) {
      
      // print it to Serial output - both USB and XBee
      Serial.print(buffer);
      
      // reset our buffer string
      memset(buffer, '\0', sizeof(buffer));
      recvCount = 0;
    } else {
      // if we didn't get a carriage return then make sure the
      // next byte we read in is added to the correct buffer slot
      recvCount ++;
    }
  }    
}
