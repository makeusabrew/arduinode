/**
 * Jenkins status lights
 */

#include <SPI.h>
#include <Ethernet.h>
#include <Udp.h>

#define ANIM_BRIGHTER 0
#define ANIM_DIMMER 1
#define ANIM_MAX 0
#define ANIM_MIN 255

byte mac[] = { 0x90, 0xA2, 0xDA, 0x00, 0x3C, 0xFD };
byte ip[] = { 192, 168, 2, 10 };

int statusPin[] = {7, 8, 9};
int activityPin[] = {3, 5, 6};

// activity LED stuff
bool activity = false;
// we refer to the pulsing of the activity LED as an animation
byte animBrightness = 255;
byte animDirection = ANIM_BRIGHTER;
String status;

// UDP stuff
byte remoteIp[4];
unsigned int remotePort;
char packetBuffer[UDP_TX_PACKET_MAX_SIZE];

void setup() {
  
  Serial.begin(9600);
  Ethernet.begin(mac, ip);
  Udp.begin(8888);
  
  for (int i = 0; i < 3; i++) {
    pinMode(statusPin[i], OUTPUT);
    pinMode(activityPin[i], OUTPUT);
    
    digitalWrite(statusPin[i], HIGH);
    analogWrite(activityPin[i], 255);
  }
  
}

void loop() {
  
  if (activity == true) {
    if (animDirection == ANIM_BRIGHTER) {
      animBrightness --;
    } else if (animDirection == ANIM_DIMMER) {
      animBrightness ++;
    }
    if (animBrightness == ANIM_MAX) {
      animDirection = ANIM_DIMMER;
    } else if (animBrightness == ANIM_MIN) {
      animDirection = ANIM_BRIGHTER;
    }
    /*
    Serial.print(animDirection);
    Serial.print(":");
    Serial.println(animStatus);
    */
    setActivityBrightness(status, animBrightness);
  }
  
  int packetSize = Udp.available();
  if (packetSize) {
    Serial.println("Incoming UDP packet...");
    Udp.readPacket(packetBuffer,UDP_TX_PACKET_MAX_SIZE, remoteIp, remotePort);    
    
    status = String(packetBuffer[0]);
    String animated = String(packetBuffer[1]);
    
    Serial.println(status);
    Serial.println(animated);
    
    setStatusColour(status);
    
    if (animated.compareTo("Y") == 0 && activity == false) {
      // we've just received a notification of activity
      // we could put some other initialisation stuff here
      animating = true;
    } else if (animated.compareTo("N") == 0 && activity == true) {
      // If we've been pulsing the activity LED but it's time to stop,
      // then turn out the LED
      setActivityColour(255, 255, 255);
      animating = false;
    }
  }
  delay(10);
}

void setStatusColour(String str) {
  if (str.compareTo("S") == 0) {
    setDigitalColour(statusPin, HIGH, LOW, HIGH);
  } else if (str.compareTo("U") == 0) {
    setDigitalColour(statusPin, LOW, LOW, HIGH);
  } else if (str.compareTo("F") == 0) {
    setDigitalColour(statusPin, LOW, HIGH, HIGH);
  }
}

void setActivityBrightness(String status, int brightness) {
  if (str.compareTo("S") == 0) {
    setAnalogColour(activityPin, 255, brightness, 255);
  } else if (str.compareTo("U") == 0) {
    setDigitalColour(statusPin, brightness, brightness, 255);
  } else if (str.compareTo("F") == 0) {
    setDigitalColour(statusPin, brightness, 255, 255);
  }
}

void setDigitalColour(int *pin, int r, int g, int b) {
  digitalWrite(pin[0], r);
  digitalWrite(pin[1], g);
  digitalWrite(pin[2], b);
}

void setAnalogColour(int *pin, int r, int g, int b) {
  analogWrite(activityPin[0], r);
  analogWrite(activityPin[0], g);
  analogWrite(activityPin[0], b);
}
