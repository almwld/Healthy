const Consultation = require('../models/consultation.model');
const Doctor = require('../models/doctor.model');
const Notification = require('../models/notification.model');
const pool = require('../config/db');
const axios = require('axios');

const consultationController = {
  start: async (req, res) => {
    try {
      const { symptoms, body_part, preferred_type } = req.body;
      const patient_id = req.user.id;

      // AI Triage
      let aiResult = { specialization: '\u0627لطب العام', urgency: 'low' };
      try {
        const aiResponse = await axios.post(`${process.env.AI_SERVICE_URL}/triage`, { symptoms, body_part });
        aiResult = aiResponse.data;
      } catch (e) { console.log('AI service unavailable, using fallback'); }

      // Find available doctor by specialization
      const doctors = await Doctor.listAvailable();
      const matchedDoctor = doctors.find(d => d.specialization.includes(aiResult.specialization)) || doctors[0];

      const consultation = await Consultation.create({
        patient_id, symptoms, body_part, preferred_type,
        ai_triage_result: aiResult,
        urgency_level: aiResult.urgency || 'low'
      });

      if (matchedDoctor) {
        await Consultation.assignDoctor(consultation.id, matchedDoctor.user_id);
      }

      // Notify patient
      await Notification.create({
        user_id: patient_id,
        title: '\u062aم إنشاء استشارتك',
        body: `\u062aم تخصيص الدكتور: ${matchedDoctor?.full_name || '\u0642يد التخصيص'}`,
        type: 'consultation'
      });

      res.status(201).json({ success: true, data: consultation });
    } catch (err) {
      res.status(500).json({ success: false, message: err.message });
    }
  },

  list: async (req, res) => {
    try {
      const consultations = req.user.user_type === 'doctor'
        ? await Consultation.listByDoctor(req.user.id)
        : await Consultation.listByPatient(req.user.id);
      res.json({ success: true, data: consultations });
    } catch (err) {
      res.status(500).json({ success: false, message: err.message });
    }
  },

  getById: async (req, res) => {
    try {
      const consultation = await Consultation.findById(req.params.id);
      if (!consultation) return res.status(404).json({ success: false, message: '\u0627لاستشارة غير موجودة' });

      const messages = await pool.query('SELECT * FROM messages WHERE consultation_id = $1 ORDER BY sent_at ASC', [req.params.id]);
      res.json({ success: true, data: { ...consultation, messages: messages.rows } });
    } catch (err) {
      res.status(500).json({ success: false, message: err.message });
    }
  },

  sendMessage: async (req, res) => {
    try {
      const { content, attachment_url } = req.body;
      const result = await pool.query(
        `INSERT INTO messages (consultation_id, sender_id, sender_type, content, attachment_url) VALUES ($1, $2, $3, $4, $5) RETURNING *`,
        [req.params.id, req.user.id, req.user.user_type, content, attachment_url]
      );

      req.io.to(`consultation-${req.params.id}`).emit('new-message', result.rows[0]);
      res.json({ success: true, data: result.rows[0] });
    } catch (err) {
      res.status(500).json({ success: false, message: err.message });
    }
  },

  end: async (req, res) => {
    try {
      const consultation = await Consultation.updateStatus(req.params.id, 'completed');
      res.json({ success: true, message: '\u062aم إنهاء الاستشارة', data: consultation });
    } catch (err) {
      res.status(500).json({ success: false, message: err.message });
    }
  },

  rate: async (req, res) => {
    try {
      const { rating, comment } = req.body;
      const consultation = await Consultation.addRating(req.params.id, rating, comment);
      res.json({ success: true, message: '\u0634كراً على تقييمك', data: consultation });
    } catch (err) {
      res.status(500).json({ success: false, message: err.message });
    }
  }
};

module.exports = consultationController;
