var express = require('express');
var app = express();
var mongoose = require('mongoose');
var port = process.env.PORT || 8080;

var mongoURI = "mongodb://mongodb:27017/test";
var MongoDB = mongoose.connect(mongoURI);

app.get('/', function(req, res) {
    res.send('Ola! The API is at http://localhost:' + port + '/api');
});

app.listen(port);