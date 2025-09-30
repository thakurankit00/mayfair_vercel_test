/**
 * Vercel Entry Point for Mayfair Hotel Management System
 * 
 * Simplified version that works reliably in serverless environment
 */

require('dotenv').config();
const express = require('express');
const path = require('path');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const compression = require('compression');

const app = express();

// Basic middleware for Vercel
app.set('trust proxy', 1);

// Security middleware (simplified for serverless)
app.use(helmet({
  contentSecurityPolicy: false,
  crossOriginEmbedderPolicy: false
}));

// CORS configuration
app.use(cors({
  origin: [
    'http://localhost:3001',
    'http://localhost:3002',
    process.env.CORS_ORIGIN,
    'https://mayfair-hotel-begd.vercel.app'
  ].filter(Boolean),
  credentials: true
}));

// Basic middleware
app.use(compression());
app.use(morgan('combined'));
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({
    success: true,
    data: {
      status: 'OK',
      timestamp: new Date().toISOString(),
      environment: process.env.NODE_ENV || 'production',
      version: '1.0.0'
    }
  });
});

// Simple test endpoint
app.get('/api/test', (req, res) => {
  res.status(200).json({
    success: true,
    message: 'API is working!',
    timestamp: new Date().toISOString()
  });
});

// Import and use routes (with error handling)
try {
  const authRoutes = require('./src/routes/auth');
  const userRoutes = require('./src/routes/users');
  const dashboardRoutes = require('./src/routes/dashboard');
  const roomRoutes = require('./src/routes/rooms');
  const bookingRoutes = require('./src/routes/bookings');
  const restaurantRoutes = require('./src/routes/restaurant');
  const uploadRoutes = require('./src/routes/upload');
  const reportsRoutes = require('./src/routes/reports');

  // API routes
  app.use('/api/v1/auth', authRoutes);
  app.use('/api/v1/users', userRoutes);
  app.use('/api/v1/dashboard', dashboardRoutes);
  app.use('/api/v1/rooms', roomRoutes);
  app.use('/api/v1/bookings', bookingRoutes);
  app.use('/api/v1/restaurant', restaurantRoutes);
  app.use('/api/v1/upload', uploadRoutes);
  app.use('/api/v1/reports', reportsRoutes);
  
  try {
    const paymentsRoutes = require('./src/routes/payments');
    app.use('/api/v1/payments', paymentsRoutes);
  } catch (err) {
    console.log('Payments routes not available:', err.message);
  }

  // Notifications route (optional - was disabled in original)
  try {
    const notificationRoutes = require('./src/routes/notificationRoutes');
    app.use('/api/v1/notifications', notificationRoutes);
  } catch (err) {
    console.log('Notification routes not available:', err.message);
  }

} catch (error) {
  console.error('Error loading routes:', error);
  
  // Fallback API endpoint
  app.use('/api/*', (req, res) => {
    res.status(503).json({
      success: false,
      error: {
        code: 'SERVICE_UNAVAILABLE',
        message: 'API routes are temporarily unavailable'
      }
    });
  });
}

// Serve React static files
app.use(express.static(path.join(__dirname, '../frontend/build')));

// Catch-all handler: serve React app for any non-API routes
app.get('*', (req, res) => {
  try {
    res.sendFile(path.join(__dirname, '../frontend/build', 'index.html'));
  } catch (error) {
    res.status(500).json({
      success: false,
      error: {
        code: 'STATIC_FILE_ERROR',
        message: 'Unable to serve frontend files'
      }
    });
  }
});

// Global error handler
app.use((error, req, res, next) => {
  console.error('Global error:', error);
  res.status(500).json({
    success: false,
    error: {
      code: 'INTERNAL_SERVER_ERROR',
      message: 'Something went wrong'
    }
  });
});

// Export for Vercel (serverless)
module.exports = app;