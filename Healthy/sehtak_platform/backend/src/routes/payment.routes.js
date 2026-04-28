const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth.middleware');
const paymentController = require('../controllers/payment.controller');

router.post('/initiate', authenticate, paymentController.initiate);
router.post('/verify', authenticate, paymentController.verify);
router.get('/subscription-status', authenticate, paymentController.getSubscriptionStatus);
router.post('/subscribe', authenticate, paymentController.subscribe);

module.exports = router;
