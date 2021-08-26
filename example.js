var sampleData = [
    {
        code : "005930", // 005930
        data : [
            {
                sdate : "210930103030", // YYMMDDhhmmss (optional)
                edate : "210930103030", // YYMMDDhhmmss (optional)
                open : 1000,
                high : 5000,
                low : 500,
                close : 1200
            },
            {
                sdate : "210930103031", // YYMMDDhhmmss (optional)
                edate : "210930103032", // YYMMDDhhmmss (optional)
                open : 1000,
                high : 5000,
                low : 500,
                close : 1200
            },
        ]
    },
    {
        code : "035720", // 005930
        data : [
            {
                sdate : "210930103035", // YYMMDDhhmmss (optional)
                edate : "210930103040", // YYMMDDhhmmss (optional)
                open : 10200,
                high : 50200,
                low : 5020,
                close : 12200
            },
            {
                sdate : "210930103030", // YYMMDDhhmmss (optional)
                edate : "210930103030", // YYMMDDhhmmss (optional)
                open : 10020,
                high : 50200,
                low : 5020,
                close : 12200
            },
        ]
    },
    {
        code : "000080", // 005930
        data : [
            {
                sdate : "210930103030", // YYMMDDhhmmss (optional)
                edate : "210930103030", // YYMMDDhhmmss (optional)
                open : 1111000,
                high : 5111000,
                low : 511100,
                close : 1111200
            },
            {
                sdate : "210930103030", // YYMMDDhhmmss (optional)
                edate : "210930103030", // YYMMDDhhmmss (optional)
                open : 1099900,
                high : 5099900,
                low : 509990,
                close : 1299900
            },
        ]
    },
]


const axios = require('axios');
const cors = require('cors');

let express = require('express')
let http = require('http')
let app = express()
let server = http.createServer(app);

app.use(express.json());
app.use(cors());

// For parsing application/x-www-form-urlencoded
app.use(express.urlencoded({
    extended: true
}));


app.get('/', function (req, res) {
    res.status(404).send('Not found');
});

app.get('/item', function(req, res){

    for(var temp of sampleData){
        if(req.query.code == temp.code){
            res.send(temp);
            //result.push(temp)    
        }    
    }
    // console.log(req.query.code);
    // console.log(req.query.sdate);
    // console.log(req.query.edate);
});

server.listen(5000, function () {
    console.log('Express server listening on port ' + server.address().port);
});
