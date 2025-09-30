# 🚀 Quick Start: Deploy to Vercel via GitHub Actions

This is a quick reference guide for deploying the Mayfair Hotel Management System to Vercel using GitHub Actions.

## ⚡ TL;DR - Deploy in 5 Minutes

### 1. Run Setup Script (One-time)

**Windows (PowerShell):**
```powershell
cd mayfair-master
.\setup-vercel-deployment.ps1
```

**Mac/Linux (Bash):**
```bash
cd mayfair-master
chmod +x setup-vercel-deployment.sh
./setup-vercel-deployment.sh
```

### 2. Add GitHub Secrets

Go to: `https://github.com/YOUR_USERNAME/YOUR_REPO/settings/secrets/actions`

Add these 3 secrets (values from `.vercel-secrets.txt`):
- `VERCEL_TOKEN`
- `VERCEL_ORG_ID`
- `VERCEL_PROJECT_ID`

### 3. Add Vercel Environment Variables (CRITICAL!)

Go to: `https://vercel.com/dashboard` → Your Project → Settings → Environment Variables

**Required:**
- `DATABASE_URL` - Your PostgreSQL/Supabase connection string
- `SUPABASE_URL` - Your Supabase project URL
- `SUPABASE_ANON_KEY` - Your Supabase anon key
- `JWT_SECRET` - Random 32+ character string
- `NODE_ENV=production`
- `CORS_ORIGIN=https://mayfair-steel.vercel.app`

**See:** [ENVIRONMENT_VARIABLES_GUIDE.md](./ENVIRONMENT_VARIABLES_GUIDE.md) for complete list

### 4. Deploy!

1. Go to GitHub → **Actions** tab
2. Select **"Deploy to Vercel (Simple)"**
3. Click **"Run workflow"**
4. Enter:
   - **Branch:** `main` (or any branch)
   - **Environment:** `preview`
5. Click **"Run workflow"**
6. Wait ~2-5 minutes
7. Get your deployment URL from the workflow summary! 🎉

---

## 📋 Two Deployment Options

### Option 1: Simple (Recommended for Testing)
- ✅ Fast (2-3 minutes)
- ✅ Easy
- ✅ Vercel handles build
- 🎯 Use for: Feature testing, quick deployments

**Workflow:** `Deploy to Vercel (Simple)`

### Option 2: Prebuilt (Recommended for Production)
- ✅ Full control
- ✅ Deterministic builds
- ✅ Can run tests
- 🎯 Use for: Production, CI/CD

**Workflow:** `Deploy to Vercel (Prebuilt)`

---

## 🎯 Common Deployment Scenarios

### Deploy Feature Branch for Testing
```
Workflow: Deploy to Vercel (Simple)
Branch: feature/new-feature
Environment: preview
```

### Deploy to Production
```
Workflow: Deploy to Vercel (Prebuilt)
Branch: main
Environment: production
```

### Deploy Hotfix
```
1. Deploy to preview first:
   Workflow: Deploy to Vercel (Prebuilt)
   Branch: hotfix/critical-bug
   Environment: preview

2. Test thoroughly

3. Deploy to production:
   Workflow: Deploy to Vercel (Prebuilt)
   Branch: hotfix/critical-bug
   Environment: production
```

---

## 🔧 Required Vercel Environment Variables

Add these in Vercel Dashboard → Project Settings → Environment Variables:

### Minimum Required:
```env
DATABASE_URL=postgresql://...
SUPABASE_URL=https://...
SUPABASE_ANON_KEY=eyJ...
JWT_SECRET=your-secret-min-32-chars
```

### Recommended:
```env
NODE_ENV=production
CORS_ORIGIN=https://mayfair-steel.vercel.app
PAYU_MERCHANT_ID=...
PAYU_MERCHANT_KEY=...
PAYU_SALT=...
CLOUDINARY_CLOUD_NAME=...
CLOUDINARY_API_KEY=...
CLOUDINARY_API_SECRET=...
```

---

## 🐛 Quick Troubleshooting

### Deployment Fails
1. Check GitHub Actions logs
2. Verify all 3 secrets are added correctly
3. Check Vercel dashboard for errors

### Build Fails
1. Test locally: `npm run build` in frontend/
2. Check for ESLint errors
3. Verify all dependencies are in package.json

### API Not Working
1. Check `vercel.json` routes
2. Verify environment variables in Vercel
3. Check CORS settings

### Database Connection Fails
1. Verify `DATABASE_URL` in Vercel
2. Check database is accessible
3. Test connection: `vercel env pull`

---

## 📚 Full Documentation

- **Complete Guide:** [GITHUB_ACTIONS_DEPLOYMENT.md](./GITHUB_ACTIONS_DEPLOYMENT.md)
- **Workflow Details:** [.github/workflows/README.md](./.github/workflows/README.md)
- **Workflow Plan:** [workflow_plan.md](../workflow_plan.md)

---

## 🆘 Need Help?

1. Read [GITHUB_ACTIONS_DEPLOYMENT.md](./GITHUB_ACTIONS_DEPLOYMENT.md)
2. Check GitHub Actions logs
3. Check Vercel deployment logs
4. Verify secrets are set correctly
5. Test locally with `vercel dev`

---

## ✅ Checklist

Before first deployment:

- [ ] Vercel account created
- [ ] Vercel project created
- [ ] Setup script run successfully
- [ ] GitHub secrets added (3 secrets)
- [ ] Vercel environment variables configured
- [ ] `.vercel` added to `.gitignore`
- [ ] Workflow files exist in `.github/workflows/`
- [ ] `vercel.json` exists in project root

Ready to deploy:

- [ ] Code pushed to GitHub
- [ ] Branch name known
- [ ] Environment chosen (preview/production)
- [ ] GitHub Actions workflow selected
- [ ] Deployment started

After deployment:

- [ ] Deployment successful
- [ ] Deployment URL accessible
- [ ] API endpoints working
- [ ] Frontend loads correctly
- [ ] Database connection working
- [ ] Environment variables loaded

---

**Happy Deploying! 🚀**

For detailed instructions, see: [GITHUB_ACTIONS_DEPLOYMENT.md](./GITHUB_ACTIONS_DEPLOYMENT.md)

