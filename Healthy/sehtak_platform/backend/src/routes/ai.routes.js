const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth.middleware');
const aiController = require('../controllers/ai.controller');

router.post('/triage', authenticate, aiController.triage);
router.post('/symptom-checker', authenticate, aiController.symptomChecker);
router.post('/chatbot', aiController.chatbot);

module.exports = router;
