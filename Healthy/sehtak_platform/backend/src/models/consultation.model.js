const pool = require('../config/db');

class Consultation {
  static async create({ patient_id, symptoms, body_part, preferred_type, ai_triage_result, urgency_level }) {
    const result = await pool.query(
      `INSERT INTO consultations (patient_id, symptoms, body_part, preferred_type, ai_triage_result, urgency_level) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *`,
      [patient_id, symptoms, body_part, preferred_type, JSON.stringify(ai_triage_result), urgency_level]
    );
    return result.rows[0];
  }

  static async findById(id) {
    const result = await pool.query('SELECT c.*, u.full_name as doctor_name FROM consultations c LEFT JOIN users u ON c.doctor_id = u.id WHERE c.id = $1', [id]);
    return result.rows[0];
  }

  static async listByPatient(patient_id) {
    const result = await pool.query(
      `SELECT c.*, u.full_name as doctor_name FROM consultations c LEFT JOIN users u ON c.doctor_id = u.id WHERE c.patient_id = $1 ORDER BY c.created_at DESC`,
      [patient_id]
    );
    return result.rows;
  }

  static async listByDoctor(doctor_id) {
    const result = await pool.query(
      `SELECT c.*, u.full_name as patient_name FROM consultations c LEFT JOIN users u ON c.patient_id = u.id WHERE c.doctor_id = $1 OR c.status = 'pending' ORDER BY c.created_at DESC`,
      [doctor_id]
    );
    return result.rows;
  }

  static async assignDoctor(id, doctor_id) {
    const result = await pool.query(
      `UPDATE consultations SET doctor_id = $2, status = 'active', started_at = CURRENT_TIMESTAMP WHERE id = $1 RETURNING *`,
      [id, doctor_id]
    );
    return result.rows[0];
  }

  static async updateStatus(id, status) {
    const result = await pool.query(
      `UPDATE consultations SET status = $2, ended_at = CASE WHEN $2 IN ('completed', 'cancelled') THEN CURRENT_TIMESTAMP ELSE ended_at END WHERE id = $1 RETURNING *`,
      [id, status]
    );
    return result.rows[0];
  }

  static async addRating(id, rating, comment) {
    const result = await pool.query(
      `UPDATE consultations SET rating = $2, rating_comment = $3 WHERE id = $1 RETURNING *`,
      [id, rating, comment]
    );
    return result.rows[0];
  }
}

module.exports = Consultation;
