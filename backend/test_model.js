require('dotenv').config();
const mongoose = require('mongoose');
const Expense = require('./models/Expense');

async function test() {
    try {
        await mongoose.connect(process.env.MONGO_URI);
        console.log("Connected to DB");
        const count = await Expense.countDocuments();
        console.log("Expense count:", count);

        const newExp = new Expense({
            userId: new mongoose.Types.ObjectId(),
            category: "Test",
            amount: 100,
            description: "Test"
        });
        await newExp.save();
        console.log("Save successful");
        process.exit(0);
    } catch (err) {
        console.error("Test failed:", err);
        process.exit(1);
    }
}

test();
