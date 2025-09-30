# 🔐 Environment Variables Management Guide

## 🎯 Overview

This guide explains how to manage environment variables for database, API keys, and other sensitive data across different environments.

---

## 📊 Environment Variables Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    GitHub Repository                         │
│                                                              │
│  ┌────────────────────────────────────────────────────┐    │
│  │           GitHub Secrets                            │    │
│  │  (Used ONLY for GitHub Actions workflows)          │    │
│  │                                                     │    │
│  │  - VERCEL_TOKEN                                     │    │
│  │  - VERCEL_ORG_ID                                    │    │
│  │  - VERCEL_PROJECT_ID                                │    │
│  │  - REACT_APP_API_URL (optional, for build)         │    │
│  │  - REACT_APP_SOCKET_URL (optional, for build)      │    │
│  └────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
                            │
                            │ GitHub Actions deploys to
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                      Vercel Platform                         │
│                                                              │
│  ┌────────────────────────────────────────────────────┐    │
│  │      Vercel Environment Variables                   │    │
│  │  (Used at RUNTIME by your application)             │    │
│  │                                                     │    │
│  │  DATABASE & AUTH:                                   │    │
│  │  - DATABASE_URL                                     │    │
│  │  - SUPABASE_URL                                     │    │
│  │  - SUPABASE_ANON_KEY                                │    │
│  │  - JWT_SECRET                                       │    │
│  │                                                     │    │
│  │  SERVER CONFIG:                                     │    │
│  │  - NODE_ENV                                         │    │
│  │  - CORS_ORIGIN                                      │    │
│  │                                                     │    │
│  │  PAYMENT GATEWAYS:                                  │    │
│  │  - PAYU_MERCHANT_ID                                 │    │
│  │  - RAZORPAY_KEY_ID                                  │    │
│  │  - STRIPE_SECRET_KEY                                │    │
│  │                                                     │    │
│  │  FILE STORAGE:                                      │    │
│  │  - CLOUDINARY_CLOUD_NAME                            │    │
│  │  - CLOUDINARY_API_KEY                               │    │
│  └────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔑 Two Types of Environment Variables

### 1. **GitHub Secrets** (For Deployment)
- Used ONLY by GitHub Actions workflows
- Used to authenticate with Vercel
- NOT available to your application at runtime

### 2. **Vercel Environment Variables** (For Runtime)
- Used by your application when it runs
- Database connections, API keys, etc.
- Available to backend code at runtime

---

## 📝 Step-by-Step Setup

### Step 1: Add GitHub Secrets (For Deployment)

**Where:** GitHub Repository → Settings → Secrets and variables → Actions

**Required Secrets:**
```
VERCEL_TOKEN=vercel_xxxxxxxxxxxxxxxxxxxxx
VERCEL_ORG_ID=team_xxxxxxxxxxxxx
VERCEL_PROJECT_ID=prj_xxxxxxxxxxxxx
```

**Optional Secrets (for frontend build):**
```
REACT_APP_API_URL=https://mayfair-steel.vercel.app/api/v1
REACT_APP_SOCKET_URL=https://mayfair-steel.vercel.app
```

**How to Add:**
1. Go to your GitHub repository
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Enter name and value
5. Click **Add secret**

---

### Step 2: Add Vercel Environment Variables (For Runtime)

**Where:** Vercel Dashboard → Your Project → Settings → Environment Variables

**URL:** https://vercel.com/dashboard → mayfair-steel → Settings → Environment Variables

---

## 🗄️ Database Environment Variables

### Required Database Variables:

```env
# PostgreSQL Database URL
DATABASE_URL=postgresql://username:password@host:port/database

# Example with Supabase:
DATABASE_URL=postgresql://postgres.xxxxx:password@aws-0-ap-south-1.pooler.supabase.com:5432/postgres

# Supabase Configuration
SUPABASE_URL=https://xxxxxxxxxxxxx.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh4eHh4eHh4eHh4eHgiLCJyb2xlIjoiYW5vbiIsImlhdCI6MTYxNjE2MTYxNiwiZXhwIjoxOTMxNzM3NjE2fQ.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

### How to Get Database URL:

#### If using Supabase:
1. Go to https://supabase.com/dashboard
2. Select your project
3. Go to **Settings** → **Database**
4. Copy **Connection String** (URI format)
5. Replace `[YOUR-PASSWORD]` with your actual password

#### If using other PostgreSQL:
```
Format: postgresql://username:password@host:port/database

