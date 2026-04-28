const Notification = require('../models/notification.model');

const notificationController = {
  list: async (req, res) => {
    try {
      const notifications = await Notification.listByUser(req.user.id);
      const unreadCount = await Notification.getUnreadCount(req.user.id);
      res.json({ success: true, data: notifications, unread_count: unreadCount });
    } catch (err) {
      res.status(500).json({ success: false, message: err.message });
    }
  },

  markRead: async (req, res) => {
    try {
      await Notification.markAsRead(req.params.id);
      res.json({ success: true, message: '\u062aم تعليم الإشعار كمقروء' });
    } catch (err) {
      res.status(500).json({ success: false, message: err.message });
    }
  }
};

module.exports = notificationController;
