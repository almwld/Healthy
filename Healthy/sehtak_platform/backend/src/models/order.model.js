const pool = require('../config/db');

class Order {
  static async create({ prescription_id, pharmacy_id, patient_address, address_lat, address_lng, delivery_fee, total_amount, payment_method }) {
    const result = await pool.query(
      `INSERT INTO orders (prescription_id, pharmacy_id, patient_address, address_lat, address_lng, delivery_fee, total_amount, payment_method) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING *`,
      [prescription_id, pharmacy_id, patient_address, address_lat, address_lng, delivery_fee, total_amount, payment_method]
    );
    return result.rows[0];
  }

  static async findById(id) {
    const result = await pool.query('SELECT o.*, p.pharmacy_name FROM orders o JOIN pharmacies p ON o.pharmacy_id = p.id WHERE o.id = $1', [id]);
    return result.rows[0];
  }

  static async updateStatus(id, status) {
    const result = await pool.query(
      `UPDATE orders SET order_status = $2, delivered_at = CASE WHEN $2 = 'delivered' THEN CURRENT_TIMESTAMP ELSE delivered_at END WHERE id = $1 RETURNING *`,
      [id, status]
    );
    return result.rows[0];
  }

  static async addTracking(order_id, status, lat, lng) {
    await pool.query('INSERT INTO order_tracking (order_id, status, location_lat, location_lng) VALUES ($1, $2, $3, $4)', [order_id, status, lat, lng]);
  }
}

module.exports = Order;
