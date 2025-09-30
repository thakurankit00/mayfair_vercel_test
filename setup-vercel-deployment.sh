#!/bin/bash

# Mayfair Hotel Management System - Vercel Deployment Setup Script
# This script helps you set up GitHub Actions deployment to Vercel

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_header() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Main script
print_header "Mayfair Hotel - Vercel Deployment Setup"

echo "This script will help you set up GitHub Actions deployment to Vercel."
echo "Make sure you have:"
echo "  1. A Vercel account"
echo "  2. A GitHub repository"
echo "  3. Node.js and npm installed"
echo ""
read -p "Press Enter to continue..."

# Check prerequisites
print_header "Checking Prerequisites"

if command_exists node; then
    NODE_VERSION=$(node --version)
    print_success "Node.js is installed: $NODE_VERSION"
else
    print_error "Node.js is not installed. Please install Node.js 18 or higher."
    exit 1
fi

if command_exists npm; then
    NPM_VERSION=$(npm --version)
    print_success "npm is installed: $NPM_VERSION"
else
    print_error "npm is not installed."
    exit 1
fi

if command_exists git; then
    print_success "Git is installed"
else
    print_error "Git is not installed."
    exit 1
fi

# Check if Vercel CLI is installed
print_header "Checking Vercel CLI"

if command_exists vercel; then
    print_success "Vercel CLI is already installed"
else
    print_warning "Vercel CLI is not installed"
    read -p "Do you want to install Vercel CLI globally? (y/n): " install_vercel
    if [ "$install_vercel" = "y" ]; then
        npm install -g vercel
        print_success "Vercel CLI installed"
    else
        print_error "Vercel CLI is required. Please install it manually: npm install -g vercel"
        exit 1
    fi
fi

# Login to Vercel
print_header "Vercel Login"

print_info "Please login to Vercel..."
vercel login

# Link project
print_header "Linking Vercel Project"

print_info "This will link your local project to a Vercel project."
print_info "If you don't have a project yet, Vercel will help you create one."
echo ""

vercel link

# Get project details
if [ -f ".vercel/project.json" ]; then
    print_success "Project linked successfully!"
    
    ORG_ID=$(cat .vercel/project.json | grep -o '"orgId": "[^"]*' | cut -d'"' -f4)
    PROJECT_ID=$(cat .vercel/project.json | grep -o '"projectId": "[^"]*' | cut -d'"' -f4)
    
    print_header "Your Vercel Project Details"
    echo -e "${GREEN}Organization ID:${NC} $ORG_ID"
    echo -e "${GREEN}Project ID:${NC} $PROJECT_ID"
else
    print_error "Failed to link project. Please try again."
    exit 1
fi

# Get Vercel token
print_header "Vercel Token"

echo "You need a Vercel token for GitHub Actions."
echo "To create a token:"
echo "  1. Go to: https://vercel.com/account/tokens"
echo "  2. Click 'Create Token'"
echo "  3. Give it a name (e.g., 'GitHub Actions')"
echo "  4. Set an expiration date"
echo "  5. Copy the token"
echo ""
read -p "Press Enter when you have your token ready..."
read -sp "Paste your Vercel token: " VERCEL_TOKEN
echo ""

if [ -z "$VERCEL_TOKEN" ]; then
    print_error "Token cannot be empty"
    exit 1
fi

print_success "Token received"

# GitHub Secrets Setup
print_header "GitHub Secrets Setup"

echo "You need to add the following secrets to your GitHub repository:"
echo ""
echo "Go to: https://github.com/YOUR_USERNAME/YOUR_REPO/settings/secrets/actions"
echo ""
echo "Add these secrets:"
echo ""
echo -e "${YELLOW}Secret Name:${NC} VERCEL_TOKEN"
echo -e "${YELLOW}Value:${NC} $VERCEL_TOKEN"
echo ""
echo -e "${YELLOW}Secret Name:${NC} VERCEL_ORG_ID"
echo -e "${YELLOW}Value:${NC} $ORG_ID"
echo ""
echo -e "${YELLOW}Secret Name:${NC} VERCEL_PROJECT_ID"
echo -e "${YELLOW}Value:${NC} $PROJECT_ID"
echo ""

# Save to file for reference
cat > .vercel-secrets.txt << EOF
# Vercel Deployment Secrets
# Add these to GitHub Secrets: Settings → Secrets and variables → Actions

VERCEL_TOKEN=$VERCEL_TOKEN
VERCEL_ORG_ID=$ORG_ID
VERCEL_PROJECT_ID=$PROJECT_ID

# Optional secrets (if needed):
# REACT_APP_API_URL=https://your-api-url.com
# REACT_APP_SOCKET_URL=https://your-socket-url.com

# ⚠️ IMPORTANT: Keep this file secure and do NOT commit it to Git!
# This file is already in .gitignore
EOF

print_success "Secrets saved to .vercel-secrets.txt (for your reference only)"
print_warning "Keep this file secure and do NOT commit it to Git!"

# Update .gitignore
print_header "Updating .gitignore"

if [ -f ".gitignore" ]; then
    if ! grep -q ".vercel" .gitignore; then
        echo "" >> .gitignore
        echo "# Vercel" >> .gitignore
        echo ".vercel" >> .gitignore
        echo ".vercel-secrets.txt" >> .gitignore
        print_success ".gitignore updated"
    else
        print_info ".gitignore already contains .vercel"
    fi
else
    cat > .gitignore << EOF
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
EOF
    print_success ".gitignore created"
fi

# Verify workflow files
print_header "Verifying Workflow Files"

if [ -f ".github/workflows/deploy-vercel-simple.yml" ]; then
    print_success "Simple workflow found"
else
    print_error "Simple workflow not found at .github/workflows/deploy-vercel-simple.yml"
fi

if [ -f ".github/workflows/deploy-vercel-prebuilt.yml" ]; then
    print_success "Prebuilt workflow found"
else
    print_error "Prebuilt workflow not found at .github/workflows/deploy-vercel-prebuilt.yml"
fi

if [ -f "vercel.json" ]; then
    print_success "vercel.json found"
else
    print_warning "vercel.json not found in root directory"
fi

# Final instructions
print_header "Setup Complete!"

echo "Next steps:"
echo ""
echo "1. ${GREEN}Add GitHub Secrets:${NC}"
echo "   - Go to your GitHub repository settings"
echo "   - Add the secrets shown above"
echo "   - Reference: .vercel-secrets.txt"
echo ""
echo "2. ${GREEN}Configure Vercel Environment Variables:${NC}"
echo "   - Go to: https://vercel.com/dashboard"
echo "   - Select your project"
echo "   - Go to Settings → Environment Variables"
echo "   - Add required variables (DATABASE_URL, JWT_SECRET, etc.)"
echo ""
echo "3. ${GREEN}Test Deployment:${NC}"
echo "   - Go to GitHub Actions tab"
echo "   - Run 'Deploy to Vercel (Simple)' workflow"
echo "   - Select a branch and 'preview' environment"
echo ""
echo "4. ${GREEN}Read Documentation:${NC}"
echo "   - GITHUB_ACTIONS_DEPLOYMENT.md - Complete deployment guide"
echo "   - .github/workflows/README.md - Workflow documentation"
echo ""

print_success "Setup script completed successfully!"
print_info "For detailed instructions, see: GITHUB_ACTIONS_DEPLOYMENT.md"

echo ""
read -p "Press Enter to exit..."

