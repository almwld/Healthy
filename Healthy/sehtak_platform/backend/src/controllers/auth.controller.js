const jwt = require('jsonwebtoken');
const { v4: uuidv4 } = require('uuid');
const User = require('../models/user.model');
const redis = require('../config/redis');

const generateToken = (userId) => jwt.sign({ userId }, process.env.JWT_SECRET, { expiresIn: process.env.JWT_EXPIRES_IN || '7d' });

const authController = {
  register: async (req, res) => {
    try {
      const { full_name, phone, email, password, user_type } = req.body;
      const existing = await User.findByPhone(phone);
      if (existing) return res.status(400).json({ success: false, message: '\u0631قم الجوال مسجل مسبقاً' });

      const user = await User.create({ full_name, phone, email, password, user_type });
      const otp = Math.floor(100000 + Math.random() * 900000).toString();
      await User.setOtp(user.id, otp);

      res.status(201).json({ success: true, message: '\u062aم إنشاء الحساب بنجاح', data: { user_id: user.id, otp } });
    } catch (err) {
      res.status(500).json({ success: false, message: err.message });
    }
  },

  login: async (req, res) => {
    try {
      const { phone, password } = req.body;
      const user = await User.findByPhone(phone);
      if (!user || !(await User.comparePassword(password, user.password_hash))) {
        return res.status(401).json({ success: false, message: '\u0631قم الجوال أو كلمة المرور خاطئة' });
      }
      if (!user.is_verified) return res.status(403).json({ success: false, message: '\u0627لحساب غير مفعل' });

      const token = generateToken(user.id);
      await redis.setEx(`auth:${user.id}`, 604800, token);
      res.json({ success: true, message: '\u062aم تسجيل الدخول بنجاح', data: { token, user: { id: user.id, full_name: user.full_name, phone: user.phone, user_type: user.user_type, avatar: user.avatar } } });
    } catch (err) {
      res.status(500).json({ success: false, message: err.message });
    }
  },

  verifyOtp: async (req, res) => {
    try {
      const { user_id, otp } = req.body;
      const user = await User.verifyOtp(user_id, otp);
      if (!user) return res.status(400).json({ success: false, message: '\u0631مز OTP خاطئ أو منتهي' });

      const token = generateToken(user.id);
      res.json({ success: true, message: '\u062aم التحقق بنجاح', data: { token } });
    } catch (err) {
      res.status(500).json({ success: false, message: err.message });
    }
  },

  resendOtp: async (req, res) => {
    try {
      const { user_id } = req.body;
      const otp = Math.floor(100000 + Math.random() * 900000).toString();
      await User.setOtp(user_id, otp);
      res.json({ success: true, message: '\u062aم إعادة إرسال الرمز', data: { otp } });
    } catch (err) {
      res.status(500).json({ success: false, message: err.message });
    }
  },

  forgotPassword: async (req, res) => {
    try {
      const { phone } = req.body;
      const user = await User.findByPhone(phone);
      if (!user) return res.status(404).json({ success: false, message: '\u0644ا يوجد حساب بهذا الرقم' });

      const otp = Math.floor(100000 + Math.random() * 900000).toString();
      await User.setOtp(user.id, otp);
      res.json({ success: true, message: '\u062aم إرسال رمز استعادة المرور', data: { otp } });
    } catch (err) {
      res.status(500).json({ success: false, message: err.message });
    }
  },

  logout: async (req, res) => {
    try {
      const token = req.headers.authorization?.split(' ')[1];
      await redis.del(`auth:${req.user.id}`);
      res.json({ success: true, message: '\u062aم تسجيل الخروج بنجاح' });
    } catch (err) {
      res.status(500).json({ success: false, message: err.message });
    }
  }
};

module.exports = authController;
