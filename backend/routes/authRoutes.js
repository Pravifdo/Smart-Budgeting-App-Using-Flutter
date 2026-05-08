const express = require('express');
const router = express.Router();

router.post("/register",(req, res) => {
    // Logic to register a user
    res.send('User registered');
});

router.post("/login",(req, res) => {
    // Logic to log in a user
    res.send('User logged in');
});

module.exports = router;