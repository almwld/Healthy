const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth.middleware');
const consultationController = require('../controllers/consultation.controller');

router.post('/start', authenticate, consultationController.start);
router.get('/', authenticate, consultationController.list);
router.get('/:id', authenticate, consultationController.getById);
router.post('/:id/messages', authenticate, consultationController.sendMessage);
router.post('/:id/end', authenticate, consultationController.end);
router.post('/:id/rate', authenticate, consultationController.rate);

module.exports = router;
