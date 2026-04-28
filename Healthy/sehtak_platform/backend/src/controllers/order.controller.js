const Order = require('../models/order.model');
const Pharmacy = require('../models/pharmacy.model');

const orderController = {
  create: async (req, res) => {
    try {
      const { prescription_id, pharmacy_id, patient_address, address_lat, address_lng, payment_method } = req.body;
      const delivery_fee = 15;
      const total_amount = delivery_fee; // medicines added later

      const order = await Order.create({
        prescription_id, pharmacy_id, patient_address, address_lat, address_lng, delivery_fee, total_amount, payment_method
      });
      res.status(201).json({ success: true, message: '\u062aم إنشاء الطلب بنجاح', data: order });
    } catch (err) {
      res.status(500).json({ success: false, message: err.message });
    }
  },

  track: async (req, res) => {
    try {
      const order = await Order.findById(req.params.id);
      if (!order) return res.status(404).json({ success: false, message: '\u0627لطلب غير موجود' });
      res.json({ success: true, data: order });
    } catch (err) {
      res.status(500).json({ success: false, message: err.message });
    }
  },

  updateStatus: async (req, res) => {
    try {
      const { status, lat, lng } = req.body;
      const order = await Order.updateStatus(req.params.id, status);
      if (lat && lng) await Order.addTracking(req.params.id, status, lat, lng);
      res.json({ success: true, data: order });
    } catch (err) {
      res.status(500).json({ success: false, message: err.message });
    }
  },

  listNearbyPharmacies: async (req, res) => {
    try {
      const { lat, lng, radius } = req.query;
      const pharmacies = await Pharmacy.findNearby(lat, lng, radius || 10);
      res.json({ success: true, data: pharmacies });
    } catch (err) {
      res.status(500).json({ success: false, message: err.message });
    }
  }
};

module.exports = orderController;
