const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth.middleware');
const orderController = require('../controllers/order.controller');

router.post('/create', authenticate, orderController.create);
router.get('/:id/track', authenticate, orderController.track);
router.put('/:id/status', authenticate, orderController.updateStatus);
router.get('/pharmacies/nearby', authenticate, orderController.listNearbyPharmacies);

module.exports = router;
