const mongoose = require('mongoose');

const expenseSchema = new mongoose.Schema({
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: false
    },
    title: {
        type: String,
        required: true,
        trim: true
    },
    category: {
        type: String,
        default: 'General',
        trim: true
    },
    amount: {
        type: Number,
        required: true
    },
    date: {
        type: Date, 
        default: Date.now
     },
    description: String
});

module.exports = mongoose.model('Expense', expenseSchema);
