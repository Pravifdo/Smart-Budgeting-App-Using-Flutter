const mongoose = require('mongoose');

const expenseSchema = new mongoose.Schema({
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    category: String,
    amount: Number, 
    date: {
        type: Date, 
        required: true,
        default: Date.now
     },
    description: String
});

module.exports = mongoose.model('Expense', expenseSchema);