Example:
postgresql://mayfair_user:secure_password@db.example.com:5432/mayfair_hotel
```

---

## 🔐 Authentication Environment Variables

```env
# JWT Secret (IMPORTANT: Use a strong random string)
JWT_SECRET=your-super-secret-jwt-key-minimum-32-characters-long

# JWT Expiration
JWT_EXPIRES_IN=7d

# Bcrypt Salt Rounds
BCRYPT_SALT_ROUNDS=12
```

### How to Generate JWT Secret:

**Option 1: Using Node.js**
```bash
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

**Option 2: Using OpenSSL**
```bash
openssl rand -hex 32
```

**Option 3: Online Generator**
- Go to: https://www.grc.com/passwords.htm
- Copy the 63 character password

---

## 💳 Payment Gateway Environment Variables

### PayU:
```env
PAYU_MERCHANT_ID=your_merchant_id
PAYU_MERCHANT_KEY=your_merchant_key
PAYU_SALT=your_salt
```

### Razorpay:
```env
RAZORPAY_KEY_ID=rzp_live_xxxxxxxxxxxxx
RAZORPAY_KEY_SECRET=xxxxxxxxxxxxxxxxxxxxx
```

### Stripe:
```env
STRIPE_SECRET_KEY=sk_live_xxxxxxxxxxxxxxxxxxxxx
STRIPE_PUBLISHABLE_KEY=pk_live_xxxxxxxxxxxxxxxxxxxxx
```

**Where to Get:**
- PayU: https://dashboard.payu.in/
- Razorpay: https://dashboard.razorpay.com/
- Stripe: https://dashboard.stripe.com/

---

## 📁 File Storage Environment Variables

### Cloudinary:
```env
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=123456789012345
CLOUDINARY_API_SECRET=xxxxxxxxxxxxxxxxxxxxx
```

**Where to Get:**
1. Go to https://cloudinary.com/console
2. Copy from Dashboard

### AWS S3 (if using):
```env
AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
AWS_REGION=ap-south-1
AWS_S3_BUCKET=mayfair-hotel-uploads
```

---

## 🌐 Server Configuration Variables

```env
# Environment
NODE_ENV=production

# CORS Origin
CORS_ORIGIN=https://mayfair-steel.vercel.app

# Port (Vercel handles this automatically)
PORT=3000

# Build Configuration
DISABLE_ESLINT_PLUGIN=true
CI=false
```

---

## 📧 Email Service Variables (Optional)

### Using Nodemailer with Gmail:
```env
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USER=your-email@gmail.com
EMAIL_PASSWORD=your-app-specific-password
EMAIL_FROM=Mayfair Hotel <noreply@mayfairhotel.com>
```

### Using SendGrid:
```env
SENDGRID_API_KEY=SG.xxxxxxxxxxxxxxxxxxxxx
EMAIL_FROM=noreply@mayfairhotel.com
```

---

## 📱 SMS Service Variables (Optional)

### Twilio:
```env
TWILIO_ACCOUNT_SID=ACxxxxxxxxxxxxxxxxxxxxx
TWILIO_AUTH_TOKEN=xxxxxxxxxxxxxxxxxxxxx
TWILIO_PHONE_NUMBER=+1234567890
```

---

## 🎯 Complete Environment Variables Checklist

### ✅ Required for Production:

```env
# Database
DATABASE_URL=postgresql://...
SUPABASE_URL=https://...
SUPABASE_ANON_KEY=eyJ...

# Authentication
JWT_SECRET=your-secret-min-32-chars
JWT_EXPIRES_IN=7d
BCRYPT_SALT_ROUNDS=12

# Server
NODE_ENV=production
CORS_ORIGIN=https://mayfair-steel.vercel.app

# Build
DISABLE_ESLINT_PLUGIN=true
CI=false
```

### ⚠️ Optional (Add as needed):

```env
# Payment Gateways
PAYU_MERCHANT_ID=...
PAYU_MERCHANT_KEY=...
PAYU_SALT=...
RAZORPAY_KEY_ID=...
RAZORPAY_KEY_SECRET=...
STRIPE_SECRET_KEY=...

# File Storage
CLOUDINARY_CLOUD_NAME=...
CLOUDINARY_API_KEY=...
CLOUDINARY_API_SECRET=...

# Email
EMAIL_HOST=...
EMAIL_USER=...
EMAIL_PASSWORD=...

# SMS
TWILIO_ACCOUNT_SID=...
TWILIO_AUTH_TOKEN=...
```

