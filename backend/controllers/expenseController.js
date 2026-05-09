const Expense = require('../models/Expense');

// Add expense
exports.addExpense = async (req, res) => {
    try {
        const { category, amount, description, date } = req.body;

        const newExpense = new Expense({
            userId: req.user.userId,
            category,
            amount,
            description,
            date: date || Date.now()
        });

        await newExpense.save();
        res.status(201).json({ message: 'Expense added successfully', expense: newExpense });
    } catch (err) {
        console.error('Add expense error:', err);
        res.status(500).json({ 
            message: 'Server error', 
            error: err.message,
            stack: err.stack,
            debug_user: req.user
        });
    }
};

// Get all expenses for a user
exports.getExpenses = async (req, res) => {
    try {
        const expenses = await Expense.find({ userId: req.user.userId }).sort({ date: -1 });
        res.status(200).json({ expenses });
    } catch (err) {
        res.status(500).json({ 
            message: 'Server error', 
            error: err.message,
            stack: err.stack,
            debug_user: req.user
        });
    }
};

// Update expense
exports.updateExpense = async (req, res) => {
    try {
        const expense = await Expense.findOneAndUpdate(
            { _id: req.params.id, userId: req.user.userId },
            req.body,
            { new: true }
        );

        if (!expense) {
            return res.status(404).json({ message: 'Expense not found' });
        }

        res.status(200).json({ message: 'Expense updated successfully', expense });
    } catch (err) {
        res.status(500).json({ message: 'Server error', error: err.message });
    }
};

// Delete expense
exports.deleteExpense = async (req, res) => {
    try {
        const expense = await Expense.findOneAndDelete({ _id: req.params.id, userId: req.user.userId });

        if (!expense) {
            return res.status(404).json({ message: 'Expense not found' });
        }

        res.status(200).json({ message: 'Expense deleted successfully' });
    } catch (err) {
        res.status(500).json({ message: 'Server error', error: err.message });
    }
};
