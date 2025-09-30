# Mayfair Hotel Management System - Vercel Deployment Setup Script (PowerShell)
# This script helps you set up GitHub Actions deployment to Vercel

# Colors for output
function Write-Header {
    param([string]$Message)
    Write-Host "`n========================================" -ForegroundColor Blue
    Write-Host $Message -ForegroundColor Blue
    Write-Host "========================================`n" -ForegroundColor Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "✓ $Message" -ForegroundColor Green
}

function Write-Error {
    param([string]$Message)
    Write-Host "✗ $Message" -ForegroundColor Red
}

function Write-Warning {
    param([string]$Message)
    Write-Host "⚠ $Message" -ForegroundColor Yellow
}

function Write-Info {
    param([string]$Message)
    Write-Host "ℹ $Message" -ForegroundColor Cyan
}

# Check if command exists
function Test-Command {
    param([string]$Command)
    $null -ne (Get-Command $Command -ErrorAction SilentlyContinue)
}

# Main script
Write-Header "Mayfair Hotel - Vercel Deployment Setup"

Write-Host "This script will help you set up GitHub Actions deployment to Vercel."
Write-Host "Make sure you have:"
Write-Host "  1. A Vercel account"
Write-Host "  2. A GitHub repository"
Write-Host "  3. Node.js and npm installed"
Write-Host ""
Read-Host "Press Enter to continue"

# Check prerequisites
Write-Header "Checking Prerequisites"

if (Test-Command node) {
    $nodeVersion = node --version
    Write-Success "Node.js is installed: $nodeVersion"
} else {
    Write-Error "Node.js is not installed. Please install Node.js 18 or higher."
    exit 1
}

if (Test-Command npm) {
    $npmVersion = npm --version
    Write-Success "npm is installed: $npmVersion"
} else {
    Write-Error "npm is not installed."
    exit 1
}

if (Test-Command git) {
    Write-Success "Git is installed"
} else {
    Write-Error "Git is not installed."
    exit 1
}

# Check if Vercel CLI is installed
Write-Header "Checking Vercel CLI"

if (Test-Command vercel) {
    Write-Success "Vercel CLI is already installed"
} else {
    Write-Warning "Vercel CLI is not installed"
    $installVercel = Read-Host "Do you want to install Vercel CLI globally? (y/n)"
    if ($installVercel -eq "y") {
        npm install -g vercel
        Write-Success "Vercel CLI installed"
    } else {
        Write-Error "Vercel CLI is required. Please install it manually: npm install -g vercel"
        exit 1
    }
}

# Login to Vercel
Write-Header "Vercel Login"

Write-Info "Please login to Vercel..."
vercel login

# Link project
Write-Header "Linking Vercel Project"

Write-Info "This will link your local project to a Vercel project."
Write-Info "If you don't have a project yet, Vercel will help you create one."
Write-Host ""

vercel link

# Get project details
if (Test-Path ".vercel/project.json") {
    Write-Success "Project linked successfully!"
    
    $projectJson = Get-Content ".vercel/project.json" | ConvertFrom-Json
    $orgId = $projectJson.orgId
    $projectId = $projectJson.projectId
    
    Write-Header "Your Vercel Project Details"
    Write-Host "Organization ID: " -NoNewline -ForegroundColor Green
    Write-Host $orgId
    Write-Host "Project ID: " -NoNewline -ForegroundColor Green
    Write-Host $projectId
} else {
    Write-Error "Failed to link project. Please try again."
    exit 1
}

# Get Vercel token
Write-Header "Vercel Token"

Write-Host "You need a Vercel token for GitHub Actions."
Write-Host "To create a token:"
Write-Host "  1. Go to: https://vercel.com/account/tokens"
Write-Host "  2. Click 'Create Token'"
Write-Host "  3. Give it a name (e.g., 'GitHub Actions')"
Write-Host "  4. Set an expiration date"
Write-Host "  5. Copy the token"
Write-Host ""
Read-Host "Press Enter when you have your token ready"
$vercelToken = Read-Host "Paste your Vercel token" -AsSecureString
$vercelTokenPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($vercelToken)
)

if ([string]::IsNullOrWhiteSpace($vercelTokenPlain)) {
    Write-Error "Token cannot be empty"
    exit 1
}

Write-Success "Token received"

# GitHub Secrets Setup
Write-Header "GitHub Secrets Setup"