---

## 🔧 How to Add Variables to Vercel

### Method 1: Via Vercel Dashboard (Recommended)

1. **Go to Vercel Dashboard**
   ```
   https://vercel.com/dashboard
   ```

2. **Select Your Project**
   ```
   Click on "mayfair-steel"
   ```

3. **Go to Settings**
   ```
   Click "Settings" tab
   ```

4. **Go to Environment Variables**
   ```
   Click "Environment Variables" in sidebar
   ```

5. **Add Variable**
   ```
   - Click "Add New"
   - Enter Key (e.g., DATABASE_URL)
   - Enter Value (e.g., postgresql://...)
   - Select Environments:
     ☑ Production
     ☑ Preview
     ☐ Development (optional)
   - Click "Save"
   ```

6. **Repeat for All Variables**

---

### Method 2: Via Vercel CLI

```bash
# Install Vercel CLI
npm install -g vercel

# Login
vercel login

# Link project
vercel link

# Add environment variable
vercel env add DATABASE_URL production
# Paste value when prompted

# Add for preview environment
vercel env add DATABASE_URL preview
# Paste value when prompted
```

---

## 🔄 Environment-Specific Variables

### Production vs Preview:

You can have **different values** for production and preview:

**Example:**

```
Production DATABASE_URL:
postgresql://prod_user:prod_pass@prod-db.supabase.co:5432/prod_db

Preview DATABASE_URL:
postgresql://dev_user:dev_pass@dev-db.supabase.co:5432/dev_db
```

**How to Set:**
1. Add variable in Vercel
2. Select **Production** environment
3. Add again with different value
4. Select **Preview** environment

---

## 🔍 Verify Environment Variables

### Check if Variables are Set:

1. **Deploy to Vercel**
2. **Check Function Logs**
   - Go to Vercel Dashboard
   - Click on deployment
   - Click "Functions" tab
   - Check logs for errors

3. **Test Health Endpoint**
   ```bash
   curl https://mayfair-steel.vercel.app/health
   ```

4. **Test Database Connection**
   ```bash
   curl https://mayfair-steel.vercel.app/api/test
   ```

---

## ⚠️ Security Best Practices

### ✅ DO:
- Use strong, random secrets
- Use different values for production and preview
- Rotate secrets regularly
- Use environment-specific databases
- Keep secrets in Vercel/GitHub only

### ❌ DON'T:
- Commit secrets to Git
- Share secrets in chat/email
- Use same secrets for dev and prod
- Use weak or predictable secrets
- Hardcode secrets in code

---

## 🐛 Troubleshooting

### Issue: "DATABASE_URL is not defined"

**Solution:**
1. Check Vercel environment variables
2. Ensure variable is set for correct environment (production/preview)
3. Redeploy after adding variables

### Issue: "JWT Secret must be at least 32 characters"

**Solution:**
1. Generate new secret: `node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"`
2. Add to Vercel environment variables
3. Redeploy

### Issue: "CORS error"

**Solution:**
1. Check `CORS_ORIGIN` in Vercel
2. Ensure it matches your domain
3. Check `backend/index.js` CORS configuration

---

## 📋 Quick Setup Checklist

- [ ] Add GitHub Secrets (VERCEL_TOKEN, VERCEL_ORG_ID, VERCEL_PROJECT_ID)
- [ ] Add DATABASE_URL to Vercel
- [ ] Add SUPABASE_URL to Vercel
- [ ] Add SUPABASE_ANON_KEY to Vercel
- [ ] Generate and add JWT_SECRET to Vercel
- [ ] Add CORS_ORIGIN to Vercel
- [ ] Add NODE_ENV=production to Vercel
- [ ] Add payment gateway keys (if using)
- [ ] Add file storage keys (if using)
- [ ] Test deployment
- [ ] Verify database connection
- [ ] Check application logs

---

## 📞 Need Help?

**Documentation:**
- [VERCEL_PROJECT_INFO.md](./VERCEL_PROJECT_INFO.md) - Project configuration
- [DEPLOYMENT_QUICK_START.md](./DEPLOYMENT_QUICK_START.md) - Quick start guide

**External Resources:**
- [Vercel Environment Variables Docs](https://vercel.com/docs/projects/environment-variables)
- [GitHub Secrets Docs](https://docs.github.com/en/actions/security-guides/encrypted-secrets)

---

**Remember:** Environment variables in Vercel are used at **runtime**, while GitHub Secrets are used during **deployment**!

