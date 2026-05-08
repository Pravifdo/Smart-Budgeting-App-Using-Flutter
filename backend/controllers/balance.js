const express = require("express");

const router = express.Router();

const Balance = require("../models/Balance");


// ADD MONTHLY SALARY
router.post("/add-salary", async (req, res) => {

  try {

    const {
      userId,
      previousBalance,
      salary,
      totalExpenses,
      month,
    } = req.body;


    // TOTAL BALANCE CALCULATION
    const totalBalance =
      previousBalance + salary - totalExpenses;


    const newBalance = new Balance({
      userId,
      previousBalance,
      salary,
      totalExpenses,
        totalBalance,
        month,
    });

    await newBalance.save();

      res.status(201).json({
      success: true,
      message: "Balance Added Successfully",
      data: newBalance,
    });

  } catch (error) {

    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
});


// GET LATEST BALANCE
router.get("/latest/:userId", async (req, res) => {

  try {
    const balance = await Balance
      .findOne({ userId: req.params.userId })
      .sort({ createdAt: -1 });


    res.status(200).json({
      success: true,
      data: balance,
    });

  } catch (error) {

    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
});

module.exports = router;