# 📚 Mục Lục Tài Liệu - Documentation Index

## 🚀 Bắt Đầu Ngay (START HERE!)

### 📖 Đọc Những Tài Liệu Này Theo Thứ Tự:

1. **[00_START_HERE.md](00_START_HERE.md)** ⭐ **BẮT ĐẦU ĐÂY**
   - Tổng quan nhanh (5 phút)
   - Kiểm tra yêu cầu
   - 4 bước chính

2. **[FINAL_ACTION_STEPS.md](FINAL_ACTION_STEPS.md)** 🎬 **HÀNH ĐỘNG NGAY**
   - Chi tiết từng bước
   - Lệnh cần chạy
   - Kết quả mong đợi

3. **[SETUP_SUMMARY.md](SETUP_SUMMARY.md)** 📋 **TÓM TẮT**
   - Điều vừa hoàn thành
   - File structure
   - Quick help

---

## 📖 Tài Liệu Chi Tiết

### ArgoCD Hướng Dẫn

| Tài Liệu | Nội Dung | Thời Gian |
|---------|---------|----------|
| [ARGOCD_LOGIN_SOLUTION.md](ARGOCD_LOGIN_SOLUTION.md) | ✅ Đăng nhập ArgoCD + Lỗi | 10 min |
| [ARGOCD_LOGIN_GUIDE.md](ARGOCD_LOGIN_GUIDE.md) | Hướng dẫn đăng nhập chi tiết | 5 min |
| [DOCKER_ARGOCD_DASHBOARD.md](DOCKER_ARGOCD_DASHBOARD.md) | Docker + ArgoCD trên Desktop | 10 min |

### Setup & Cài Đặt

| Tài Liệu | Nội Dung | Thời Gian |
|---------|---------|----------|
| [README_SETUP.md](README_SETUP.md) | 📖 Hướng dẫn setup đầy đủ | 30 min |
| [BUILD_INSTRUCTIONS.md](BUILD_INSTRUCTIONS.md) | Build Docker image | 5 min |
| [README.md](README.md) | README chính của project | 10 min |

### Git & GitHub

| Tài Liệu | Nội Dung | Thời Gian |
|---------|---------|----------|
| [GITHUB_PUSH_GUIDE.md](GITHUB_PUSH_GUIDE.md) | 📤 Push lên GitHub | 15 min |
| [GITHUB_PUSH_GUIDE.md](GITHUB_PUSH_GUIDE.md) | Troubleshooting Git | 10 min |

### Troubleshooting

| Tài Liệu | Nội Dung | Thời Gian |
|---------|---------|----------|
| [TROUBLESHOOTING_DETAILED.md](TROUBLESHOOTING_DETAILED.md) | Lỗi chi tiết | 20 min |
| [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) | Vấn đề thường gặp | 10 min |

### CI/CD Pipeline

| Tài Liệu | Nội Dung | Thời Gian |
|---------|---------|----------|
| [README-CICD.md](README-CICD.md) | CI/CD configuration | 20 min |
| [docs/CICD-GUIDE.md](docs/CICD-GUIDE.md) | GitHub Actions setup | 15 min |

### Kubernetes

| Tài Liệu | Nội Dung | Thời Gian |
|---------|---------|----------|
| [K8S_GUIDE.md](K8S_GUIDE.md) | Kubernetes guide | 20 min |
| [PHASE3_KUBERNETES.md](PHASE3_KUBERNETES.md) | Advanced K8s setup | 30 min |
| [docs/PROJECT-STRUCTURE.md](docs/PROJECT-STRUCTURE.md) | Project structure | 10 min |

---

## 🎯 Tìm Kiếm Nhanh

### Nếu bạn muốn...

**📝 Bắt đầu từ đầu**
→ [00_START_HERE.md](00_START_HERE.md)

**🔐 Đăng nhập ArgoCD**
→ [ARGOCD_LOGIN_SOLUTION.md](ARGOCD_LOGIN_SOLUTION.md)

**📤 Push lên GitHub**
→ [GITHUB_PUSH_GUIDE.md](GITHUB_PUSH_GUIDE.md)

**🐳 Build Docker image**
→ [BUILD_INSTRUCTIONS.md](BUILD_INSTRUCTIONS.md)

**⚙️ Setup Kubernetes**
→ [K8S_GUIDE.md](K8S_GUIDE.md)

**❌ Fix lỗi**
→ [TROUBLESHOOTING_DETAILED.md](TROUBLESHOOTING_DETAILED.md)

**🚀 Setup CI/CD**
→ [README-CICD.md](README-CICD.md)

