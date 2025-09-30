# GitHub Actions Deployment Guide for Mayfair Hotel Management System

This guide explains how to deploy the Mayfair Hotel Management System to Vercel using GitHub Actions workflows from any branch.

## 📋 Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Initial Setup](#initial-setup)
- [Deployment Workflows](#deployment-workflows)
- [Usage Guide](#usage-guide)
- [Configuration](#configuration)
- [Troubleshooting](#troubleshooting)
- [Best Practices](#best-practices)

---

## 🎯 Overview

We have implemented **two deployment workflows** that allow you to deploy from any branch:

### 1. **Simple Workflow** (Vercel Builds)
- ✅ Fast and simple
- ✅ Vercel handles the build
- ✅ Uses less GitHub Actions minutes
- 🎯 Best for: Quick deployments, feature testing

### 2. **Prebuilt Workflow** (GitHub Builds)
- ✅ Full control over build process
- ✅ Deterministic builds
- ✅ Can run tests and linting
- ✅ Better for debugging
- 🎯 Best for: Production deployments, CI/CD

**Note:** This deployment system is based on the working `mayfair-vercel` codebase that is already deployed and running on Vercel. The configuration uses `backend/index.js` as the entry point (not `backend/src/server.js`) to ensure compatibility with Vercel's serverless environment.

---

## 📦 Prerequisites

### 1. Vercel Account Setup

1. **Create a Vercel account** at [vercel.com](https://vercel.com)
2. **Create a new project** or link existing project
3. **Disable Git integration** (we'll use GitHub Actions instead):
   - Go to Project Settings → Git
   - Disconnect the Git repository

### 2. Get Vercel Credentials

#### Get Vercel Token:
```bash
# Go to: https://vercel.com/account/tokens
# Create a new token with:
# - Name: "GitHub Actions Deployment"
# - Scope: Your team/account
# - Expiration: Set appropriate expiration (e.g., 1 year)
# - Save the token securely (you'll only see it once)
```

#### Get Organization and Project IDs:
```bash
# Install Vercel CLI globally
npm install -g vercel

# Login to Vercel
vercel login

# Navigate to your project directory
cd mayfair-master

# Link to your Vercel project
vercel link

# View the project configuration
cat .vercel/project.json
```

The `.vercel/project.json` will contain:
```json
{
  "orgId": "team_xxxxxxxxxxxxx",
  "projectId": "prj_xxxxxxxxxxxxx"
}
```

**⚠️ Important:** Add `.vercel` to your `.gitignore` to avoid committing these files.

---

## 🔧 Initial Setup

### Step 1: Add GitHub Secrets

1. Go to your GitHub repository
2. Navigate to **Settings → Secrets and variables → Actions**
3. Click **New repository secret**
4. Add the following secrets:

| Secret Name | Description | Example |
|-------------|-------------|---------|
| `VERCEL_TOKEN` | Your Vercel authentication token | `abc123...` |
| `VERCEL_ORG_ID` | Your Vercel organization/team ID | `team_xxxxx` |
| `VERCEL_PROJECT_ID` | Your Vercel project ID | `prj_xxxxx` |
| `REACT_APP_API_URL` | Frontend API URL (optional) | `https://api.example.com` |
| `REACT_APP_SOCKET_URL` | Socket.io URL (optional) | `https://api.example.com` |

### Step 2: Configure Vercel Environment Variables

Go to your Vercel project dashboard → Settings → Environment Variables

Add these variables for **Production** and **Preview** environments:

#### Required Variables:
```env
# Database
DATABASE_URL=postgresql://user:password@host:5432/database
SUPABASE_URL=https://xxxxx.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

# Authentication
JWT_SECRET=your-super-secret-jwt-key-min-32-chars
JWT_EXPIRES_IN=7d
BCRYPT_SALT_ROUNDS=12

# Server
NODE_ENV=production
PORT=3000
```

#### Optional Variables:
```env
# Payment Gateways
PAYU_MERCHANT_ID=your_merchant_id
PAYU_MERCHANT_KEY=your_merchant_key
PAYU_SALT=your_salt
RAZORPAY_KEY_ID=rzp_live_xxxxx
RAZORPAY_KEY_SECRET=xxxxx
STRIPE_SECRET_KEY=sk_live_xxxxx

# File Storage
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_API_SECRET=your_api_secret

# CORS
CORS_ORIGIN=https://mayfair-steel.vercel.app

# Rate Limiting
RATE_LIMIT_WINDOW=15
RATE_LIMIT_MAX_REQUESTS=100
```

### Step 3: Verify Configuration Files

Ensure these files exist in your project:

- ✅ `.github/workflows/deploy-vercel-simple.yml`
- ✅ `.github/workflows/deploy-vercel-prebuilt.yml`
- ✅ `vercel.json`
- ✅ `.gitignore` (includes `.vercel/`)

---

## 🚀 Deployment Workflows

### Workflow 1: Simple Deployment (Vercel Builds)

**File:** `.github/workflows/deploy-vercel-simple.yml`

**Process:**
1. Checkout code from specified branch
2. Setup Node.js 18
3. Install Vercel CLI
4. Link Vercel project
5. Deploy to Vercel (Vercel handles build)

**Best for:**
- Quick feature deployments
- Testing changes
- Preview deployments
- When build is straightforward

### Workflow 2: Prebuilt Deployment (GitHub Builds)

**File:** `.github/workflows/deploy-vercel-prebuilt.yml`

**Process:**
1. Checkout code from specified branch
2. Setup Node.js 18 with caching
3. Install backend dependencies
4. Install frontend dependencies
5. Run linting (optional, continues on error)
6. Build frontend in GitHub Actions
7. Install Vercel CLI
8. Link Vercel project
9. Pull Vercel environment info
10. Build Vercel artifacts
11. Deploy prebuilt to Vercel

**Best for:**
- Production deployments
- When you need deterministic builds
- When running tests before deployment
- Better debugging capabilities

---

## 📖 Usage Guide

### Deploying from Any Branch

#### Method 1: GitHub UI (Recommended)

1. **Go to your repository on GitHub**
2. **Click on the "Actions" tab**
3. **Select a workflow:**
   - "Deploy to Vercel (Simple)" or
   - "Deploy to Vercel (Prebuilt)"
4. **Click "Run workflow" button**
5. **Fill in the inputs:**
   - **Branch:** Enter the branch name (e.g., `main`, `develop`, `feature/new-ui`)
   - **Environment:** Select `production` or `preview`
6. **Click "Run workflow"**
7. **Monitor the deployment:**
   - Watch the workflow progress
   - Check the deployment summary
   - Get the deployment URL from the summary

#### Method 2: GitHub CLI

```bash
# Install GitHub CLI if not already installed
# https://cli.github.com/

# Deploy using Simple workflow
gh workflow run "Deploy to Vercel (Simple)" \
  -f branch=main \
  -f environment=preview

# Deploy using Prebuilt workflow
gh workflow run "Deploy to Vercel (Prebuilt)" \
  -f branch=feature/new-feature \
  -f environment=preview

# Deploy to production
gh workflow run "Deploy to Vercel (Prebuilt)" \
  -f branch=main \
  -f environment=production
```

#### Method 3: API Request

```bash
# Get your GitHub Personal Access Token
# https://github.com/settings/tokens

curl -X POST \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Authorization: token YOUR_GITHUB_TOKEN" \
  https://api.github.com/repos/YOUR_USERNAME/YOUR_REPO/actions/workflows/deploy-vercel-simple.yml/dispatches \
  -d '{"ref":"main","inputs":{"branch":"main","environment":"preview"}}'
```

---

## 🎯 Deployment Scenarios

### Scenario 1: Deploy Feature Branch for Testing
```
Workflow: Simple
Branch: feature/new-booking-flow
Environment: preview
```

### Scenario 2: Deploy to Production
```
Workflow: Prebuilt
Branch: main
Environment: production
```

### Scenario 3: Deploy Hotfix
```
Workflow: Prebuilt
Branch: hotfix/payment-bug
Environment: preview (test first)
Then: production (after verification)
```

### Scenario 4: Deploy Development Branch
```
Workflow: Simple
Branch: develop
Environment: preview
```

---

## 🔍 Monitoring Deployments

### GitHub Actions

1. Go to **Actions** tab in your repository
2. Click on the running/completed workflow
3. View detailed logs for each step
4. Check the deployment summary at the bottom

### Vercel Dashboard

1. Go to [vercel.com/dashboard](https://vercel.com/dashboard)
2. Select your project
3. View deployments list
4. Click on a deployment to see:
   - Build logs
   - Function logs
   - Deployment URL
   - Environment variables used

---

## 🐛 Troubleshooting

### Common Issues

#### 1. "VERCEL_TOKEN is not set"
**Solution:** Add `VERCEL_TOKEN` to GitHub Secrets

#### 2. "Project not found"
**Solution:** Verify `VERCEL_ORG_ID` and `VERCEL_PROJECT_ID` are correct

#### 3. Build fails with ESLint errors
**Solution:** 
- Fix linting errors in your code, or
- The prebuilt workflow continues on linting errors
- Check `DISABLE_ESLINT_PLUGIN=true` is set

#### 4. Frontend shows 404 for API calls
**Solution:**
- Check `vercel.json` routes configuration
- Verify API routes start with `/api/`
- Check CORS settings in backend

#### 5. Database connection fails
**Solution:**
- Verify `DATABASE_URL` in Vercel environment variables
- Check database is accessible from Vercel's IP ranges
- Test connection with Vercel CLI: `vercel env pull`

---

## ✅ Best Practices

### 1. Branch Strategy
- Use `preview` for all non-production branches
- Use `production` only for `main` or `release` branches
- Test in preview before promoting to production

### 2. Security
- Never commit secrets to repository
- Rotate Vercel tokens regularly
- Use environment-specific secrets
- Review deployment logs for sensitive data

### 3. Performance
- Use prebuilt workflow for production (deterministic builds)
- Use simple workflow for quick testing
- Monitor build times and optimize if needed
- Leverage caching in prebuilt workflow

### 4. Testing
- Always deploy to preview first
- Test thoroughly before production deployment
- Use preview URLs for QA and stakeholder review
- Set up automated tests in prebuilt workflow

### 5. Monitoring
- Check deployment summaries
- Monitor Vercel function logs
- Set up error tracking (e.g., Sentry)
- Monitor database performance

---

## 📚 Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Vercel CLI Documentation](https://vercel.com/docs/cli)
- [Vercel Deployment Documentation](https://vercel.com/docs/deployments)
- [Workflow Plan Details](./workflow_plan.md)
- [Workflow README](./.github/workflows/README.md)

---

## 🆘 Getting Help

If you encounter issues:

1. Check this guide
2. Review `.github/workflows/README.md`
3. Check GitHub Actions logs
4. Check Vercel deployment logs
5. Verify all secrets are set correctly
6. Test locally with `vercel dev`

---

**Happy Deploying! 🚀**