Write-Host "You need to add the following secrets to your GitHub repository:"
Write-Host ""
Write-Host "Go to: https://github.com/YOUR_USERNAME/YOUR_REPO/settings/secrets/actions"
Write-Host ""
Write-Host "Add these secrets:"
Write-Host ""
Write-Host "Secret Name: " -NoNewline -ForegroundColor Yellow
Write-Host "VERCEL_TOKEN"
Write-Host "Value: " -NoNewline -ForegroundColor Yellow
Write-Host $vercelTokenPlain
Write-Host ""
Write-Host "Secret Name: " -NoNewline -ForegroundColor Yellow
Write-Host "VERCEL_ORG_ID"
Write-Host "Value: " -NoNewline -ForegroundColor Yellow
Write-Host $orgId
Write-Host ""
Write-Host "Secret Name: " -NoNewline -ForegroundColor Yellow
Write-Host "VERCEL_PROJECT_ID"
Write-Host "Value: " -NoNewline -ForegroundColor Yellow
Write-Host $projectId
Write-Host ""

# Save to file for reference
$secretsContent = @"
# Vercel Deployment Secrets
# Add these to GitHub Secrets: Settings → Secrets and variables → Actions

VERCEL_TOKEN=$vercelTokenPlain
VERCEL_ORG_ID=$orgId
VERCEL_PROJECT_ID=$projectId

# Optional secrets (if needed):
# REACT_APP_API_URL=https://your-api-url.com
# REACT_APP_SOCKET_URL=https://your-socket-url.com

# ⚠️ IMPORTANT: Keep this file secure and do NOT commit it to Git!
# This file is already in .gitignore
"@

Set-Content -Path ".vercel-secrets.txt" -Value $secretsContent

Write-Success "Secrets saved to .vercel-secrets.txt (for your reference only)"
Write-Warning "Keep this file secure and do NOT commit it to Git!"

# Update .gitignore
Write-Header "Updating .gitignore"

if (Test-Path ".gitignore") {
    $gitignoreContent = Get-Content ".gitignore" -Raw
    if ($gitignoreContent -notmatch "\.vercel") {
        Add-Content -Path ".gitignore" -Value "`n# Vercel`n.vercel`n.vercel-secrets.txt"
        Write-Success ".gitignore updated"
    } else {
        Write-Info ".gitignore already contains .vercel"
    }
} else {
    $gitignoreContent = @"
# Vercel
.vercel
.vercel-secrets.txt

# Dependencies
node_modules/
package-lock.json

# Environment
.env
.env.local
.env.production

# Build
build/
dist/
.next/

# Logs
logs/
*.log

# OS
.DS_Store
Thumbs.db
"@
    Set-Content -Path ".gitignore" -Value $gitignoreContent
    Write-Success ".gitignore created"
}

# Verify workflow files
Write-Header "Verifying Workflow Files"

if (Test-Path ".github/workflows/deploy-vercel-simple.yml") {
    Write-Success "Simple workflow found"
} else {
    Write-Error "Simple workflow not found at .github/workflows/deploy-vercel-simple.yml"
}

if (Test-Path ".github/workflows/deploy-vercel-prebuilt.yml") {
    Write-Success "Prebuilt workflow found"
} else {
    Write-Error "Prebuilt workflow not found at .github/workflows/deploy-vercel-prebuilt.yml"
}

if (Test-Path "vercel.json") {
    Write-Success "vercel.json found"
} else {
    Write-Warning "vercel.json not found in root directory"
}

# Final instructions
Write-Header "Setup Complete!"

Write-Host "Next steps:"
Write-Host ""
Write-Host "1. " -NoNewline
Write-Host "Add GitHub Secrets:" -ForegroundColor Green
Write-Host "   - Go to your GitHub repository settings"
Write-Host "   - Add the secrets shown above"
Write-Host "   - Reference: .vercel-secrets.txt"
Write-Host ""
Write-Host "2. " -NoNewline
Write-Host "Configure Vercel Environment Variables:" -ForegroundColor Green
Write-Host "   - Go to: https://vercel.com/dashboard"
Write-Host "   - Select your project"
Write-Host "   - Go to Settings → Environment Variables"
Write-Host "   - Add required variables (DATABASE_URL, JWT_SECRET, etc.)"
Write-Host ""
Write-Host "3. " -NoNewline
Write-Host "Test Deployment:" -ForegroundColor Green
Write-Host "   - Go to GitHub Actions tab"
Write-Host "   - Run 'Deploy to Vercel (Simple)' workflow"
Write-Host "   - Select a branch and 'preview' environment"
Write-Host ""
Write-Host "4. " -NoNewline
Write-Host "Read Documentation:" -ForegroundColor Green
Write-Host "   - GITHUB_ACTIONS_DEPLOYMENT.md - Complete deployment guide"
Write-Host "   - .github/workflows/README.md - Workflow documentation"
Write-Host ""

Write-Success "Setup script completed successfully!"
Write-Info "For detailed instructions, see: GITHUB_ACTIONS_DEPLOYMENT.md"

Write-Host ""
Read-Host "Press Enter to exit"

