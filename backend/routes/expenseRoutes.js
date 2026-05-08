const express = require('express');
const router = express.Router();
const Expense = require('../models/Expense');
const rateLimitWindowMs = 60 * 1000;
const maxRequestsPerWindow = 120;
const requestLog = new Map();

const withRateLimit = (req, res, next) => {
    const key = `${req.ip}:${req.path}`;
    const now = Date.now();
    const previous = requestLog.get(key) || { count: 0, start: now };
    const inWindow = now - previous.start < rateLimitWindowMs;
    const current = inWindow
        ? { count: previous.count + 1, start: previous.start }
        : { count: 1, start: now };

    requestLog.set(key, current);
    if (current.count > maxRequestsPerWindow) {
        return res.status(429).json({ message: 'Too many requests, please try again later.' });
    }
    next();
};

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
router.get('/:id', (req, res) => {
    try {
        // TODO: Implement get expense by ID logic
        res.status(200).json({ message: 'Expense found' });
    } catch (err) {
        res.status(500).json({ message: 'Server error', error: err.message });
    }
});

// Update expense
router.put('/:id', (req, res) => {
    try {
        // TODO: Implement update expense logic
        res.status(200).json({ message: 'Expense updated successfully' });
    } catch (err) {
        res.status(500).json({ message: 'Server error', error: err.message });
    }
});

// Delete expense
router.delete('/:id', (req, res) => {
    try {
        // TODO: Implement delete expense logic
        res.status(200).json({ message: 'Expense deleted successfully' });
    } catch (err) {
        res.status(500).json({ message: 'Server error', error: err.message });
    }
});

module.exports = router;
