var os         = require('os');
    SerialPort = require("serialport").SerialPort,
    redis      = require('redis'),
    client     = redis.createClient(process.argv[4], process.argv[2]);

var arduinoPort = new SerialPort(process.argv[5]);

client.on('error', function(e) {
    console.log(e);
});

console.log("ServerLoad relay process starting up...");

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
    var currentLoad = Math.round(load[0] * 100);
    if (currentLoad != oldLoad) {
        oldLoad = currentLoad;
        arduinoPort.write(currentLoad+"\r");
        console.log("Sending scaled value ["+currentLoad+"]");
    } else {
        console.log("Discarding load average - does not differ");
    }
});
