const express = require('express');
const router = express.Router();
const incomeController = require('../controllers/incomeController');
const authMiddleware = require('../middleware/authMiddleware');

router.post('/add', authMiddleware, incomeController.addIncome);
router.get('/all', authMiddleware, incomeController.getIncomes);
router.put('/:id', authMiddleware, incomeController.updateIncome);
router.delete('/:id', authMiddleware, incomeController.deleteIncome);

module.exports = router;