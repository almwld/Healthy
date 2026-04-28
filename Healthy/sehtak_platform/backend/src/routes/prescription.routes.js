const express = require('express');
const router = express.Router();
const { authenticate, authorize } = require('../middleware/auth.middleware');
const prescriptionController = require('../controllers/prescription.controller');

router.post('/create', authenticate, authorize('doctor'), prescriptionController.create);
router.get('/:id', authenticate, prescriptionController.getById);
router.get('/consultation/:consultation_id', authenticate, prescriptionController.getByConsultation);

module.exports = router;
