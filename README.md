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

### ServerLoad

A real time physical visualisation of a server's load average. Check the [write up](http://paynedigital.com/2011/09/arduinode-experiments-server-load)
on the [Payne Digital](http://paynedigital.com) website for more info.

License
-------

(The MIT License)

Copyright (C) 2011 by Nick Payne <nick@kurai.co.uk> 

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE
