/**
 * example invocation:
 *
 * node server.js my.redis-host.com myRedisPassword 3679

 * this should be run on a remote server whose load average you
 * want to monitor, and should be used in conjunction with relay.js
 */
var redis  = require('redis'),
    os     = require('os'),
    // argv[4] is the port
    client = redis.createClient(process.argv[4], process.argv[2]);

console.log("ServerLoad server process starting up...");

client.on('error', function(e) {
    console.log(e);
});

client.auth(process.argv[3]);

// cache the last load average we got so we don't spam the redis channel
var oldLoad = -1;

// crude loop to probe the server load. We could use fs.watchFile('/cat/loadavg')
// instead, but that would trigger too often
setInterval(function() {
    var load = os.loadavg();

    // the values we get out of the call to os.loadavg() have way too many decimal
    // places so let's make sure we only publish a new message if we really have to
    var rounded = roundValue(load[1], 2);
    if (rounded != oldLoad) {
        oldLoad = rounded;
        console.log("Publishing new load averages. 5 min val ["+rounded+"]");
        client.publish("serverload", JSON.stringify(load));
    }
    // it's worth noting that the load averages will be updated by the kernel
    // roughly every 5 seconds. Still, let's check more often so we don't
    // miss an update - otherwise we could be up to 10 seconds out. The important
    // thing is not to spam the redis channel (above) - over querying the load average is
    // unimportant by comparison
}, 1000);

function roundValue(val, places) {
    return Math.round(val*Math.pow(10, places))/Math.pow(10, places);
}
