const mongoose = require("mongoose");

const balanceSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
  },

  previousBalance: {
    type: Number,
    default: 0,
  },

  salary: {
    type: Number,
    required: true,
  },

  totalExpenses: {
    type: Number,
    default: 0,
  },

  totalBalance: {
    type: Number,
    default: 0,
  },

   month: {
    type: String,
  },

  createdAt: {
    type: Date,
    default: Date.now,
  },
});

module.exports = mongoose.model("Balance", balanceSchema);