const express = require('express');
const router = express.Router();
const { authenticate, authorize } = require('../middleware/auth.middleware');
const doctorController = require('../controllers/doctor.controller');

router.get('/dashboard', authenticate, authorize('doctor'), doctorController.getDashboard);
router.put('/availability', authenticate, authorize('doctor'), doctorController.setAvailability);
router.get('/patient/:patient_id', authenticate, authorize('doctor'), doctorController.getPatientInfo);

module.exports = router;
