# 🚀 Mayfair Hotel - GitHub Actions Deployment to Vercel

Welcome! This directory contains everything you need to deploy the Mayfair Hotel Management System to Vercel using GitHub Actions.

## 🌟 **KEY FEATURE: Deploy ANY Branch - Even Without Vercel Files!**

The workflows **automatically inject** Vercel support files into any branch you deploy. This means you can deploy:
- ✅ Old branches without Vercel files
- ✅ Feature branches created before Vercel setup
- ✅ Hotfix branches
- ✅ ANY branch in your repository!

**No manual setup required!** See [DEPLOY_ANY_BRANCH.md](./DEPLOY_ANY_BRANCH.md) for details.

---

## 📚 Documentation Index

Choose the guide that fits your needs:

### 🔐 **Environment Variables (IMPORTANT!)**
**[ENVIRONMENT_VARIABLES_GUIDE.md](./ENVIRONMENT_VARIABLES_GUIDE.md)**
- How to handle DATABASE_URL and secrets
- GitHub Secrets vs Vercel Environment Variables
- Step-by-step setup guide
- Database, payment, storage configuration
- **READ THIS to set up your environment properly**

### 🌐 **Project Information**
**[VERCEL_PROJECT_INFO.md](./VERCEL_PROJECT_INFO.md)**
- Production URL: https://mayfair-steel.vercel.app/
- Environment variables reference
- API endpoints
- CORS configuration
- Testing & monitoring

### 🌟 **Deploy ANY Branch (NEW!)**
**[DEPLOY_ANY_BRANCH.md](./DEPLOY_ANY_BRANCH.md)**
- Deploy branches without Vercel files
- Automatic file injection
- How it works
- Use cases and examples
- **Deploy old branches, feature branches, hotfixes - anything!**

### ⚠️ **IMPORTANT: Read This First**
**[VERCEL_DEPLOYMENT_FIXES.md](./VERCEL_DEPLOYMENT_FIXES.md)**
- Critical fixes applied to mayfair-master
- Why backend/index.js instead of backend/src/server.js
- Differences from mayfair-vercel
- Architecture explanation
- **READ THIS to understand the deployment setup**

### 🎯 Quick Start (5 minutes)
**[DEPLOYMENT_QUICK_START.md](./DEPLOYMENT_QUICK_START.md)**
- Fast setup and deployment
- Common scenarios
- Quick troubleshooting
- Perfect for: Getting started quickly

### 📖 Complete Guide (Detailed)
**[GITHUB_ACTIONS_DEPLOYMENT.md](./GITHUB_ACTIONS_DEPLOYMENT.md)**
- Comprehensive setup instructions
- Detailed workflow explanations
- Configuration guide
- Troubleshooting section
- Best practices
- Perfect for: Understanding the full system

### 📋 Workflow Details
**[.github/workflows/README.md](./.github/workflows/README.md)**
- Workflow-specific documentation
- Technical details
- Comparison table
- Perfect for: Understanding how workflows work

### 📊 System Overview
**[DEPLOYMENT_SUMMARY.md](./DEPLOYMENT_SUMMARY.md)**
- What was added
- System architecture
- File listing
- Perfect for: Getting an overview

### 📝 Original Plan
**[workflow_plan.md](../workflow_plan.md)**
- Detailed technical plan
- Vercel CLI usage
- Security considerations
- Perfect for: Deep technical understanding

---

## ⚡ Quick Start

### 1️⃣ Run Setup Script (One-time)

**Windows:**
```powershell
cd mayfair-master
.\setup-vercel-deployment.ps1
```

**Mac/Linux:**
```bash
cd mayfair-master
chmod +x setup-vercel-deployment.sh
./setup-vercel-deployment.sh
```

### 2️⃣ Add GitHub Secrets

Go to: `Settings → Secrets and variables → Actions`

Add these 3 secrets (from `.vercel-secrets.txt`):
- `VERCEL_TOKEN`
- `VERCEL_ORG_ID`
- `VERCEL_PROJECT_ID`

### 3️⃣ Deploy!

1. Go to **Actions** tab
2. Select **"Deploy to Vercel (Simple)"**
3. Click **"Run workflow"**
4. Enter branch name and environment
5. Click **"Run workflow"**
6. Get your deployment URL! 🎉

---

## 🎯 Two Deployment Workflows

### Simple Workflow (Fast & Easy)
```
File: .github/workflows/deploy-vercel-simple.yml
Build: Vercel handles it
Time: 2-3 minutes
Best for: Testing, quick deployments
```

### Prebuilt Workflow (Full Control)
```
File: .github/workflows/deploy-vercel-prebuilt.yml
Build: GitHub Actions
Time: 4-6 minutes
Best for: Production, CI/CD
```

---

## 📁 Project Structure

```
mayfair-master/
├── .github/
│   └── workflows/
│       ├── deploy-vercel-simple.yml      # Simple deployment workflow
│       ├── deploy-vercel-prebuilt.yml    # Prebuilt deployment workflow
│       └── README.md                      # Workflow documentation
│
├── backend/                               # Backend source code
├── frontend/                              # Frontend source code
│
├── vercel.json                            # Vercel configuration
├── .gitignore                             # Updated with .vercel
│
├── setup-vercel-deployment.sh             # Setup script (Mac/Linux)
├── setup-vercel-deployment.ps1            # Setup script (Windows)
│
├── DEPLOYMENT_README.md                   # This file
├── DEPLOYMENT_QUICK_START.md              # Quick start guide
├── GITHUB_ACTIONS_DEPLOYMENT.md           # Complete guide
└── DEPLOYMENT_SUMMARY.md                  # System overview
```

