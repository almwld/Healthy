const express = require('express');
const router = express.Router();
const authController = require('../controllers/auth.controller');
const validate = require('../middleware/validate.middleware');
const { body } = require('express-validator');

router.post('/register', validate([
  body('full_name').notEmpty(),
  body('phone').notEmpty().isMobilePhone(),
  body('password').isLength({ min: 8 }),
  body('user_type').isIn(['patient', 'doctor', 'pharmacy'])
]), authController.register);

router.post('/login', validate([body('phone').notEmpty(), body('password').notEmpty()]), authController.login);
router.post('/verify-otp', authController.verifyOtp);
router.post('/resend-otp', authController.resendOtp);
router.post('/forgot-password', authController.forgotPassword);
router.post('/logout', require('../middleware/auth.middleware').authenticate, authController.logout);

module.exports = router;
