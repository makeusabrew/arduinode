/**
 * example invocation:
 * node direct.js /dev/ttyAMC0
 *
 * Use this simple script to monitor the load of a local system attached to
 * an Arduino running serverload_send.pde or serverload_receive.pde. See relay.js
 * for instructions as to which is most suitable.
 */
var os     = require('os'),
SerialPort = require('serialport').SerialPort;

console.log("ServerLoad direct process starting up...");

// we expect the serial port as the only argument
var arduinoPort = new SerialPort(process.argv[2]);

// cache the last load average we got so we don't spam the redis channel
var oldLoad = -1;
setInterval(function() {
    var load = os.loadavg();

    var currentLoad = Math.round(load[1] * 100);
    if (currentLoad != oldLoad) {
        oldLoad = currentLoad;
        arduinoPort.write(currentLoad+"\r");
        console.log("Sending scaled value ["+currentLoad+"]");
    }
}, 1000);
