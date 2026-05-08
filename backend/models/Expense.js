const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    category:String,
    amount: Number, 
    date: {
        type: Date, 
        required: true,
        default: Date.now
     },
    description: String
});