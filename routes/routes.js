const express = require('express')
const router = express.Router();
const controller = require('../controllers/controller')

//controller 에 있는 함수
router.get('/', controller.goToRoot)