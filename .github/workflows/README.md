# GitHub Actions Workflows for Vercel Deployment

This directory contains GitHub Actions workflows for deploying the Mayfair Hotel Management System to Vercel.

## 📋 Available Workflows

### 1. **Deploy to Vercel (Simple)** - `deploy-vercel-simple.yml`

**Best for:** Quick deployments, testing, when you want Vercel to handle the build.

**How it works:**
- Checks out your code
- Installs Vercel CLI
- Deploys directly to Vercel
- Vercel handles the build process

**Pros:**
- ✅ Faster workflow execution
- ✅ Less GitHub Actions minutes used
- ✅ Simpler configuration
- ✅ Vercel's optimized build environment

**Cons:**
- ❌ Less control over build process
- ❌ Harder to debug build issues
- ❌ Can't run custom build steps

**When to use:**
- Quick feature branch deployments
- Testing changes
- When build is straightforward

---

### 2. **Deploy to Vercel (Prebuilt)** - `deploy-vercel-prebuilt.yml`

**Best for:** Production deployments, deterministic builds, CI/CD pipelines.

**How it works:**
- Checks out your code
- Installs dependencies in GitHub Actions
- Runs linting (optional)
- Builds frontend in GitHub Actions
- Creates Vercel build artifacts
- Deploys prebuilt artifacts to Vercel

**Pros:**
- ✅ Full control over build environment
- ✅ Deterministic builds
- ✅ Can run tests before deployment
- ✅ Better for debugging
- ✅ Caching for faster builds

**Cons:**
- ❌ Uses more GitHub Actions minutes
- ❌ Longer workflow execution time
- ❌ More complex configuration

**When to use:**
- Production deployments
- When you need to run tests
- When you need consistent builds
- When debugging build issues

---

## 🚀 How to Use

### Prerequisites

