const mongoose = require("mongoose");

const incomeSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
  },
  amount: Number,
  source: String,
  date: {
    type: Date,
    default: Date.now,
  },
});

module.exports = mongoose.model("Income", incomeSchema);