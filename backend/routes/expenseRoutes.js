const express = require('express');
const router = express.Router();

router.post('/add', (req, res) => {
    // Logic to add an expense
    res.send('Expense added');
});

router.get("/all", (req, res) => {
    // Logic to get all expenses for a user
    res.send('All expenses');
});

module.exports = router;