---

## 🔧 Prerequisites

- ✅ Vercel account
- ✅ GitHub repository
- ✅ Node.js 18+
- ✅ npm or yarn

---

## 🎓 How to Use This System

### For First-Time Setup:
1. Read [DEPLOYMENT_QUICK_START.md](./DEPLOYMENT_QUICK_START.md)
2. Run setup script
3. Add GitHub secrets
4. Configure Vercel environment variables
5. Test deployment

### For Regular Deployments:
1. Go to GitHub Actions
2. Select workflow
3. Run with branch name
4. Get deployment URL

### For Troubleshooting:
1. Check [GITHUB_ACTIONS_DEPLOYMENT.md](./GITHUB_ACTIONS_DEPLOYMENT.md) troubleshooting section
2. Review GitHub Actions logs
3. Check Vercel dashboard
4. Verify secrets and environment variables

### For Understanding the System:
1. Read [DEPLOYMENT_SUMMARY.md](./DEPLOYMENT_SUMMARY.md)
2. Review [.github/workflows/README.md](./.github/workflows/README.md)
3. Check [workflow_plan.md](../workflow_plan.md)

---

## 🚀 Deployment Scenarios

### Deploy Feature for Testing
```yaml
Workflow: Simple
Branch: feature/new-ui
Environment: preview
```

### Deploy to Production
```yaml
Workflow: Prebuilt
Branch: main
Environment: production
```

### Deploy Hotfix
```yaml
Step 1:
  Workflow: Prebuilt
  Branch: hotfix/bug
  Environment: preview

Step 2 (after testing):
  Workflow: Prebuilt
  Branch: hotfix/bug
  Environment: production
```

---

## 🔒 Security

- ✅ Secrets stored in GitHub (encrypted)
- ✅ Never committed to repository
- ✅ Token rotation supported
- ✅ Environment-specific variables
- ✅ Vercel token scoped to team

---

## 📊 Workflow Comparison

| Feature | Simple | Prebuilt |
|---------|--------|----------|
| Speed | ⚡⚡⚡ | ⚡⚡ |
| Control | ⭐⭐ | ⭐⭐⭐ |
| Debugging | ⭐⭐ | ⭐⭐⭐ |
| Best For | Testing | Production |

---

## ✅ Checklist

### Before First Deployment:
- [ ] Vercel account created
- [ ] Setup script completed
- [ ] GitHub secrets added
- [ ] Vercel environment variables configured
- [ ] Workflow files verified

### Before Each Deployment:
- [ ] Code pushed to GitHub
- [ ] Branch name known
- [ ] Environment chosen
- [ ] Workflow selected

### After Deployment:
- [ ] Deployment successful
- [ ] URL accessible
- [ ] API working
- [ ] Frontend loads
- [ ] Database connected

---

## 🐛 Common Issues

### "VERCEL_TOKEN is not set"
→ Add secret to GitHub

### "Project not found"
→ Verify ORG_ID and PROJECT_ID

### Build fails
→ Check GitHub Actions logs

### API not working
→ Check vercel.json routes

### Database connection fails
→ Verify DATABASE_URL in Vercel

**Full troubleshooting:** [GITHUB_ACTIONS_DEPLOYMENT.md](./GITHUB_ACTIONS_DEPLOYMENT.md#troubleshooting)

---

## 📞 Getting Help

1. **Quick issues:** Check [DEPLOYMENT_QUICK_START.md](./DEPLOYMENT_QUICK_START.md)
2. **Detailed help:** Read [GITHUB_ACTIONS_DEPLOYMENT.md](./GITHUB_ACTIONS_DEPLOYMENT.md)
3. **Workflow issues:** See [.github/workflows/README.md](./.github/workflows/README.md)
4. **System overview:** Review [DEPLOYMENT_SUMMARY.md](./DEPLOYMENT_SUMMARY.md)

---

## 🎯 Key Features

✅ **Deploy from any branch** - No need to merge first  
✅ **Two workflow options** - Choose based on needs  
✅ **Manual trigger** - Full control over deployments  
✅ **Environment selection** - Preview or production  
✅ **Deployment summaries** - Clear URLs and info  
✅ **Security** - Secrets properly managed  
✅ **Fast** - 2-6 minute deployments  
✅ **Reliable** - Deterministic builds available  

---

## 🌟 Benefits

1. **Flexibility** - Deploy any branch anytime
2. **Safety** - Test in preview first
3. **Speed** - Fast deployments
4. **Control** - Choose when to deploy
5. **Visibility** - Clear deployment info
6. **Security** - Proper secret management
7. **Simplicity** - Easy to use
8. **Reliability** - Consistent builds

---

## 📚 Additional Resources

- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [Vercel CLI Docs](https://vercel.com/docs/cli)
- [Vercel Deployment Docs](https://vercel.com/docs/deployments)
- [Vercel Environment Variables](https://vercel.com/docs/projects/environment-variables)

---

## 🎉 Ready to Deploy?

1. **First time?** → Start with [DEPLOYMENT_QUICK_START.md](./DEPLOYMENT_QUICK_START.md)
2. **Need details?** → Read [GITHUB_ACTIONS_DEPLOYMENT.md](./GITHUB_ACTIONS_DEPLOYMENT.md)
3. **Want overview?** → Check [DEPLOYMENT_SUMMARY.md](./DEPLOYMENT_SUMMARY.md)

---

**Happy Deploying! 🚀**

*For questions or issues, refer to the documentation files listed above.*

