/*
npm i axios cors express express-session connect-redis 
https://redis.io/commands/command
*/

const fs = require('fs');
const cors = require('cors');
const redis = require('redis');
// const axios = require('axios');
const session = require('express-session');
const connectRedis = require('connect-redis');
const RedisStore = connectRedis(session);
const redisClient = redis.createClient({
    host: '127.0.0.1',
    port: 6379
});
const db = {
    database: "dev_class",
    connectionLimit: 10,
    host: "127.0.0.1",
    user: "root",
    password: "mariadb"
};
const express = require('express')
const app = express();

// redisClient.on('error', function (err) {
//     console.log('redis server not connected')
// });

// redisClient.on('connect', function (err) {
//     console.log('redis connect')
// });

const http = require('http');
const server = http.createServer(app);

let sql = require('./sql.js');

fs.watchFile(__dirname + '/sql.js', (curr, prev) => {
    console.log('sql 변경시 재시작 없이 반영되도록 함.');
    delete require.cache[require.resolve('./sql.js')];
    sql = require('./sql.js');
  });

app.use(express.json());
app.use(cors());
app.use(express.urlencoded({
    extended: true
}));
// For parsing application/x-www-form-urlencoded

app.use(session({
    secret: 'secret$%12',
    resave: false,
    saveUninitialized: false,
    cookie: {
        secure: false,
        maxAge: 1000 * 60 * 60 // 쿠키 유효시간 1시간
    },
    store: new RedisStore({
        client: redis,
        host: 'localhost',
        port: 6379,
        prefix: 'session:',
        db: 0,
        saveUninitialized: false,
        resave: false
    })
}));

app.get('/', function (req, res) {
    console.log("TE2ST");
    redisClient.set('foo', 'barz', (err, reply) => {
        redisClient.get('foo', (err, reply) => {
            // if (err) throw err;
            console.log(reply);
        })
    })
    res.status(404).send('Not found');
});

app.get('/api', async (req, res) => {
    console.log(req.query.key);
    console.log(req.query.value);
    //res.send(await req.db(request.params.alias, request.body.param, request.body.where));
    redisClient.set(req.query.key, req.query.value);
    redisClient.get(req.query.key, (err, reply) => {
        console.log(reply);
    })

    res.status(404).send('Not found');
});


server.listen(5000, function () {
    console.log('Express server listening on port ' + server.address().port);
});