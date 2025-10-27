2. ✅ Spring Boot App - **RUNNING**
3. ✅ ArgoCD - **INSTALLED**
4. 🔲 Deploy to Kubernetes via ArgoCD
5. 🔲 Setup GitHub Actions CI
6. 🔲 Configure Auto-sync in ArgoCD
7. 🔲 Setup Monitoring & Alerts

---

**Happy Deploying! 🚀**
# 🎯 Hướng dẫn Xem Docker Image & ArgoCD

## ✅ Tình trạng hiện tại

### 1. **Docker Image Đã Được Build**
```
✅ Repository: k8s-demo
✅ Tag: latest
✅ Size: 496MB
✅ Image ID: 33f9685a1674
✅ Status: Ready
```

### 2. **Spring Boot Application Đang Chạy**
```
✅ URL: http://localhost:9090
✅ Endpoint: /helloWorld
✅ Port: 9090
✅ Status: Running
```

### 3. **ArgoCD Đã Được Cài Đặt**
```
✅ Namespace: argocd
✅ Port-forward: 8443 -> 443
✅ URL: https://localhost:8443
✅ Status: Ready
```

---

## 🚀 Cách Xem Docker Image

### **Cách 1: Từ Command Line**
```bash
# Liệt kê tất cả images
docker images

# Tìm image k8s-demo
docker images | grep k8s-demo

# Xem chi tiết image
docker inspect k8s-demo:latest

# Xem image layers
docker history k8s-demo:latest
```

**Output:**
```
REPOSITORY   TAG       IMAGE ID       CREATED        SIZE
k8s-demo     latest    33f9685a1674   45 years ago    496MB
```

### **Cách 2: Từ Docker Desktop**
1. Mở **Docker Desktop**
2. Chọn tab **Images**
3. Tìm kiếm `k8s-demo`
4. Xem chi tiết image

### **Cách 3: Từ ArgoCD UI**
1. Truy cập: **https://localhost:8443**
2. Đăng nhập: `admin` / `<password>`
3. Vào **Applications**
4. Chọn `k8s-demo-app`
5. Xem **Application Resources** → **Deployment** → **Pod** → **Container Image**

---

## 🎯 Cách Truy Cập ArgoCD

### **Step 1: Mở Browser**
```
https://localhost:8443
```
> ⚠️ Note: Bỏ qua SSL warning nếu có (self-signed certificate)

### **Step 2: Đăng Nhập**
**Username:** `admin`

**Password:** Lấy bằng lệnh sau:
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

Hoặc nếu dùng PowerShell:
```powershell
$pass = kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}"
[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($pass))
```

### **Step 3: Xem Dashboard**
- **Applications**: Danh sách ứng dụng được quản lý
- **Repositories**: Kết nối Git
- **Projects**: Tổ chức projects
- **Settings**: Cấu hình hệ thống

---

## 📊 Xem Docker Image trong ArgoCD

### **Phương pháp: Via Application Details**

1. **Vào Applications**
   ```
   ArgoCD Dashboard → Applications
   ```

2. **Chọn Application**
   ```
   Click vào: k8s-demo-app
   ```

3. **Xem Resources**
   ```
   Application Resources panel
   → Deployment
   → Pod
   → Containers
   → Image: k8s-demo:latest
   ```

4. **Chi tiết**
   - Repository: docker.io/library/k8s-demo
   - Tag: latest
   - Pull Policy: IfNotPresent

---

## 🔄 Workflow CI/CD

```
Git Repository
    ↓
GitHub (Commit)
    ↓
ArgoCD (Poll Repository)
    ↓
Sync & Deploy
    ↓
Kubernetes Cluster
    ↓
Running Pod with k8s-demo:latest image
```

---

## 📋 Useful Commands

### **Docker Commands**
```bash
# Xem image
docker images k8s-demo

# Xem chi tiết
docker inspect k8s-demo:latest | grep -A 20 "Config"

# Xem layers
docker history k8s-demo:latest

# Push to Docker Hub (nếu cần)
docker tag k8s-demo:latest <username>/k8s-demo:latest
docker push <username>/k8s-demo:latest
```

### **Kubernetes Commands**
```bash
# Xem deployments
kubectl get deployments -A

# Xem pods
kubectl get pods -A

# Xem services
kubectl get svc -A

# Xem events
kubectl get events -A

# Describe pod
kubectl describe pod <pod-name> -n k8s-demo
```

### **ArgoCD Commands**
```bash
# Xem ArgoCD apps
kubectl get applications -n argocd

# Xem ArgoCD server
kubectl get svc -n argocd

# Xem ArgoCD logs
kubectl logs -n argocd deployment/argocd-server

# Get ArgoCD CLI
curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
chmod +x /usr/local/bin/argocd
```

---

## 🔐 Bảo Mật

### **1. Thay đổi Password Admin**
```bash
# Đăng nhập vào ArgoCD server pod
kubectl exec -it -n argocd deployment/argocd-server -- argocd account update-password --account admin --new-password <new-password>
```

### **2. Tạo RBAC Policy**
```bash
# Cập nhật ConfigMap
kubectl edit configmap argocd-rbac-cm -n argocd
```

### **3. Enable SSO**
- Tham khảo: https://argo-cd.readthedocs.io/en/stable/operator-manual/user-management/

---

## 🛠️ Troubleshooting

### **Problem 1: ArgoCD không truy cập được**
```bash
# Kiểm tra pods
kubectl get pods -n argocd

# Kiểm tra services
kubectl get svc -n argocd

# Khởi động lại port-forward
kubectl port-forward svc/argocd-server -n argocd 8443:443
```

### **Problem 2: Không thấy Docker image**
```bash
# Kiểm tra docker images
docker images | grep k8s-demo

# Build lại image nếu cần
cd D:\ki1nam3\PTUDDN\k8s
mvn clean spring-boot:build-image -Dspring-boot.build-image.imageName=k8s-demo:latest
```

### **Problem 3: Pod không start**
```bash
# Xem logs
kubectl logs -n k8s-demo deployment/<deployment-name>

# Describe pod
kubectl describe pod <pod-name> -n k8s-demo

# Xem events
kubectl describe node
```

---

## 📚 Tài liệu tham khảo

- [Docker Official Docs](https://docs.docker.com/)
- [Kubernetes Official Docs](https://kubernetes.io/docs/)
- [ArgoCD Official Docs](https://argo-cd.readthedocs.io/)
- [Spring Boot on Kubernetes](https://spring.io/guides/topicals/spring-on-kubernetes)
- [Cloud Native Buildpacks](https://buildpacks.io/)

---

## ✨ Next Steps

1. ✅ Docker Image: `k8s-demo:latest` - **DONE**

