const express = require('express');
const rateLimit = require('express-rate-limit');
const router = express.Router();
const Expense = require('../models/Expense');
const withRateLimit = rateLimit({
    windowMs: 60 * 1000,
    max: 120,
    standardHeaders: true,
    legacyHeaders: false,
    message: { message: 'Too many requests, please try again later.' },
});

// Add expense
router.post('/add', withRateLimit, async (req, res) => {
    try {
        const { userId, title, amount, category, date, description } = req.body;
        if (!title || amount == null || Number(amount) <= 0) {
            return res.status(400).json({ message: 'Please provide a valid title and amount' });
        }

        const expense = await Expense.create({
            userId,
            title,
            amount: Number(amount),
            category,
            date: date ? new Date(date) : undefined,
            description,
        });

        res.status(201).json({ message: 'Expense added successfully', expense });
    } catch (err) {
        res.status(500).json({ message: 'Server error', error: err.message });
    }
});

// Get all expenses
router.get('/all', withRateLimit, async (req, res) => {
    try {
        const expenses = await Expense.find().sort({ date: -1 });
        res.status(200).json({ expenses });
    } catch (err) {
        res.status(500).json({ message: 'Server error', error: err.message });
    }
});

// Get expense by ID
router.get('/:id', withRateLimit, (req, res) => {
    try {
        // TODO: Implement get expense by ID logic
        res.status(200).json({ message: 'Expense found' });
    } catch (err) {
        res.status(500).json({ message: 'Server error', error: err.message });
    }
});

// Update expense
router.put('/:id', withRateLimit, (req, res) => {
    try {
        // TODO: Implement update expense logic
        res.status(200).json({ message: 'Expense updated successfully' });
    } catch (err) {
        res.status(500).json({ message: 'Server error', error: err.message });
    }
});

// Delete expense
router.delete('/:id', withRateLimit, (req, res) => {
    try {
        // TODO: Implement delete expense logic
        res.status(200).json({ message: 'Expense deleted successfully' });
    } catch (err) {
        res.status(500).json({ message: 'Server error', error: err.message });
    }
});

module.exports = router;
