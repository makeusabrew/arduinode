var redis  = require('redis'),
    os     = require('os'),
    client = redis.createClient(process.argv[4], process.argv[2]);

client.on('error', function(e) {
    console.log(e);
});

console.log("ServerLoad server process starting up...");

client.auth(process.argv[3]);

var oldLoad = -1;
setInterval(function() {
    var load = os.loadavg();
    var rounded = roundValue(load[0], 2);
    if (rounded != oldLoad) {
        oldLoad = rounded;
        console.log("Publishing new load averages ("+rounded+")");
        client.publish("serverload", JSON.stringify(load));
    }
}, 500);

function roundValue(val, places) {
    return Math.round(val*Math.pow(10, places))/Math.pow(10, places);
}
