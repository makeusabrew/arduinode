/* global dependencies */
var util = require('util'),
    http = require('http'),
    dgram = require('dgram'),
/* local dependencies */
    mongo = require(__dirname + '/../../deps/node/mongodb/lib/mongodb'),
/* local classes */
    JenkinsClient = require('./jenkins').JenkinsClient;

/*
var colourScores = {
    'red': 0,
    'red_anime': 1,
    'yellow': 4,
    'yellow_anime': 5,
    'blue': 10,
    'blue_anime': 10
};
*/

var jenkinsClient = new JenkinsClient({
    username: process.argv[2],
    password: process.argv[3],
    host: process.argv[4]
});

var oldStatus = null;
var oldAnimated = null;

setInterval(function() {
    jenkinsClient.getJobs(function(jobs) {
        var status = 'S';
        var animated = 'N';
        for (var i = 0; i < jobs.length; i++) {
            var job = jobs[i];

            if (job.color.indexOf('red') !== -1) {
                status = 'F';
            } else if (job.color.indexOf('yellow') !== -1 && status == 'S') {
                status = 'U';
            }
            
            if (job.color.indexOf('anime') !== -1) {
                // animated mode, let arduino know
                animated = 'Y';
            }
        }

        if (status != oldStatus || animated != oldAnimated) {
            util.debug(status + ' - ' + oldStatus);
            util.debug(animated + ' - ' + oldAnimated);
            oldStatus = status;
            oldAnimated = animated;

            var udpClient = dgram.createSocket('udp4');
            var msg = new Buffer(status+animated);
            util.debug(msg);
            udpClient.send(msg, 0, msg.length, 8888, '192.168.2.10', function(err, bytes) {
                if (err) throw err;
                util.debug('Wrote ' + bytes + ' bytes');
                udpClient.close();
            });
        }
    });
}, 5000);
