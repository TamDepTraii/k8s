**Giải pháp**:
```powershell
# Pull latest changes
git pull origin main

# Resolve conflicts nếu có

# Push lại
git push origin main
```

---

## 📋 Danh Sách Files Cần Push

Tất cả files sau sẽ được push:

```
✓ src/
  └── main/java/com/example/k8s/      # Source code
  └── resources/                        # Configuration
✓ k8s/
  ├── namespace.yaml
  ├── deployment.yaml
  ├── service.yaml
  ├── configmap.yaml
  ├── hpa.yaml
  └── kustomization.yaml
✓ argocd/
  ├── application.yaml
  └── argocd-config.yaml
✓ docs/
  ├── SETUP.md
  ├── TROUBLESHOOTING.md
  └── CI-CD.md
✓ Dockerfile
✓ docker-compose.yml
✓ pom.xml
✓ README.md
✓ .gitignore
✓ Makefile
```

---

## ✅ Kiểm Tra Sau Push

### 1. Xác Nhận Trên GitHub

```powershell
# Mở GitHub trong trình duyệt
start "https://github.com/TamDepTraii/k8s"

# Kiểm tra:
# - Branch main có mới nhất không?
# - Tất cả files đã up chưa?
# - Commit history có đúng không?
```

### 2. Verify Files

```powershell
# Clone lại để kiểm tra
git clone https://github.com/TamDepTraii/k8s.git k8s-verify
cd k8s-verify

# Kiểm tra files
dir

# Kiểm tra logs
git log --oneline -10
```

### 3. Xem Repository Stats

Trên GitHub:
- Click "Code" để xem files
- Click "Commits" để xem history
- Click "Releases" nếu có tag

---

## 🎓 Lệnh Git Hữu Ích

```powershell
# Kiểm tra status
git status

# Xem thay đổi
git diff

# Xem history
git log

# Xem remote
git remote -v

# Thay đổi branch
git checkout -b <branch-name>
git switch main

# Merge branches
git merge <branch-name>

# Revert commit
git revert <commit-hash>

# Reset (cẩn thận!)
git reset --hard <commit-hash>
```

---

## 💡 Best Practices

1. **Commit thường xuyên** - Không push một lúc quá nhiều changes
2. **Viết commit messages tốt** - Rõ ràng, mô tả chính xác
3. **Pull trước push** - Luôn `git pull` trước `git push`
4. **Dùng branches** - Không dev trực tiếp trên main
5. **Sử dụng .gitignore** - Không commit files không cần thiết

### .gitignore Recommended

```
# IDE
.idea/
.vscode/
*.swp
*.swo

# Build
target/
build/
*.class
*.jar

# Logs
logs/
*.log

# OS
.DS_Store
Thumbs.db

# Environment
.env
.env.local
secrets/
```

---

## 🔐 Bảo Mật

**⚠️ KHÔNG push:**
- API keys
- Database passwords
- Personal tokens
- SSH keys
- .env files (chỉ .env.example)

**Nếu nhầm push sensitive data:**
```powershell
# Xóa từ history
git filter-branch --tree-filter 'rm -f <file>' HEAD

# Reset GitHub token (nếu bị leak)
# GitHub Settings → Developer settings → Personal access tokens → Delete
```

---

## 📱 Xem Trên GitHub

Sau khi push thành công, bạn có thể:

1. **Xem code** - https://github.com/TamDepTraii/k8s
2. **Download ZIP** - Click "Code" → "Download ZIP"
3. **Clone** - `git clone https://github.com/TamDepTraii/k8s.git`
4. **Tạo Pull Requests** - Nếu có collaborators
5. **Issues** - Báo cáo bugs
6. **Discussions** - Thảo luận features

---

## 🚀 Bước Tiếp Theo

Sau khi push thành công:

1. ✅ Setup CI/CD Pipeline (GitHub Actions)
2. ✅ Auto-deploy từ Git qua ArgoCD
3. ✅ Setup branch protection rules
4. ✅ Configure webhooks
5. ✅ Add documentation badges

---

