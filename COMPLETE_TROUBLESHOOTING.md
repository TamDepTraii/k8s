kubectl -n argocd port-forward svc/argocd-server 8383:443# 🔧 TROUBLESHOOTING - Tất Cả Lỗi Có Thể Gặp

## ❌ Lỗi: Không thể truy cập localhost:8080

### Nguyên Nhân #1: Port-Forward Không Chạy

**Dấu hiệu:**
- Browser: `ERR_CONNECTION_REFUSED` hoặc `ERR_CONNECTION_CLOSED`
- Terminal: Không thấy "Forwarding from..." message

**Giải Pháp:**
```powershell
# Mở PowerShell mới (không dùng cái cũ)
cd D:\ki1nam3\PTUDDN\k8s

# Chạy port-forward
kubectl -n argocd port-forward svc/argocd-server 8080:443

# Kết quả mong đợi:
# Forwarding from 127.0.0.1:8080 -> 8443
# Forwarding from [::1]:8080 -> 8443
```

**QUAN TRỌNG:** Giữ terminal này MỞ! Đừng đóng nó!

---

### Nguyên Nhân #2: ArgoCD Server Pod Không Running

**Kiểm Tra:**
```powershell
kubectl -n argocd get pods
```

**Kết quả mong đợi:**
```
NAME                                  READY   STATUS    RESTARTS
argocd-server-xxx                     1/1     Running   0
argocd-repo-server-xxx               1/1     Running   0
argocd-application-controller-xxx    1/1     Running   0
```

**Nếu pod không Running:**
```powershell
# Xem chi tiết lỗi
kubectl -n argocd describe pod argocd-server-xxx

# Xem logs
kubectl -n argocd logs deployment/argocd-server

# Restart pod
kubectl -n argocd rollout restart deployment/argocd-server

# Đợi pod ready
kubectl -n argocd wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server --timeout=60s
```

---

### Nguyên Nhân #3: Kubernetes Cluster Không Running

**Kiểm Tra:**
```powershell
kubectl cluster-info
```

**Nếu lỗi:**
```
The connection to the server localhost:6443 was refused
```

**Giải Pháp:**
1. Mở **Docker Desktop**
2. Vào **Settings** → **Kubernetes**
3. Kiểm tra **"Enable Kubernetes"** đã check chưa
4. Nếu chưa, check rồi **Apply & Restart**
5. Đợi 2-3 phút để Kubernetes start

---

## ❌ Lỗi: Kubernetes Cluster Không Found

**Lỗi:**
```
Unable to connect to the server: No route to host
```

**Giải Pháp:**
```powershell
# 1. Kiểm tra Docker Desktop running
# 2. Kiểm tra Kubernetes enabled

# 3. Reset kubeconfig
kubectl config view

# 4. Nếu vẫn lỗi, reset Docker Desktop:
# - Docker Desktop → Preferences → Reset
# - Enable Kubernetes again
```

---

## ❌ Lỗi: ArgoCD Namespace Not Found

**Lỗi:**
```
Error from server (NotFound): namespaces "argocd" not found
```

**Giải Pháp:**
```powershell
# Install ArgoCD
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Đợi pods ready
kubectl -n argocd wait --for=condition=ready pod --all --timeout=300s

# Kiểm tra
kubectl -n argocd get pods
```

---

## ❌ Lỗi: Docker Image Not Found

**Lỗi:**
```
ImagePullBackOff
ErrImagePull
```

**Giải Pháp:**
```powershell
# 1. Build Docker image
cd D:\ki1nam3\PTUDDN\k8s
.\mvnw.cmd spring-boot:build-image -Dspring-boot.build-image.imageName=k8s-demo:latest

# 2. Kiểm tra image
docker images | grep k8s-demo

# 3. Nếu không có, xem lỗi build
# Scroll up di output và tìm lỗi

# 4. Nếu lỗi Java version:
# - Kiểm tra: java -version
# - Phải là Java 11+
# - Update pom.xml nếu cần
```

---

## ❌ Lỗi: Port 8080 Đã Được Sử Dụng

**Lỗi:**
```
error: bind: address already in use
```

**Giải Pháp:**
```powershell
# Dùng port khác
kubectl -n argocd port-forward svc/argocd-server 9090:443

# Truy cập: https://localhost:9090

# Hoặc kill process trên port 8080
netstat -ano | findstr :8080
taskkill /PID <PID> /F
```

---

## ❌ Lỗi: SSL Certificate Error

**Lỗi:**
```
NET::ERR_CERT_AUTHORITY_INVALID
```

**Giải Pháp:**
1. Click **"Advanced"**
2. Click **"Proceed to localhost (unsafe)"**

Đây là bình thường vì ArgoCD dùng self-signed certificate

---

## ✅ STEP-BY-STEP FIX

### Nếu không chạy được, thực hiện các bước này:

**Bước 1: Kiểm Tra Kubernetes**
```powershell
kubectl cluster-info
# Nếu lỗi → Enable Kubernetes trong Docker Desktop
```

**Bước 2: Kiểm Tra ArgoCD**
```powershell
kubectl -n argocd get pods
# Nếu namespace not found → Install ArgoCD
```

**Bước 3: Kiểm Tra Pods Status**
```powershell
kubectl -n argocd get pods
# Nếu pod not running → Check logs
kubectl -n argocd logs deployment/argocd-server
```

**Bước 4: Port-Forward**
```powershell
kubectl -n argocd port-forward svc/argocd-server 8080:443
# Nếu lỗi → Dùng port khác (9090, 9091, etc)
```

**Bước 5: Truy Cập Browser**
```
https://localhost:8080
# Nếu SSL error → Click Advanced → Proceed
# Nếu connection refused → Kiểm tra bước 4
```

**Bước 6: Đăng Nhập**
```
Username: admin
Password: Tmpr4695958
```

---

## 🔍 KIỂM TRA NHANH

```powershell
# 1. Kubernetes OK?
kubectl cluster-info | grep "Kubernetes master"

# 2. ArgoCD namespace OK?
kubectl get namespace argocd

# 3. ArgoCD pods OK?
kubectl -n argocd get pods -o wide

# 4. Port-forward OK?
# (Nên thấy "Forwarding" messages trong terminal)

# 5. Browser OK?
# https://localhost:8080 + Advanced + Proceed
```

---

## 📞 QUICK FIX COMMANDS

```powershell
# Restart ArgoCD
kubectl -n argocd rollout restart deployment/argocd-server

# Check all resources
kubectl -n argocd get all

# Check specific pod
kubectl -n argocd describe pod <pod-name>

# View logs
kubectl -n argocd logs <pod-name>

# Port-forward
kubectl -n argocd port-forward svc/argocd-server 8080:443

# Get initial password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

---

## 🎯 MOST COMMON ISSUE

**95% vấn đề là port-forward không chạy!**

✅ **Fix:**
```powershell
# Terminal mới
kubectl -n argocd port-forward svc/argocd-server 8080:443

# Giữ nó mở!
```

---

Sau khi làm xong, báo tôi kết quả! 🚀

