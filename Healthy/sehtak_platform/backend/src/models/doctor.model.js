const pool = require('../config/db');

class Doctor {
  static async create({ user_id, specialization, license_number, years_experience, bio, consultation_fee }) {
    const result = await pool.query(
      `INSERT INTO doctors (user_id, specialization, license_number, years_experience, bio, consultation_fee) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *`,
      [user_id, specialization, license_number, years_experience, bio, consultation_fee]
    );
    return result.rows[0];
  }

  static async findByUserId(user_id) {
    const result = await pool.query('SELECT d.*, u.full_name, u.phone, u.avatar FROM doctors d JOIN users u ON d.user_id = u.id WHERE d.user_id = $1', [user_id]);
    return result.rows[0];
  }

  static async listAvailable() {
    const result = await pool.query(`SELECT d.*, u.full_name, u.avatar FROM doctors d JOIN users u ON d.user_id = u.id WHERE d.is_available = 'available' ORDER BY d.rating_avg DESC`);
    return result.rows;
  }

  static async updateAvailability(user_id, status) {
    await pool.query('UPDATE doctors SET is_available = $2 WHERE user_id = $1', [user_id, status]);
  }
}

module.exports = Doctor;
