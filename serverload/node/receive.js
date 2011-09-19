var serialport = require("serialport");
var SerialPort = serialport.SerialPort;

var arduinoPort = new SerialPort("/dev/ttyACM1");
console.log(arduinoPort);
setInterval(function() {
    var counter = Math.floor(Math.random() * 256);
    arduinoPort.write(counter+"\r");
    console.log("written "+counter);
    //console.log(arduinoPort);
}, 250);
