/**
 * interweb light sensor
 */

#include <SPI.h> 
#include <Ethernet.h>

#define STATE_IDLE 0
#define STATE_WAITING 1
#define STATE_SEND 2
#define WAIT_TIME 30000

byte mac[] = { 0x90, 0xA2, 0xDA, 0x00, 0x3C, 0xFD };
byte ip[] = { 192, 168, 2, 10 };
byte server[] = { 192, 168, 2, 3 };

int state = STATE_IDLE;
unsigned long lastRead = 0;

Client client(server, 80);

void setup() {
    Serial.begin(9600);
    Ethernet.begin(mac, ip);
}

void loop() {

    switch (state) {
        case STATE_SEND: {
            Serial.print("reading sensor: ");
            int lightRead = analogRead(0);  // connected to pin zero
            Serial.println(lightRead);

            Serial.println("connecting...");
            if (client.connect()) {
                Serial.println("connected");
                client.print("GET /sensors/light/");
                client.println(lightRead);
                client.println();
                
                state = STATE_WAITING;
            } else {
                Serial.println("could not connect");
                state = STATE_IDLE;
            }
            break;
        }
        case STATE_WAITING: {
            if (client.available() > 0) {
                char data = client.read();
                Serial.print(data);
            } else {
                Serial.println("disconnecting");
                client.stop();
                state = STATE_IDLE;
            }
            break;
        }
        default:
            if (millis() - lastRead >= WAIT_TIME) {
                lastRead = millis();
                state = STATE_SEND;
            }
            break;
    }
}
