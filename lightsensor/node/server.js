/* global dependencies */
var express = require('express'),
    util = require('util'),
/* local dependencies */
    mongo = require(__dirname + '/../../deps/node/mongodb/lib/mongodb'),
    io = require(__dirname + '/../../deps/node/socket.io/lib/socket.io');

var app = express.createServer();
var socket = null;

/**
 * config stuff
 */
app.configure(function() {
    app.use(express.logger());
    app.use(express.bodyParser());
    app.use(app.router);
    app.use(express.static(__dirname + '/public'));
    app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));

    app.set('view engine', 'ejs');
});

/**
 * Mongo DB connection
 */
var db = new mongo.Db('arduino_sensors', new mongo.Server('localhost', mongo.Connection.DEFAULT_PORT, {}), {});
db.open(function(err, client) {
    if (err) {
        util.debug("error opening mongoDb connection "+err);
        throw err;
    }
    util.log("MongoDb connection opened");
});

/**
 * routing
 */
app.get('/', function(req, res) {
    db.collection('light', function(err, collection) {
        collection.find({}, {limit:600, sort:[['_id', 'desc']]}, function(err, cursor) {
            cursor.toArray(function(err, results) {
                res.render('index', {
                    'results': results
                });
            });
        });
    });
});

app.get('/sensors/light/:light', function(req, res) {
    var data = {};
    var dtime = new Date();
    data.time = dtime.getTime();
    data.light = req.params.light;
    db.collection('light', function(err, collection) {
        if (err) throw err;
        collection.insert(data, function(err, docs) {
            if (err) throw err;
            res.send(req.params.light);
            socket.broadcast(data);
        });
    });
});

/**
 * initialisation (app, sockets)
 */
app.listen(8124);

socket = io.listen(app);

socket.on('connection', function(client) {
    var clientId = client.sessionId;
});


/**
 * pre-route auth checks
 */
function authState(authed) {
    return function(req, res, next) {
        req._user = new User();
        if (typeof req.session.user === 'object') {
            req._user.setProperties(req.session.user);
            req._user.setAuthed(true);
        }
        if (authed === 'any') {
            next();
        } else {
            if (req._user.isAuthed() !== authed) {
                next(new Error('Incorrect auth state ['+req._user.isAuthed().toString()+']'));
            } else {
                next();
            }
        }
    }
}

function hasTeam(team) {
    return function(req, res, next) {
        if (team === null) {
            req._user.hasTeam() === false ?
                next() :
                next(new Error('Must not be on a team yet'));
        } else {
            req._user.getTeam() === team ?
                next() :
                next(new Error('Wrong team!'));
        }
    }
}
