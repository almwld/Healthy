const pool = require('../config/db');
const User = require('../models/user.model');
const Doctor = require('../models/doctor.model');
const Pharmacy = require('../models/pharmacy.model');

const userController = {
  getProfile: async (req, res) => {
    try {
      const user = await User.findById(req.user.id);
      let profile = { ...user };
      delete profile.password_hash;
      delete profile.otp_code;

      if (user.user_type === 'doctor') {
        const doctor = await Doctor.findByUserId(user.id);
        profile.doctor_info = doctor;
      } else if (user.user_type === 'pharmacy') {
        const result = await pool.query('SELECT * FROM pharmacies WHERE user_id = $1', [user.id]);
        profile.pharmacy_info = result.rows[0];
      } else {
        const result = await pool.query('SELECT * FROM user_medical_info WHERE user_id = $1', [user.id]);
        profile.medical_info = result.rows[0];
      }

      res.json({ success: true, data: profile });
    } catch (err) {
      res.status(500).json({ success: false, message: err.message });
    }
  },

  updateProfile: async (req, res) => {
    try {
      const { full_name, email, avatar } = req.body;
      const user = await User.update(req.user.id, { full_name, email, avatar });
      res.json({ success: true, message: '\u062aم تحديث الملف الشخصي', data: user });
    } catch (err) {
      res.status(500).json({ success: false, message: err.message });
    }
  },

  updateMedicalHistory: async (req, res) => {
    try {
      const { dob, gender, blood_type, chronic_diseases, allergies, current_medications } = req.body;
      const result = await pool.query(
        `INSERT INTO user_medical_info (user_id, dob, gender, blood_type, chronic_diseases, allergies, current_medications) VALUES ($1, $2, $3, $4, $5, $6, $7) ON CONFLICT (user_id) DO UPDATE SET dob = EXCLUDED.dob, gender = EXCLUDED.gender, blood_type = EXCLUDED.blood_type, chronic_diseases = EXCLUDED.chronic_diseases, allergies = EXCLUDED.allergies, current_medications = EXCLUDED.current_medications, updated_at = CURRENT_TIMESTAMP RETURNING *`,
        [req.user.id, dob, gender, blood_type, JSON.stringify(chronic_diseases || []), JSON.stringify(allergies || []), JSON.stringify(current_medications || [])]
      );
      res.json({ success: true, message: '\u062aم تحديث البيانات الطبية', data: result.rows[0] });
    } catch (err) {
      res.status(500).json({ success: false, message: err.message });
    }
  },

  uploadAvatar: async (req, res) => {
    try {
      if (!req.file) return res.status(400).json({ success: false, message: '\u0644ا يوجد ملف' });
      const avatarUrl = `/uploads/${req.file.filename}`;
      await User.update(req.user.id, { avatar: avatarUrl });
      res.json({ success: true, message: '\u062aم رفع الصورة', data: { avatar: avatarUrl } });
    } catch (err) {
      res.status(500).json({ success: false, message: err.message });
    }
  },

  completeProfile: async (req, res) => {
    try {
      const user = req.user;
      if (user.user_type === 'doctor') {
        const { specialization, license_number, years_experience, bio, consultation_fee } = req.body;
        await Doctor.create({ user_id: user.id, specialization, license_number, years_experience, bio, consultation_fee });
      } else if (user.user_type === 'pharmacy') {
        const { pharmacy_name, license_number, address, address_lat, address_lng } = req.body;
        await Pharmacy.create({ user_id: user.id, pharmacy_name, license_number, address, address_lat, address_lng });
      }
      res.json({ success: true, message: '\u062aم استكمال الملف الشخصي' });
    } catch (err) {
      res.status(500).json({ success: false, message: err.message });
    }
  }
};

module.exports = userController;
