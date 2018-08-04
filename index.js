const express = require('express');
const app = express();
const mongoose = require('mongoose');
const bodyParser  = require('body-parser');
const morgan = require('morgan');

const port = process.env.PORT || 8080;

const mongoURI = "mongodb://mongodb:27017/test";
const MongoDB = mongoose.connect(mongoURI);

app.get('/', function(req, res) {
    res.send('Olar! The API is at http://localhost:' + port + '/api');
});

app.listen(port);