const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth.middleware');
const userController = require('../controllers/user.controller');

router.get('/profile', authenticate, userController.getProfile);
router.put('/profile', authenticate, userController.updateProfile);
router.put('/medical-history', authenticate, userController.updateMedicalHistory);
router.post('/upload-avatar', authenticate, userController.uploadAvatar);
router.post('/complete-profile', authenticate, userController.completeProfile);

module.exports = router;
