const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const authRoutes = require('./src/routes/authRoutes');
const farmerRoutes = require('./src/routes/farmerRoutes');
const bodyParser = require('body-parser');

dotenv.config();

const app = express();

// Increase payload limit
app.use(bodyParser.json({ limit: '20mb' }));
app.use(bodyParser.urlencoded({ limit: '20mb', extended: true }));

// CORS and JSON parsing
app.use(cors());
app.use(express.json({ limit: '20mb' }));
app.use(express.urlencoded({ limit: '20mb', extended: true }));

// API Routes
app.use('/api/auth', authRoutes);
app.use('/api/farmer', farmerRoutes);

// Environment setup
const PORT = process.env.PORT || 5000;
const HOST = process.env.HOST || '0.0.0.0';

app.listen(PORT, HOST, () => {
    console.log(`✅ Server running at http://${HOST}:${PORT}`);
});