**Happy Git! 🚀**

Last Updated: 2025-10-27
# 📤 Hướng Dẫn Push Project Lên GitHub

## 🎯 Mục Tiêu

Push toàn bộ project Spring Boot + Kubernetes + ArgoCD lên GitHub repository.

**Repository URL**: https://github.com/TamDepTraii/k8s.git

---

## 🚀 Các Bước Push

### Bước 1: Kiểm Tra Git Status

Mở PowerShell tại thư mục project:

```powershell
cd D:\ki1nam3\PTUDDN\k8s
git status
```

**Kết quả mong đợi:**
```
On branch main
Your branch is up to date with 'origin/main'.

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        README_SETUP.md
        ARGOCD_LOGIN_SOLUTION.md
        ...
```

### Bước 2: Thêm Tất Cả Files

```powershell
git add -A
```

**Kiểm tra:**
```powershell
git status
# Sẽ thấy "Changes to be committed"
```

### Bước 3: Commit với Message

```powershell
git commit -m "Add: CI/CD setup with Kubernetes and ArgoCD"
```

**Hoặc chi tiết hơn:**

```powershell
git commit -m "Add: Complete K8s and ArgoCD setup

- Added Kubernetes manifest files
- Configured ArgoCD deployment
- Added monitoring configuration
- Added login guides
- Documented setup instructions"
```

### Bước 4: Push lên GitHub

```powershell
git push origin main
```

**Kết quả thành công:**
```
Enumerating objects: 42, done.
Counting objects: 100% (42/42), done.
Delta compression using up to 8 threads
Compressing objects: 100% (35/35), done.
Writing objects: 100% (40/40), 125.45 KiB | 1.20 MiB/s
remote: Resolving deltas: 100% (15/15), done.
To https://github.com/TamDepTraii/k8s.git
   abc123d..def456g main -> main
```

---

## 🐛 Nếu Gặp Lỗi

### ❌ Lỗi: "fatal: not a git repository"

**Nguyên nhân**: Thư mục chưa là git repository

**Giải pháp**:
```powershell
# Clone repository
git clone https://github.com/TamDepTraii/k8s.git
cd k8s

# Hoặc khởi tạo git mới
git init
git remote add origin https://github.com/TamDepTraii/k8s.git
```

### ❌ Lỗi: "fatal: 'origin' does not appear to be a 'git' repository"

**Nguyên nhân**: Remote chưa được cấu hình

**Giải pháp**:
```powershell
git remote -v  # Kiểm tra remote hiện tại

# Nếu không có, thêm remote
git remote add origin https://github.com/TamDepTraii/k8s.git

# Hoặc sửa remote cũ
git remote set-url origin https://github.com/TamDepTraii/k8s.git
```

### ❌ Lỗi: "Authentication failed"

**Nguyên nhân**: GitHub credentials không đúng

**Giải pháp**:

#### Dùng Personal Access Token (PAT)

1. Tạo token trên GitHub:
   - GitHub Settings → Developer settings → Personal access tokens
   - Click "Generate new token"
   - Chọn scopes: `repo`, `workflow`
   - Copy token

2. Dùng token:
```powershell
git push https://<token>@github.com/TamDepTraii/k8s.git main
```

#### Hoặc Lưu Credentials

```powershell
# Windows: Dùng Git Credential Manager
git config --global credential.helper manager-core

# Sau đó push - sẽ hỏi username/password
git push
```

#### Hoặc SSH

```powershell
# Tạo SSH key
ssh-keygen -t rsa -b 4096 -f $env:USERPROFILE\.ssh\github_key

# Thêm public key vào GitHub Settings → SSH Keys

# Sử dụng SSH URL
git remote set-url origin git@github.com:TamDepTraii/k8s.git
git push origin main
```

### ❌ Lỗi: "Your branch is ahead of 'origin/main'"

**Nguyên nhân**: Có commits cục bộ chưa push

**Giải pháp**:
```powershell
git push origin main
```

### ❌ Lỗi: "Merge conflict"

**Nguyên nhân**: Repository có thay đổi từ remote


