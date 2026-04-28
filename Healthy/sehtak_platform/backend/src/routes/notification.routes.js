const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth.middleware');
const notificationController = require('../controllers/notification.controller');

router.get('/user', authenticate, notificationController.list);
router.put('/:id/read', authenticate, notificationController.markRead);

module.exports = router;
