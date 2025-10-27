# 📤 Hướng Dẫn Push Code Lên GitHub

## Step 1: Tạo Repository trên GitHub

1. Vào https://github.com/new
2. Điền thông tin:
   - **Repository name**: `k8s`
   - **Description**: `Spring Boot Kubernetes CI/CD Pipeline`
   - **Public/Private**: Public (for GitHub Actions minutes)
   - ✅ Add README (optional, we already have one)
3. Click "Create repository"

---

## Step 2: Initialize & Commit Locally

### Option A: Using Git Commands (Recommended)

```bash
# Navigate to project
cd D:\ki1nam3\PTUDDN\k8s

# Initialize git
git init

# Configure git
git config user.name "Your Name"
git config user.email "your.email@gmail.com"

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: CI/CD pipeline with GitHub Actions and ArgoCD

- GitHub Actions workflows for CI/CD
- Kubernetes manifests for deployment
- ArgoCD configuration for GitOps
- Docker multi-stage build
- Comprehensive documentation"

# Verify
git status
```

### Option B: Using Provided Script

```bash
# Make script executable (if on Linux/Mac)
chmod +x scripts/push-to-github.sh

# Run script
bash scripts/push-to-github.sh TamDepTraii k8s
```

---

## Step 3: Connect to GitHub & Push

```bash
# Add remote (replace with your GitHub username and repo)
git remote add origin https://github.com/YOUR_USERNAME/k8s.git

# Verify remote
git remote -v

# Push to GitHub
git branch -M main
git push -u origin main

# For first time, you may need to authenticate:
# - Use GitHub token (recommended)
# - Or use SSH key if configured
```

### 🔐 GitHub Authentication

#### Option 1: Personal Access Token (Recommended)

```bash
# Create token:
# 1. Go to GitHub → Settings → Developer settings → Personal access tokens
# 2. Click "Generate new token"
# 3. Select scopes: repo, workflow
# 4. Copy token

# When git asks for password, paste token:
# Username: <your-github-username>
# Password: <paste-token-here>
```

#### Option 2: SSH Key

```bash
# Generate SSH key (if not done)
ssh-keygen -t ed25519 -C "your-email@example.com"

# Add to GitHub:
# 1. Copy ~/.ssh/id_ed25519.pub content
# 2. Go to GitHub → Settings → SSH and GPG keys
# 3. Click "New SSH key" and paste

# Use SSH URL
git remote set-url origin git@github.com:YOUR_USERNAME/k8s.git
git push -u origin main
```

---

## Step 4: Setup GitHub Secrets

### ⚠️ IMPORTANT: Configure Secrets BEFORE Pipeline Runs

1. Go to your repository: `https://github.com/YOUR_USERNAME/k8s`

2. Navigate to: **Settings → Secrets and variables → Actions**

3. Click "New repository secret" and add these secrets:

#### Secret 1: DOCKER_USERNAME
```
Name: DOCKER_USERNAME
Value: your_docker_hub_username
```

#### Secret 2: DOCKER_PASSWORD
```
Name: DOCKER_PASSWORD
Value: your_docker_hub_personal_access_token_or_password
```

**Get Docker Hub Token:**
- Go to https://hub.docker.com/settings/security
- Click "New Access Token"
- Copy the token

#### Optional: SLACK_WEBHOOK_URL
```
Name: SLACK_WEBHOOK_URL
Value: https://hooks.slack.com/services/YOUR/WEBHOOK/URL
```

3. Verify all secrets are added:
   - ✅ DOCKER_USERNAME
   - ✅ DOCKER_PASSWORD
   - ✅ SLACK_WEBHOOK_URL (optional)

---

## Step 5: Verify Push Success

```bash
# Check local git status
git status
# Output: On branch main, nothing to commit

# View commit history
git log --oneline -5

# List remote
git remote -v
# Output: origin  https://github.com/YOUR_USERNAME/k8s.git (fetch)
#         origin  https://github.com/YOUR_USERNAME/k8s.git (push)
```

### Check on GitHub

1. Go to https://github.com/YOUR_USERNAME/k8s
2. Verify files are there
3. Check commit history
4. Check Actions tab (workflow runs)

---

## Step 6: Configure GitHub (Optional but Recommended)

### Branch Protection Rules

1. Go to: **Settings → Branches → Add branch protection rule**
2. Branch name pattern: `main`
3. Configure:
   - ✅ Require a pull request before merging
   - ✅ Require status checks to pass
   - ✅ Require branches to be up to date

### Actions Permissions

