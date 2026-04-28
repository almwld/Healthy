const pool = require('../config/db');

const paymentController = {
  initiate: async (req, res) => {
    try {
      const { order_id, amount, method } = req.body;
      res.json({ success: true, message: '\u0627نتقل لصفحة الدفع', data: { payment_url: `https://paytabs.com/pay/${order_id}` } });
    } catch (err) {
      res.status(500).json({ success: false, message: err.message });
    }
  },

  verify: async (req, res) => {
    try {
      const { order_id } = req.body;
      await pool.query('UPDATE orders SET payment_status = $2 WHERE id = $1', [order_id, 'paid']);
      res.json({ success: true, message: '\u062aم الدفع بنجاح' });
    } catch (err) {
      res.status(500).json({ success: false, message: err.message });
    }
  },

  getSubscriptionStatus: async (req, res) => {
    try {
      const result = await pool.query('SELECT * FROM subscriptions WHERE user_id = $1 AND is_active = TRUE ORDER BY end_date DESC LIMIT 1', [req.user.id]);
      res.json({ success: true, data: result.rows[0] || null });
    } catch (err) {
      res.status(500).json({ success: false, message: err.message });
    }
  },

  subscribe: async (req, res) => {
    try {
      const { plan_type, duration_months } = req.body;
      const start = new Date();
      const end = new Date();
      end.setMonth(end.getMonth() + (duration_months || 1));

      await pool.query('UPDATE subscriptions SET is_active = FALSE WHERE user_id = $1', [req.user.id]);
      const result = await pool.query(
        `INSERT INTO subscriptions (user_id, plan_type, start_date, end_date) VALUES ($1, $2, $3, $4) RETURNING *`,
        [req.user.id, plan_type, start, end]
      );
      res.json({ success: true, message: '\u062aم الاشتراك بنجاح', data: result.rows[0] });
    } catch (err) {
      res.status(500).json({ success: false, message: err.message });
    }
  }
};

module.exports = paymentController;
