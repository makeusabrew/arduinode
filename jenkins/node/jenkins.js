var http = require('http'),
    util = require('util');

exports.JenkinsClient = function(options) {

    this.getJobs = function(callback) { 
        var opts = {
            host: options.host,
            path: '/api/json',
            port: 80,
            headers: {
                authorization: 'Basic ' + new Buffer(options.username + ':' + options.password).toString('base64')
            }
        };

        var data = '';

        http.get(opts, function(res) {
            res.on('data', function(chunk) {
                data += chunk;
            });
            res.on('end', function() {
                // super!
                data = JSON.parse(data);
                callback(data.jobs);
            });
        });
    }

};