1. Go to: **Settings → Actions → General**
2. Select: "Allow all actions and reusable workflows"

### Enable Dependabot (Optional)

1. Go to: **Settings → Code security and analysis**
2. Enable: 
   - Dependabot alerts
   - Dependabot security updates

---

## 🧪 Test the Pipeline

### Make a Small Change to Trigger Pipeline

```bash
# Make a change
echo "# Test commit" >> README.md

# Commit and push
git add .
git commit -m "test: trigger CI/CD pipeline"
git push origin main
```

### Watch Pipeline Run

1. Go to: https://github.com/YOUR_USERNAME/k8s/actions
2. Click on your latest workflow run
3. Monitor each job:
   - ✅ Build (Maven test & compile)
   - ✅ Deploy (Manifest update)
   - ✅ Security (Trivy scan)
   - ✅ Notification (Slack)

---

## 📊 Expected Pipeline Output

### Successful Build
```
✅ Build
├── Checkout code
├── Setup Java 11
├── Build with Maven
├── Run tests
└── Security scan

✅ Deploy
├── Update manifests
├── Commit & push
└── Trigger ArgoCD

✅ Security
└── Trivy scan

✅ Notification
└── Slack message (if configured)
```

### Check Artifacts

```bash
# View Docker image pushed
# Go to: https://github.com/YOUR_USERNAME/packages
# Or Docker Hub: hub.docker.com/_/YOUR_USERNAME

# View GHCR
# Go to: https://ghcr.io/YOUR_USERNAME/k8s/k8s-app
```

---

## ⚠️ Troubleshooting Push Issues

### Issue: "permission denied"

```bash
# Use HTTPS with token
git remote set-url origin https://YOUR_USERNAME:YOUR_TOKEN@github.com/YOUR_USERNAME/k8s.git

# Or use SSH
ssh -T git@github.com
# Should output: Hi YOUR_USERNAME! You've successfully authenticated
```

### Issue: "Repository not found"

```bash
# Verify remote URL
git remote -v

# Check spelling of username and repo name
git remote set-url origin https://github.com/CORRECT_USERNAME/k8s.git
```

### Issue: "Changes not appearing on GitHub"

```bash
# Ensure you're on main branch
git branch
# Output: * main

# Force push (if needed, be careful!)
git push -f origin main
```

---

## ✅ Complete Checklist

- [ ] Create GitHub repository
- [ ] Clone or navigate to local project
- [ ] Initialize git (`git init`)
- [ ] Configure git (`git config`)
- [ ] Add all files (`git add .`)
- [ ] Create commit (`git commit`)
- [ ] Add remote (`git remote add origin`)
- [ ] Push to GitHub (`git push -u origin main`)
- [ ] Verify files on GitHub
- [ ] Configure GitHub secrets (DOCKER_USERNAME, DOCKER_PASSWORD)
- [ ] Trigger pipeline test
- [ ] Monitor pipeline execution
- [ ] Verify deployment to Kubernetes
- [ ] Check ArgoCD sync

---

## 🎯 Next Steps After Push

1. **Setup Kubernetes**
   ```bash
   make deploy
   ```

2. **Setup ArgoCD**
   ```bash
   bash scripts/setup-argocd.sh
   kubectl apply -f argocd/application.yaml
   ```

3. **Monitor Pipeline**
   - GitHub Actions: https://github.com/YOUR_USERNAME/k8s/actions
   - ArgoCD: https://localhost:8443

4. **View Application**
   ```bash
   make port-forward
   # Visit: http://localhost:8080
   ```

---

## 📝 Useful Git Commands

```bash
# View branches
git branch -a

# Create new branch
git checkout -b feature/new-feature

# Switch branch
git checkout main

# View commit history
git log --oneline

# View changes
git diff

# Undo last commit (keep changes)
git reset --soft HEAD~1

# Undo last commit (discard changes)
git reset --hard HEAD~1

# Sync with remote
git pull origin main

# Stash changes
git stash
git stash pop

# Rebase
git rebase origin/main
```

---

## 🎉 Success!

Once you've pushed, your CI/CD pipeline is live! 🚀

Every future push will:
1. Build and test your application
2. Scan for vulnerabilities
3. Build Docker image
4. Push to registries
5. Update Kubernetes manifests
6. ArgoCD deploys automatically

---

## 📞 Need Help?

- Check GitHub Actions logs
- Review workflow files in `.github/workflows/`
- See docs/TROUBLESHOOTING.md
- Check docs/COMMANDS.md

**You're all set! Happy CI/CD! 🎉**

