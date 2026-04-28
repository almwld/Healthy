const pool = require('../config/db');
const bcrypt = require('bcryptjs');

class User {
  static async create({ full_name, phone, email, password, user_type }) {
    const hashed = await bcrypt.hash(password, 10);
    const result = await pool.query(
      `INSERT INTO users (full_name, phone, email, password_hash, user_type) VALUES ($1, $2, $3, $4, $5) RETURNING *`,
      [full_name, phone, email, hashed, user_type]
    );
    return result.rows[0];
  }

  static async findByPhone(phone) {
    const result = await pool.query('SELECT * FROM users WHERE phone = $1', [phone]);
    return result.rows[0];
  }

  static async findById(id) {
    const result = await pool.query('SELECT * FROM users WHERE id = $1', [id]);
    return result.rows[0];
  }

  static async update(id, data) {
    const fields = Object.keys(data).map((k, i) => `${k} = $${i + 2}`).join(', ');
    const values = Object.values(data);
    const result = await pool.query(`UPDATE users SET ${fields}, updated_at = CURRENT_TIMESTAMP WHERE id = $1 RETURNING *`, [id, ...values]);
    return result.rows[0];
  }

  static async setOtp(id, otp) {
    await pool.query('UPDATE users SET otp_code = $2, otp_expires_at = NOW() + INTERVAL \'10 minutes\' WHERE id = $1', [id, otp]);
  }

  static async verifyOtp(id, otp) {
    const result = await pool.query('SELECT * FROM users WHERE id = $1 AND otp_code = $2 AND otp_expires_at > NOW()', [id, otp]);
    if (result.rows[0]) {
      await pool.query('UPDATE users SET is_verified = TRUE, otp_code = NULL WHERE id = $1', [id]);
    }
    return result.rows[0];
  }

  static async comparePassword(plain, hash) {
    return bcrypt.compare(plain, hash);
  }
}

module.exports = User;
