const Income = require('../models/Income');

// Add income
exports.addIncome = async (req, res) => {
    try {
        const { source, amount, date } = req.body;

        const newIncome = new Income({
            userId: req.user.userId,
            source,
            amount,
            date: date || Date.now()
        });

        await newIncome.save();
        res.status(201).json({ message: 'Income added successfully', income: newIncome });
    } catch (err) {
        console.error('Add income error:', err);
        res.status(500).json({ message: 'Server error', error: err.message });
    }
};

// Get all income for a user
exports.getIncomes = async (req, res) => {
    try {
        const incomes = await Income.find({ userId: req.user.userId }).sort({ date: -1 });
        res.status(200).json({ incomes });
    } catch (err) {
        res.status(500).json({ message: 'Server error', error: err.message });
    }
};

// Update income
exports.updateIncome = async (req, res) => {
    try {
        const income = await Income.findOneAndUpdate(
            { _id: req.params.id, userId: req.user.userId },
            req.body,
            { new: true }
        );

        if (!income) {
            return res.status(404).json({ message: 'Income not found' });
        }

        res.status(200).json({ message: 'Income updated successfully', income });
    } catch (err) {
        res.status(500).json({ message: 'Server error', error: err.message });
    }
};

// Delete income
exports.deleteIncome = async (req, res) => {
    try {
        const income = await Income.findOneAndDelete({ _id: req.params.id, userId: req.user.userId });

        if (!income) {
            return res.status(404).json({ message: 'Income not found' });
        }

        res.status(200).json({ message: 'Income deleted successfully' });
    } catch (err) {
        res.status(500).json({ message: 'Server error', error: err.message });
    }
};
