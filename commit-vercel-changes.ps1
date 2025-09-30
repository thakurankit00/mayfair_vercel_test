# PowerShell script to commit Vercel alignment changes

Write-Host "🚀 Committing Vercel alignment changes..." -ForegroundColor Cyan

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
Write-Host ""
Write-Host "📋 Files to be committed:" -ForegroundColor Yellow
git status --short

Write-Host ""
$continue = Read-Host "Continue with commit? (y/n)"

if ($continue -eq "y" -or $continue -eq "Y") {
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

    Write-Host ""
    Write-Host "✅ Changes committed!" -ForegroundColor Green
    Write-Host ""
    
    $push = Read-Host "Push to GitHub? (y/n)"
    
    if ($push -eq "y" -or $push -eq "Y") {
        git push origin master
        Write-Host ""
        Write-Host "🎉 Changes pushed to GitHub!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Next steps:" -ForegroundColor Cyan
        Write-Host "1. Set environment variables in Vercel Dashboard"
        Write-Host "2. Deploy via GitHub Actions or Vercel"
        Write-Host "3. Test: https://mayfair-steel.vercel.app/health"
    }
    else {
        Write-Host "⏸️  Push cancelled. Run 'git push origin master' when ready." -ForegroundColor Yellow
    }
}
else {
    Write-Host "❌ Commit cancelled." -ForegroundColor Red
}

