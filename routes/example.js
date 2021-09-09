/*
설치모듈 
  npm i axios cors redis mariadb express express-session connect-redis 

restful 한 구조로
--?

node.js 시스템 구조 관련(route-controller)
  https://codingcoding.tistory.com/1308
  https://velog.io/@neity16/NodeJS-%EB%A1%9C%EC%A7%81-%EB%B6%84%EB%A6%ACroutesmodels-controllers

kakao redirect 관련
  https://kakao-tam.tistory.com/35
  https://developers.kakao.com/docs/latest/ko/kakaologin/rest-api#request-code

O: passport 카카오 JWT 인증관련 (passport.js)
  npm i passport passport-kakao
  https://minhyeok-rithm.tistory.com/entry/20210706-Kakao-Login
  https://sangminlog.tistory.com/entry/kakao-login
  http://www.passportjs.org/packages/passport-kakao/
  https://kakao-tam.tistory.com/65

X: JSON Web Token 인증관련
  npm i express-generator dotenv jsonwebtoken
  https://ing-yeo.net/2020/02/study-nodejs-jwt-authorization/

redis 관련
  https://goni9071.tistory.com/473
  https://redis.io/commands/command

node.js 구조
  https://seoyeonkk.tistory.com/entry/Nodejs-%EB%8F%99%EC%9E%91-%EC%9B%90%EB%A6%AC

curl
  -d = body param 데이터
  -H = Header
*/

const fs = require('fs'); // 파일시스템?? 파일관리 모듈인듯
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

const passport = require('passport');
const KakaoStrategy = require('passport-kakao').Strategy;

const express = require('express')
const app = express();

const kakaocallbackurl = '/oauth/kakao/callback'
// redisClient.on('error', function (err) {
//     console.log('redis server not connected')
// });

// redisClient.on('connect', function (err) {
//     console.log('redis connect')
// });

const http = require('http');
const server = http.createServer(app);

let sql = require('../config/sql.js');
const exp = require('constants');

// app.use(cors());
app.use(express.json());
app.use(express.urlencoded({
    extended: true
}));
// For parsing application/x-www-form-urlencoded
app.use(passport.initialize())
app.use(passport.session())
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

passport.use(new KakaoStrategy({
    clientID: '16fe234230416b76f219eef43b4488fb',// process.env.KAKAO_ID, // 내 앱의 REST API
    callbackURL: "http://localhost:5000/oauth/kakao/callback", // 카카오 디벨로퍼에 적어놓은 redirect uri와 같아야 한다
  }, 
  async(accessToken, refreshToken, profile, done) => { // 사용자가 유효한지 확인하는 verify 콜백함수 
    // accessToken과 refreshToken: 인증을 유지시켜주는 토큰
    // profile: 사용자 정보 객체
    // done(error, user): passport-twitter가 자체적으로 req.login와 serializeUser 호출하여 req.session에 사용자 아이디를 저장한다
    try{
      console.log(accessToken);
      console.log(profile);
      return done(null,profile);
    }catch(err){
      return done(err)
    }
  })
);


fs.watchFile(__dirname + '/sql.js', (curr, prev) => {
    console.log('sql 변경시 재시작 없이 반영되도록 함.');
    delete require.cache[require.resolve('../config/sql.js')];
    sql = require('../config/sql.js');
  });        

//http://127.0.0.1:5000/oauth/kakao

app.get('/', async (req, res)=>{
  res.send("success");
});


const path = require("path");

// 정적 파일 경로를 만들어 준다.
app.use(express.static(path.join(__dirname, "C:\Users\Uni\Documents\GitHub\backend-example")));

// "/" 경로로 request 요청시 dist에 있는 index.html을 꺼내준다.
app.get('/index', async (req, res)=>{
  const html = fs.readFileSync("index.html", 'utf8');
  console.log(html)
  res.send(html);
});

// jwt token deploy
app.get('/oauth/kakao', passport.authenticate('kakao'));
app.get('/oauth/kakao/callback', passport.authenticate('kakao', {
  successRedirect: '/',
  failureRedirect : '/',
}), (req, res) => {
  console.log("tes");
  res.redirect('/');
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