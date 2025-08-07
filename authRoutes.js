const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');

router.post('/admin/login', authController.adminLogin);
router.post('/farmer/login', authController.loginFarmer);
module.exports = router;
