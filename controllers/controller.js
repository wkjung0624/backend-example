const express = require('express');
const user = require('../models/users');
const view = ''

module.exports = {
    // router.js 에서 사용하는 함수를 여기에 정의함
    goToRoot: (req, res, next) => {
        console.log("test");
    }
}