**📊 Xem metrics**
→ Prometheus: `http://localhost:9090`

**⚡ Kiểm tra health**
→ `http://localhost:8080/actuator/health`

---

## 🔧 Scripts & Tools

| Script | Tác Vụ | Chạy Bằng |
|--------|--------|----------|
| `setup-check.ps1` | Kiểm tra setup (Windows) | `powershell -ExecutionPolicy Bypass -File .\setup-check.ps1` |
| `setup-check.sh` | Kiểm tra setup (Linux/Mac) | `bash setup-check.sh` |
| `push-to-github.bat` | Push lên GitHub (Windows) | `.\push-to-github.bat` |
| `build-image.bat` | Build Docker image | `.\build-image.bat` |
| `deploy-k8s.bat` | Deploy lên Kubernetes | `.\deploy-k8s.bat` |
| `cleanup-k8s.bat` | Cleanup resources | `.\cleanup-k8s.bat` |

---

## 📊 Kubernetes Files

| File | Tác Vụ |
|------|--------|
| `k8s/namespace.yaml` | Tạo namespace |
| `k8s/deployment.yaml` | Deploy app |
| `k8s/service.yaml` | Expose service |
| `k8s/configmap.yaml` | Configuration |
| `k8s/hpa.yaml` | Auto-scaling |
| `k8s/prometheus-config.yaml` | Monitoring |
| `k8s/servicemonitor.yaml` | Prometheus metrics |

---

## 🔗 Các Links Quan Trọng

| Link | Mục Đích |
|------|---------|
| https://localhost:8080 | ArgoCD UI |
| https://github.com/TamDepTraii/k8s.git | GitHub Repository |
| http://localhost:8080/actuator/health | Health Check |
| http://localhost:8080/actuator/metrics | Metrics |
| http://localhost:9090 | Prometheus |

---

## 🔐 Credentials

```
=== ArgoCD ===
Username: admin
Password: Tmpr4695958
URL: https://localhost:8080

=== GitHub ===
Repository: https://github.com/TamDepTraii/k8s.git
Branch: main

=== Docker ===
Image: k8s-demo:latest
Registry: local (Docker Desktop)
```

---

## 📱 Quick Commands

```powershell
# === ArgoCD ===
kubectl -n argocd port-forward svc/argocd-server 8080:443
kubectl -n argocd get pods
kubectl -n argocd logs deployment/argocd-server

# === Kubernetes ===
kubectl get pods
kubectl get svc
kubectl logs -f <pod>
kubectl describe pod <pod>
kubectl port-forward svc/<svc> 8080:8080

# === Docker ===
docker images
docker ps
docker logs <container>
docker build -t <image> .

# === Git ===
git status
git add -A
git commit -m "message"
git push origin main
```

---

## 🎓 Learning Path

### Beginner (1-2 hours)
1. [00_START_HERE.md](00_START_HERE.md)
2. [ARGOCD_LOGIN_SOLUTION.md](ARGOCD_LOGIN_SOLUTION.md)
3. [GITHUB_PUSH_GUIDE.md](GITHUB_PUSH_GUIDE.md)

### Intermediate (2-4 hours)
1. [README_SETUP.md](README_SETUP.md)
2. [K8S_GUIDE.md](K8S_GUIDE.md)
3. [README-CICD.md](README-CICD.md)

### Advanced (4+ hours)
1. [PHASE3_KUBERNETES.md](PHASE3_KUBERNETES.md)
2. [docs/CICD-GUIDE.md](docs/CICD-GUIDE.md)
3. [TROUBLESHOOTING_DETAILED.md](TROUBLESHOOTING_DETAILED.md)

---

## 📝 Version History

| Phiên Bản | Ngày | Nội Dung |
|-----------|------|---------|
| 1.0 | 2025-10-27 | Initial setup |
| 1.1 | 2025-10-27 | ArgoCD configuration |
| 1.2 | 2025-10-27 | Documentation complete |

---

## 🤝 Support

Nếu gặp vấn đề:

1. **Kiểm tra logs**
   ```powershell
   kubectl logs <pod>
   kubectl describe pod <pod>
   ```

2. **Xem Troubleshooting**
   → [TROUBLESHOOTING_DETAILED.md](TROUBLESHOOTING_DETAILED.md)

3. **Check prerequisites**
   ```powershell
   .\setup-check.ps1
   ```

---

## 📚 External Resources

- [Spring on Kubernetes](https://spring.io/guides/topicals/spring-on-kubernetes)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)
- [Docker Documentation](https://docs.docker.com/)

---

**Last Updated: 2025-10-27**

**Happy Deploying! 🚀**

