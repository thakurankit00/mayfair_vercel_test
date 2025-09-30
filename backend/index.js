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
    'https://mayfair-steel.vercel.app'
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

// Debug endpoint for environment variables (remove in production)
app.get('/api/debug', (req, res) => {
  const envCheck = {
    NODE_ENV: process.env.NODE_ENV,
    DATABASE_URL: process.env.DATABASE_URL ? 'SET' : 'NOT SET',
    SUPABASE_URL: process.env.SUPABASE_URL ? 'SET' : 'NOT SET',
    SUPABASE_ANON_KEY: process.env.SUPABASE_ANON_KEY ? 'SET' : 'NOT SET',
    JWT_SECRET: process.env.JWT_SECRET ? 'SET' : 'NOT SET',
    CORS_ORIGIN: process.env.CORS_ORIGIN || 'NOT SET'
  };

  res.status(200).json({
    success: true,
    environment: envCheck,
    timestamp: new Date().toISOString()
  });
});

// Import and use routes (with detailed error handling)
let routesLoaded = false;

try {
  console.log('Loading routes...');
  
  // Load routes one by one with individual error handling
  const routes = [
    { name: 'auth', path: './src/routes/auth', route: '/api/v1/auth' },
    { name: 'users', path: './src/routes/users', route: '/api/v1/users' },
    { name: 'dashboard', path: './src/routes/dashboard', route: '/api/v1/dashboard' },
    { name: 'rooms', path: './src/routes/rooms', route: '/api/v1/rooms' },
    { name: 'bookings', path: './src/routes/bookings', route: '/api/v1/bookings' },
    { name: 'restaurant', path: './src/routes/restaurant', route: '/api/v1/restaurant' },
    { name: 'upload', path: './src/routes/upload', route: '/api/v1/upload' }
  ];

  for (const routeConfig of routes) {
    try {
      const routeModule = require(routeConfig.path);
      app.use(routeConfig.route, routeModule);
      console.log(`✅ Loaded ${routeConfig.name} routes`);
    } catch (err) {
      console.error(`❌ Failed to load ${routeConfig.name} routes:`, err.message);
      
      // Create a fallback route for this specific endpoint
      app.use(routeConfig.route, (req, res) => {
        res.status(503).json({
          success: false,
          error: {
            code: 'ROUTE_UNAVAILABLE',
            message: `${routeConfig.name} routes are temporarily unavailable`,
            details: err.message
          }
        });
      });
    }
  }

  // Optional routes
  try {
    const reportsRoutes = require('./src/routes/reports');
    app.use('/api/v1/reports', reportsRoutes);
    console.log('✅ Loaded reports routes');
  } catch (err) {
    console.log('Reports routes not available:', err.message);
  }

  try {
    const paymentsRoutes = require('./src/routes/payments');
    app.use('/api/v1/payments', paymentsRoutes);
    console.log('✅ Loaded payments routes');
  } catch (err) {
    console.log('Payments routes not available:', err.message);
  }

  routesLoaded = true;
  console.log('✅ Route loading completed');

} catch (error) {
  console.error('❌ Critical error loading routes:', error);
  routesLoaded = false;
}

// Fallback for any unhandled API routes
app.use('/api/*', (req, res) => {
  if (!routesLoaded) {
    res.status(503).json({
      success: false,
      error: {
        code: 'SERVICE_UNAVAILABLE',
        message: 'API routes are temporarily unavailable - server initialization failed'
      }
    });
  } else {
    res.status(404).json({
      success: false,
      error: {
        code: 'NOT_FOUND',
        message: 'API endpoint not found'
      }
    });
  }
});

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

