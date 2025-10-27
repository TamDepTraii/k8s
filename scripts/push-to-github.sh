#!/bin/bash

# Script to push project to GitHub
# Usage: ./push-to-github.sh <github-username> <repository-name>

set -e

if [ $# -lt 2 ]; then
    echo "Usage: $0 <github-username> <repository-name>"
    echo "Example: $0 TamDepTraii k8s"
    exit 1
fi

GITHUB_USERNAME=$1
REPO_NAME=$2
GITHUB_REPO="https://github.com/${GITHUB_USERNAME}/${REPO_NAME}.git"

echo "🚀 Pushing to GitHub"
echo "================================"
echo "GitHub User: $GITHUB_USERNAME"
echo "Repository: $REPO_NAME"
echo "URL: $GITHUB_REPO"
echo "================================"
echo ""

# Initialize git if needed
if [ ! -d .git ]; then
    echo "📦 Initializing git repository..."
    git init
    git config user.name "CI/CD Pipeline"
    git config user.email "cicd@example.com"
fi

# Add all files
echo "📝 Adding files..."
git add .

# Create initial commit if no commits exist
if ! git rev-parse HEAD >/dev/null 2>&1; then
    echo "📝 Creating initial commit..."
    git commit -m "Initial commit: CI/CD pipeline with GitHub Actions and ArgoCD"
else
    echo "📝 Creating new commit..."
    git commit -m "Update: CI/CD configuration" || echo "Nothing to commit"
fi

# Check if remote exists
if ! git remote get-url origin >/dev/null 2>&1; then
    echo "🔗 Adding remote origin..."
    git remote add origin "$GITHUB_REPO"
else
    echo "🔗 Updating remote origin..."
    git remote set-url origin "$GITHUB_REPO"
fi

# Push to GitHub
echo "⬆️  Pushing to GitHub..."
git branch -M main
git push -u origin main

echo ""
echo "✅ Successfully pushed to GitHub!"
echo ""
echo "📋 Next steps:"
echo "1. Setup GitHub Secrets:"
echo "   - Go to: https://github.com/${GITHUB_USERNAME}/${REPO_NAME}/settings/secrets/actions"
echo "   - Add DOCKER_USERNAME and DOCKER_PASSWORD"
echo ""
echo "2. Configure GitHub Actions"
echo "3. Setup Kubernetes cluster"
echo "4. Install ArgoCD"
echo "5. Create ArgoCD application"
echo ""
echo "📚 Documentation:"
echo "   - Main guide: README-CICD.md"
echo "   - Detailed guide: docs/CICD-GUIDE.md"
echo "   - Troubleshooting: docs/TROUBLESHOOTING.md"
echo ""
echo "🔗 Repository: $GITHUB_REPO"

