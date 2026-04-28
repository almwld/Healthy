const Doctor = require('../models/doctor.model');
const Consultation = require('../models/consultation.model');
const pool = require('../config/db');

const doctorController = {
  getDashboard: async (req, res) => {
    try {
      const todayCount = await pool.query(`SELECT COUNT(*) FROM consultations WHERE doctor_id = $1 AND DATE(created_at) = CURRENT_DATE`, [req.user.id]);
      const activeCount = await pool.query(`SELECT COUNT(*) FROM consultations WHERE doctor_id = $1 AND status = 'active'`, [req.user.id]);
      const revenue = await pool.query(`SELECT COALESCE(SUM(fee), 0) FROM consultations WHERE doctor_id = $1 AND status = 'completed'`, [req.user.id]);
      const pendingCases = await Consultation.listByDoctor(req.user.id);

      res.json({
        success: true,
        data: {
          today_consultations: parseInt(todayCount.rows[0].count),
          active_consultations: parseInt(activeCount.rows[0].count),
          total_revenue: parseFloat(revenue.rows[0].coalesce),
          pending_cases: pendingCases.filter(c => c.status === 'pending'),
          active_cases: pendingCases.filter(c => c.status === 'active')
        }
      });
    } catch (err) {
      res.status(500).json({ success: false, message: err.message });
    }
  },

  setAvailability: async (req, res) => {
    try {
      const { status } = req.body;
      await Doctor.updateAvailability(req.user.id, status);
      res.json({ success: true, message: '\u062aم تحديث الحالة' });
    } catch (err) {
      res.status(500).json({ success: false, message: err.message });
    }
  },

  getPatientInfo: async (req, res) => {
    try {
      const result = await pool.query(
        `SELECT u.full_name, u.phone, u.avatar, mi.dob, mi.gender, mi.blood_type, mi.chronic_diseases, mi.allergies, mi.current_medications FROM users u LEFT JOIN user_medical_info mi ON u.id = mi.user_id WHERE u.id = $1`,
        [req.params.patient_id]
      );
      res.json({ success: true, data: result.rows[0] });
    } catch (err) {
      res.status(500).json({ success: false, message: err.message });
    }
  }
};

module.exports = doctorController;
