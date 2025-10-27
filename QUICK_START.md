# ⚡ Quick Start Guide

Hướng dẫn nhanh để bắt đầu với CI/CD Pipeline

## 5 Bước Đơn Giản

### ✅ Bước 1: Clone & Setup Locally (2 phút)

```bash
# Clone repository
git clone https://github.com/TamDepTraii/k8s.git
cd k8s

# Build locally
make build                    # Build Java app
make docker-build            # Build Docker image
make docker-run              # Run container locally
```

Kiểm tra: http://localhost:8080/actuator/health

### ✅ Bước 2: Setup GitHub Secrets (3 phút)

1. Vào **GitHub Repository → Settings → Secrets and variables → Actions**

2. Thêm 2 secrets:
   ```
   DOCKER_USERNAME = your_docker_hub_username
   DOCKER_PASSWORD = your_docker_hub_password_or_token
   ```

3. Save ✓

### ✅ Bước 3: Setup Kubernetes (5 phút)

```bash
# Ensure Kubernetes is running (Docker Desktop or Minikube)
kubectl cluster-info

# Create namespace
kubectl apply -f k8s/namespace.yaml

# Deploy to K8s
make deploy

# Verify
kubectl get all -n k8s-demo
```

### ✅ Bước 4: Setup ArgoCD (5 phút)

```bash
# Automated setup
bash scripts/setup-argocd.sh

# Or manual
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Get admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# Access ArgoCD
kubectl port-forward svc/argocd-server -n argocd 8443:443
# Visit: https://localhost:8443
```

### ✅ Bước 5: Deploy with ArgoCD (2 phút)

```bash
# Apply ArgoCD application
kubectl apply -f argocd/application.yaml

# Verify
kubectl get applications -n argocd

# Watch sync
kubectl describe application k8s-demo -n argocd
```

---

## 🎉 Done! Pipeline Hoạt Động!

```bash
# Try the pipeline:
make port-forward
# Visit: http://localhost:8080/actuator/health

# Make a change and push:
echo "# Updated" >> README.md
git add .
git commit -m "test: trigger pipeline"
git push origin main

# Watch pipeline:
# 1. GitHub Actions: Repository → Actions
# 2. ArgoCD: https://localhost:8443
# 3. Kubernetes: kubectl logs -f deployment/k8s-demo -n k8s-demo
```

---

## 📊 System Status

```bash
# Check everything is working
make status

# Or individual checks
kubectl get pods -n k8s-demo
kubectl logs deployment/k8s-demo -n k8s-demo
argocd app get k8s-demo
```

---

## 🆘 Troubleshooting Quick Fixes

### Pipeline not running?
```bash
# Check GitHub Actions secrets
# Go to Settings → Secrets and verify DOCKER_USERNAME & DOCKER_PASSWORD
```

### Pod not starting?
```bash
# Check pod status
kubectl describe pod <pod-name> -n k8s-demo

# View logs
kubectl logs <pod-name> -n k8s-demo
```

### ArgoCD not syncing?
```bash
# Check application status
kubectl describe application k8s-demo -n argocd

# Force sync
argocd app sync k8s-demo
```

---

## 📚 Next Steps

- **Detailed Guide**: Read `README-CICD.md`
- **All Commands**: See `docs/COMMANDS.md`
- **Issues**: Check `docs/TROUBLESHOOTING.md`
- **Architecture**: Review `docs/CICD-GUIDE.md`

---

## 🎯 Common Tasks

### Deploy New Version
```bash
# Make code changes
git add .
git commit -m "feat: new feature"
git push origin main
# Pipeline handles rest automatically!
```

### Scale Pods
```bash
make scale REPLICAS=5
```

### View Logs
```bash
make logs                    # All pods
make logs POD_NAME=<name>   # Specific pod
```

### Rollback Version
```bash
kubectl rollout undo deployment/k8s-demo -n k8s-demo
```

### Stop Everything
```bash
make clean-all
```

---

## 💡 Tips

- Use `make help` to see all available commands
- Check `.github/workflows/cicd-pipeline.yml` for pipeline details
- View logs in real-time with `-f` flag: `kubectl logs -f deployment/k8s-demo -n k8s-demo`
- Use `kubectl describe` for detailed resource information

---

**Time to Complete**: ~15 minutes
**Everything Working**: ✅

Enjoy your CI/CD Pipeline! 🚀

