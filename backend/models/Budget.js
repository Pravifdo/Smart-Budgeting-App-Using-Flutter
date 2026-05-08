const budgetSchema = new mongoose.Schema({
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    category: String,
    amount: Number,
    startDate: Date,
    endDate: Date
});

module.exports = mongoose.model('Budget', budgetSchema);