var os = require('os');
var serialport = require("serialport");
var SerialPort = serialport.SerialPort;

var arduinoPort = new SerialPort("/dev/ttyACM0");

setInterval(function() {
    var load = os.loadavg();
    var currentLoad = Math.round(load[0] * 100);
    arduinoPort.write(currentLoad+"\r");
    console.log("written "+currentLoad);
    //console.log(arduinoPort);
}, 250);
