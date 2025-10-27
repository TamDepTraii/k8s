# 🚀 Hướng Dẫn Khởi Động Lại Dự Án K8s

## 📋 Tình Trạng Hiện Tại

✅ Kubernetes cluster: **RUNNING**
✅ ArgoCD: **RUNNING**
✅ Tất cả pods healthy

---

## 🔧 Các Bước Khởi Động

### Bước 1: Kiểm Tra Trạng Thái Hệ Thống

```bash
# Kiểm tra Kubernetes
kubectl cluster-info

# Kiểm tra ArgoCD
kubectl -n argocd get pods

# Kiểm tra Docker images
docker images | grep k8s
```

### Bước 2: Build Docker Image (Nếu Cần)

```bash
cd D:\ki1nam3\PTUDDN\k8s
.\mvnw.cmd clean install
.\mvnw.cmd spring-boot:build-image -Dspring-boot.build-image.imageName=k8s-demo:latest
```

### Bước 3: Chạy Application

#### Option A: Chạy trong Docker (Nhanh)
```bash
docker run -p 8080:8080 --name k8s-demo k8s-demo:latest
```

#### Option B: Chạy trong Kubernetes (Với ArgoCD)
```bash
# Deploy vào Kubernetes
kubectl apply -f k8s/

# Kiểm tra deployment
kubectl get deployments
kubectl get services
```

#### Option C: Chạy trực tiếp Spring Boot (Dev)
```bash
.\mvnw.cmd spring-boot:run
```

### Bước 4: Truy Cập ArgoCD Dashboard

```bash
# Port-forward ArgoCD
kubectl -n argocd port-forward svc/argocd-server 8080:443

# Truy cập browser
https://localhost:8080

# Đăng nhập
Username: admin
Password: Tmpr4695958
```

### Bước 5: Commit và Push Code

```bash
# Commit tất cả thay đổi
git add .
git commit -m "feat: restart project with K8s setup"

# Push lên GitHub
git push origin main
```

---

## ✅ Checklist Khởi Động

- [ ] Kubernetes running (`kubectl cluster-info`)
- [ ] Docker Desktop enabled
- [ ] ArgoCD pods healthy (`kubectl -n argocd get pods`)
- [ ] Docker image built (`docker images | grep k8s`)
- [ ] Application deployed or running
- [ ] Code committed and pushed to GitHub
- [ ] Can access ArgoCD dashboard (https://localhost:8080)

---

## 🔗 Useful Commands

| Lệnh | Mục Đích |
|------|----------|
| `kubectl cluster-info` | Kiểm tra K8s cluster |
| `kubectl get pods` | Xem tất cả pods |
| `kubectl -n argocd get pods` | Xem ArgoCD pods |
| `docker ps` | Xem running containers |
| `docker images` | Xem Docker images |
| `kubectl port-forward svc/argocd-server 8080:443` | Truy cập ArgoCD |
| `kubectl logs -f deployment/argocd-server -n argocd` | Xem ArgoCD logs |

---

## 🐛 Troubleshooting

### Lỗi: Kubernetes not running
**Giải pháp:** Mở Docker Desktop → Settings → Kubernetes → Enable Kubernetes

### Lỗi: Port 8080 đã được sử dụng
**Giải pháp:** Dùng port khác: `kubectl -n argocd port-forward svc/argocd-server 9090:443`

### Lỗi: ArgoCD pod not ready
**Giải pháp:** Restart ArgoCD: `kubectl -n argocd rollout restart deployment/argocd-server`

---

## 📞 Next Steps

1. Xem [COMPLETE_TROUBLESHOOTING.md](./COMPLETE_TROUBLESHOOTING.md) nếu gặp lỗi
2. Xem [README.md](./README.md) để hiểu project structure
3. Deploy application theo bước 3 trên
4. Truy cập ArgoCD để monitor

---

**Last Updated:** 2025-10-27
**Status:** ✅ Ready to Run

