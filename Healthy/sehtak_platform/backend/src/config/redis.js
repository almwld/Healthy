const redis = require('redis');
require('dotenv').config({ path: '../../.env' });

const client = redis.createClient({
  socket: { host: process.env.REDIS_HOST || 'localhost', port: process.env.REDIS_PORT || 6379 }
});

client.on('error', (err) => console.error('Redis Error:', err));
client.connect().catch(console.error);

module.exports = client;
