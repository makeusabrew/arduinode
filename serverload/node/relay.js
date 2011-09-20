/**
 * example invocation:
 *
 * node relay.js my.redis-host.com myRedisPassword 3679 /dev/ttyAMC0
 *
 * this should be run on a local system which is connected to an Arduino
 * via its serial port. It will receive messages from a server running server.js
 *
 * Note that the Arduino connected can be running either the serverload_send.pde
 * OR serverload_receive.pde. If you've got two XBee radios use serverload_send.pde
 * to relay the server load to a wireless Arduino running severload_receive.pde.
 *
 * If you haven't got any XBee radios, use serverload_send.pde to monitor the server
 * load directly - the only difference being the monitor isn't wireless.
 */
var redis      = require('redis'),
    SerialPort = require('serialport').SerialPort,
    client     = redis.createClient(process.argv[4], process.argv[2]);

console.log("ServerLoad relay process starting up...");

// we expect the serial port as the last argument
var arduinoPort = new SerialPort(process.argv[5]);

client.on('error', function(e) {
    console.log(e);
});

client.auth(process.argv[3]);
client.subscribe("serverload");

// let's cache the old server load so we don't spam the Arduino
var oldLoad = -1;
client.on('message', function(channel, message) {
    var load = null;
    try {
        load = JSON.parse(message);
    } catch (e) {
        console.log("Error decoding message");
        return;
    }
    var currentLoad = Math.round(load[1] * 100);
    if (currentLoad != oldLoad) {
        oldLoad = currentLoad;
        arduinoPort.write(currentLoad+"\r");
        console.log("Sending scaled value ["+currentLoad+"]");
    } else {
        console.log("Discarding load average - does not differ");
    }
});
