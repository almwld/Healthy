const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const rateLimit = require('express-rate-limit');
require('dotenv').config({ path: '../.env' });

const { createServer } = require('http');
const { Server } = require('socket.io');

const authRoutes = require('./routes/auth.routes');
const userRoutes = require('./routes/user.routes');
const consultationRoutes = require('./routes/consultation.routes');
const prescriptionRoutes = require('./routes/prescription.routes');
const orderRoutes = require('./routes/order.routes');
const paymentRoutes = require('./routes/payment.routes');
const notificationRoutes = require('./routes/notification.routes');
const aiRoutes = require('./routes/ai.routes');

const app = express();
const httpServer = createServer(app);
const io = new Server(httpServer, {
  cors: { origin: process.env.FRONTEND_URL || "*", methods: ["GET", "POST"] }
});

app.use(helmet());
app.use(cors());
app.use(morgan('combined'));
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 1000,
  message: { success: false, message: '\u0639\u062f\u062f \u0627\u0644\u0637\u0644\u0628\u0627\u062a \u0643\u062b\u064a\u0631\u062c\u062f\u0627\u064b\u060c \u0627\u0646\u062a\u0638\u0631 \u0642\u0644\u064a\u0644\u0627\u064b' }
});
app.use(limiter);

app.use((req, res, next) => { req.io = io; next(); });

app.get('/api/health', (req, res) => {
  res.json({ status: 'OK', message: '\u0645\u0646\u0635\u0629 \u0635\u062d\u062a\u0643 \u062a\u0639\u0645\u0644 \u0628\u0646\u062c\u0627\u062d', timestamp: new Date().toISOString() });
});

app.use('/api/auth', authRoutes);
app.use('/api/user', userRoutes);
app.use('/api/consultations', consultationRoutes);
app.use('/api/prescriptions', prescriptionRoutes);
app.use('/api/orders', orderRoutes);
app.use('/api/payments', paymentRoutes);
app.use('/api/notifications', notificationRoutes);
app.use('/api/ai', aiRoutes);

app.use((req, res) => { res.status(404).json({ success: false, message: '\u0627\u0644\u0645\u0633\u0627\u0631 \u063a\u064a\u0631 \u0645\u0648\u062c\u0648\u062f' }); });

app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ success: false, message: '\u062e\u0637\u0623 \u062e\u0627\u062f\u0645 \u062f\u0627\u062e\u0644\u064a', error: process.env.NODE_ENV === 'development' ? err.message : undefined });
});

io.on('connection', (socket) => {
  socket.on('join-consultation', (cid) => { socket.join(`consultation-${cid}`); });
  socket.on('send-message', (data) => { io.to(`consultation-${data.consultationId}`).emit('new-message', data); });
});

const PORT = process.env.PORT || 3000;
httpServer.listen(PORT, () => {
  console.log(`Sehtak Backend running on port ${PORT}`);
});

module.exports = app;
nsultation-${consultationId}`);
  });

  socket.on('send-message', (data) => {
    io.to(`consultation-${data.consultationId}`).emit('new-message', data);
  });

  socket.on('disconnect', () => {
    console.log('Client disconnected:', socket.id);
  });
});

const PORT = process.env.PORT || 3000;
httpServer.listen(PORT, () => {
  console.log(`\u2705 Sehtak Backend running on port ${PORT}`);
  console.log(`\ud83c\udf10 Environment: ${process.env.NODE_ENV || 'development'}`);
});

module.exports = app;