1. **Create a Vercel Account** and project
2. **Get Vercel Tokens:**
   - Go to [Vercel Account Settings → Tokens](https://vercel.com/account/tokens)
   - Create a new token with appropriate scope
   - Save it securely

3. **Get Project IDs:**
   ```bash
   # Install Vercel CLI
   npm install -g vercel
   
   # Login to Vercel
   vercel login
   
   # Link your project (run from project root)
   vercel link
   
   # Get your IDs from .vercel/project.json
   cat .vercel/project.json
   ```

4. **Add GitHub Secrets:**
   - Go to your GitHub repository
   - Navigate to **Settings → Secrets and variables → Actions**
   - Add the following secrets:
     - `VERCEL_TOKEN` - Your Vercel token
     - `VERCEL_ORG_ID` - Your Vercel organization/team ID
     - `VERCEL_PROJECT_ID` - Your Vercel project ID
     - `REACT_APP_API_URL` - Your API URL (optional, for frontend)
     - `REACT_APP_SOCKET_URL` - Your Socket.io URL (optional, for frontend)

### Running the Workflows

#### Option 1: Manual Trigger (Recommended)

1. Go to your GitHub repository
2. Click on **Actions** tab
3. Select the workflow you want to run:
   - "Deploy to Vercel (Simple)" or
   - "Deploy to Vercel (Prebuilt)"
4. Click **Run workflow**
5. Fill in the inputs:
   - **Branch:** The branch you want to deploy (e.g., `main`, `develop`, `feature/new-feature`)
   - **Environment:** Choose `production` or `preview`
6. Click **Run workflow**

#### Option 2: Automatic Trigger (Optional)

You can modify the workflows to trigger automatically on push or pull request:

```yaml
on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]
  workflow_dispatch:
    # ... keep manual trigger option
```

---

## 🔧 Configuration

### Environment Variables

Set these in Vercel Dashboard (Project Settings → Environment Variables):

#### Required
- `DATABASE_URL` - PostgreSQL connection string
- `SUPABASE_URL` - Supabase project URL
- `SUPABASE_ANON_KEY` - Supabase anonymous key
- `JWT_SECRET` - Secret for JWT tokens

#### Optional
- `CORS_ORIGIN` - Frontend URL (auto-detected by Vercel)
- `RATE_LIMIT_WINDOW` - Rate limiting window (default: 15)
- `RATE_LIMIT_MAX_REQUESTS` - Max requests per window (default: 100)
- `PAYU_MERCHANT_ID` - PayU merchant ID
- `PAYU_MERCHANT_KEY` - PayU merchant key
- `PAYU_SALT` - PayU salt
- `CLOUDINARY_CLOUD_NAME` - Cloudinary cloud name
- `CLOUDINARY_API_KEY` - Cloudinary API key
- `CLOUDINARY_API_SECRET` - Cloudinary API secret

### Vercel Configuration

The `vercel.json` file in the project root configures:
- Build settings
- Routes (API, static files, frontend)
- Function settings (memory, timeout)
- Environment variables
- Region (Singapore - `sin1`)

---

## 📊 Workflow Comparison

| Feature | Simple | Prebuilt |
|---------|--------|----------|
| Build Location | Vercel | GitHub Actions |
| Build Time | Faster | Slower |
| GitHub Minutes | Less | More |
| Control | Less | More |
| Debugging | Harder | Easier |
| Caching | Vercel | GitHub + Vercel |
| Tests | No | Yes |
| Linting | No | Yes |
| Best For | Quick deploys | Production |

---

## 🐛 Troubleshooting

### Deployment Fails

1. **Check GitHub Actions logs:**
   - Go to Actions tab
   - Click on the failed workflow
   - Review each step's logs

2. **Verify secrets:**
   - Ensure all required secrets are set
   - Check for typos in secret names
   - Verify token hasn't expired

3. **Check Vercel logs:**
   - Go to Vercel Dashboard
   - Select your project
   - Check deployment logs

### Build Errors

**ESLint Errors:**
- The workflows are configured to continue on linting errors
- Fix linting issues in your code for cleaner builds

**Dependency Issues:**
- Clear cache and retry
- Check `package-lock.json` is committed
- Verify Node version compatibility

**Environment Variables:**
- Ensure all required env vars are set in Vercel
- Check variable names match exactly

### Deployment URL Not Working

1. **Check routes in `vercel.json`:**
   - Verify API routes are correct
   - Ensure frontend routes fallback to `index.html`

2. **Check CORS settings:**
   - Verify `CORS_ORIGIN` is set correctly
   - Check backend CORS configuration

3. **Check database connection:**
   - Verify `DATABASE_URL` is correct
   - Ensure database is accessible from Vercel

---

## 📚 Additional Resources

- [Vercel CLI Documentation](https://vercel.com/docs/cli)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Vercel Deployment Documentation](https://vercel.com/docs/deployments/overview)
- [Vercel Environment Variables](https://vercel.com/docs/projects/environment-variables)

---

## 🔒 Security Best Practices

1. **Never commit secrets** to the repository
2. **Rotate tokens regularly** (set expiration in Vercel)
3. **Use team tokens** for team projects
4. **Limit token scope** to specific projects if possible
5. **Review deployment logs** for sensitive information
6. **Use environment-specific secrets** (production vs preview)

---

## 💡 Tips

1. **Use preview deployments** for testing before production
2. **Set up branch protection** to require successful deployments
3. **Monitor deployment times** and optimize if needed
4. **Use caching** to speed up builds (prebuilt workflow)
5. **Test locally** before deploying: `vercel dev`
6. **Use deployment aliases** for stable URLs

---

## 🆘 Support

If you encounter issues:

1. Check this README
2. Review workflow logs in GitHub Actions
3. Check Vercel deployment logs
4. Verify all secrets are set correctly
5. Test deployment locally with `vercel` CLI
6. Check the `workflow_plan.md` in project root for detailed information

---

**Happy Deploying! 🚀**

