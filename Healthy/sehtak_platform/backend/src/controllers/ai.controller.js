const axios = require('axios');

const aiController = {
  triage: async (req, res) => {
    try {
      const { symptoms, body_part } = req.body;
      const response = await axios.post(`${process.env.AI_SERVICE_URL}/triage`, { symptoms, body_part });
      res.json({ success: true, data: response.data });
    } catch (err) {
      res.status(500).json({ success: false, message: 'AI service unavailable' });
    }
  },

  symptomChecker: async (req, res) => {
    try {
      const { symptoms, body_part } = req.body;
      const response = await axios.post(`${process.env.AI_SERVICE_URL}/symptom-checker`, { symptoms, body_part });
      res.json({ success: true, data: response.data });
    } catch (err) {
      res.status(500).json({ success: false, message: 'AI service unavailable' });
    }
  },

  chatbot: async (req, res) => {
    try {
      const { message } = req.body;
      const response = await axios.post(`${process.env.AI_SERVICE_URL}/chatbot`, { message });
      res.json({ success: true, data: response.data });
    } catch (err) {
      res.status(500).json({ success: false, message: 'AI service unavailable' });
    }
  }
};

module.exports = aiController;
