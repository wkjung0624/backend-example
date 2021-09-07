/*
npm i axios cors redis mariadb express express-session connect-redis 

JSON Web Token 인증관련
npm i express-generator dotenv jsonwebtoken
https://ing-yeo.net/2020/02/study-nodejs-jwt-authorization/


redis 설치 관련
https://goni9071.tistory.com/473

https://redis.io/commands/command
*/

const fs = require('fs');
// const cors = require('cors');
// const axios = require('axios');
const redis = require('redis');
const session = require('express-session');
const connectRedis = require('connect-redis');
const RedisStore = connectRedis(session);
const redisClient = redis.createClient({
    host: '127.0.0.1',
    port: 6379
});
const db = {
    database: "mufun",
    host: "127.0.0.1",
    user: "root",
    password: "welcome9s"
};

const dbPool = require('mariadb').createPool(db);


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

// app.use(cors());
app.use(express.json());
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
              
              
fs.watchFile(__dirname + '/sql.js', (curr, prev) => {
    console.log('sql 변경시 재시작 없이 반영되도록 함.');
    delete require.cache[require.resolve('./sql.js')];
    sql = require('./sql.js');
  });        
            
// jwt token deploy
app.get('/api/login', async (req, res) => {
    res.json({
      message: 'hi'
    });
});



// using mariaDB
app.post('/api/:alias', async (req, res) => {
    try {
      res.send(await mariaDB.sendQuery(
        sql[req.params.alias].query,
        req.body.param,
        req.body.where))
    } catch (err) {
      res.status(500).send({
        error: err
      });
    } 
});       

// using redis
app.get('/api/market', async (req, res) => {
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

const mariaDB = {
  async sendQuery(query, param='', where=''){
    try{
      conn = await dbPool.getConnection();
      rows = await conn.query(query);
    }
    catch(err){
      throw err;
    }
    finally{
      if (conn) conn.end();
      return JSON.stringify(rows);
    }
  }
}

// const reqToDB = {
//   async db(alias, param = [], where = '') {
//     return new Promise((resolve, reject) => 
//       dbPool.query(sql[alias].query + where, param, (error, rows) => {
//         if (error) {
//           if (error.code != 'ER_DUP_ENTRY')
//             console.log(error);
//           resolve({error});
//         } else resolve(rows);
//       })
//     );
//   }
// };


/*
POST /api/testQuery HTTP/1.1
User-Agent: PostmanRuntime/7.28.4

Postman-Token: 2debb78e-6e22-49bc-9cc2-20458bc833a6
Host: 127.0.0.1:5000
Accept-Encoding: gzip, deflate, br
Connection: keep-alive
Content-Type: application/x-www-form-urlencoded
Content-Length: 25

param=testparam&where=skyship36

*/