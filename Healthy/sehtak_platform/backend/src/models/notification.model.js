const pool = require('../config/db');

class Notification {
  static async create({ user_id, title, body, type }) {
    const result = await pool.query(
      `INSERT INTO notifications (user_id, title, body, type) VALUES ($1, $2, $3, $4) RETURNING *`,
      [user_id, title, body, type]
    );
    return result.rows[0];
  }

  static async listByUser(user_id) {
    const result = await pool.query('SELECT * FROM notifications WHERE user_id = $1 ORDER BY created_at DESC LIMIT 50', [user_id]);
    return result.rows;
  }

  static async markAsRead(id) {
    await pool.query('UPDATE notifications SET is_read = TRUE WHERE id = $1', [id]);
  }

  static async getUnreadCount(user_id) {
    const result = await pool.query('SELECT COUNT(*) FROM notifications WHERE user_id = $1 AND is_read = FALSE', [user_id]);
    return parseInt(result.rows[0].count);
  }
}

module.exports = Notification;
