#!/bin/bash

echo "🚀 Committing Vercel alignment changes..."

# Add all modified and new files
git add backend/index.js
git add backend/package.json
git add backend/src/config/database.js
git add frontend/build-production.js
git add frontend/package.json
git add frontend/.env.production
git add vercel.json
git add .gitignore
git add .github/
git add *.md
git add setup-vercel-deployment.sh
git add setup-vercel-deployment.ps1

# Show what will be committed
echo ""
echo "📋 Files to be committed:"
git status --short

echo ""
read -p "Continue with commit? (y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]
then
    # Commit with descriptive message
    git commit -m "Align Vercel support with mayfair-vercel (100% identical)

- Add backend/index.js serverless entry point
- Add frontend/build-production.js custom build script
- Add frontend/.env.production for relative API URLs
- Update backend/package.json to use build:production
- Update frontend/package.json with build:production script
- Fix database.js to remove process.exit() for serverless
- Add vercel.json deployment configuration
- Add GitHub Actions workflows for deployment
- Add comprehensive deployment documentation"

    echo ""
    echo "✅ Changes committed!"
    echo ""
    read -p "Push to GitHub? (y/n) " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        git push origin master
        echo ""
        echo "🎉 Changes pushed to GitHub!"
        echo ""
        echo "Next steps:"
        echo "1. Set environment variables in Vercel Dashboard"
        echo "2. Deploy via GitHub Actions or Vercel"
        echo "3. Test: https://mayfair-steel.vercel.app/health"
    else
        echo "⏸️  Push cancelled. Run 'git push origin master' when ready."
    fi
else
    echo "❌ Commit cancelled."
fi

