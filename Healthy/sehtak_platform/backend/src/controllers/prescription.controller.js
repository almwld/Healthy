const Prescription = require('../models/prescription.model');
const pool = require('../config/db');

const prescriptionController = {
  create: async (req, res) => {
    try {
      const { consultation_id, patient_id, diagnosis, medicines, instructions } = req.body;
      const prescription = await Prescription.create({
        consultation_id, doctor_id: req.user.id, patient_id, diagnosis, medicines, instructions
      });
      await pool.query('UPDATE consultations SET status = $2 WHERE id = $1', [consultation_id, 'completed']);
      res.status(201).json({ success: true, message: '\u062aم إنشاء الوصفة', data: prescription });
    } catch (err) {
      res.status(500).json({ success: false, message: err.message });
    }
  },

  getById: async (req, res) => {
    try {
      const prescription = await Prescription.findById(req.params.id);
      if (!prescription) return res.status(404).json({ success: false, message: '\u0627لوصفة غير موجودة' });
      res.json({ success: true, data: prescription });
    } catch (err) {
      res.status(500).json({ success: false, message: err.message });
    }
  },

  getByConsultation: async (req, res) => {
    try {
      const prescription = await Prescription.findByConsultation(req.params.consultation_id);
      res.json({ success: true, data: prescription });
    } catch (err) {
      res.status(500).json({ success: false, message: err.message });
    }
  }
};

module.exports = prescriptionController;
