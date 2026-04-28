const pool = require('../config/db');

class Prescription {
  static async create({ consultation_id, doctor_id, patient_id, diagnosis, medicines, instructions }) {
    const result = await pool.query(
      `INSERT INTO prescriptions (consultation_id, doctor_id, patient_id, diagnosis, medicines, instructions) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *`,
      [consultation_id, doctor_id, patient_id, diagnosis, JSON.stringify(medicines), instructions]
    );
    return result.rows[0];
  }

  static async findById(id) {
    const result = await pool.query('SELECT * FROM prescriptions WHERE id = $1', [id]);
    return result.rows[0];
  }

  static async findByConsultation(consultation_id) {
    const result = await pool.query('SELECT * FROM prescriptions WHERE consultation_id = $1', [consultation_id]);
    return result.rows[0];
  }
}

module.exports = Prescription;
