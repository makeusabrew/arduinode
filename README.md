Arduinode
=========

Arduino's cool. Node's cool. Let's see what we can get up to when we stick the two together!

This project will contain various experiments in various states of working order. They'll likely
be pretty rough and ready code too - at the moment the projects are just crude prototypes so
be warned!

Code Disclaimer
---------------

Most of the code here is written in as simplistic, easy-to-read manner as possible, except for
the odd bit where I got carried away and wanted to write something fun. At some point, I'll
actually comment it properly to make the projects more tutorial-esque

Projects
--------

### lightsensor

A crude experiment in taking environmental data from an arduino and sending it to a web server
(powered by node, obviously) via the Arduino Ethernet shield. On the node side, we listen out
on a URL and then bang the incoming information in a mongo collection before updating any
web clients we have watching the home page URL, who'll get a beautifully rendered graph. Well,
a graph.

### Jenkins API Client

A simple cient which polls the Jenkins API for a list of job statuses, does some quick and
dirty processing on them and then sends a UDP packet to an Arduino. The Arduino has two LEDs,
one of which indicating the overall status of all projects and one indicating any activity.
