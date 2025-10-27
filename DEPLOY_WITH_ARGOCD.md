# 🎯 HƯỚNG DẪN KHỞI ĐỘNG APP VỚI ARGOCD

**Bạn muốn**: App chạy với ArgoCD  
**Status**: ✅ Sẵn sàng  
**Thời gian**: ~15 phút

---

## 📋 BƯỚC 1: Kiểm Tra Docker Image

```bash
# Kiểm tra xem image đã được build chưa
docker images k8s-demo
```

Nếu thấy `k8s-demo:latest` → Tiếp bước 2

Nếu không thấy → Build ngay:
```bash
docker build -t k8s-demo:latest .
```

---

## 🚀 BƯỚC 2: Deploy App to Kubernetes

```bash
# Tạo namespace
kubectl create namespace k8s-demo

# Deploy application
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

# Kiểm tra status (đợi ~1-2 phút)
kubectl get pods -n k8s-demo
kubectl get svc -n k8s-demo
```

**Chờ cho đến khi thấy**:
```
NAME                          READY   STATUS    
pod/k8s-demo-xxxxx            1/1     Running   
service/k8s-service           ClusterIP   
```

---

## 📊 BƯỚC 3: Setup ArgoCD

```bash
# Deploy ArgoCD Application
kubectl apply -f argocd/application-k8s-demo.yaml

# Kiểm tra
kubectl get applications -n argocd
```

**Output**: Nên thấy `k8s-demo` application

---

## 🌐 BƯỚC 4: Truy Cập ArgoCD Dashboard

**Terminal 1** (chạy port-forward):
```bash
kubectl -n argocd port-forward svc/argocd-server 8080:443
```

**Browser**: https://localhost:8080

**Đăng nhập**:
- Username: `admin`
- Password: `Tmpr4695958`

---

## ✅ BƯỚC 5: Kiểm Tra ArgoCD

Trong ArgoCD Dashboard, bạn sẽ thấy:

1. **Application**: `k8s-demo`
2. **Status**: `Synced` (xanh) hoặc `Out of Sync` (đỏ)
3. **Deployment**: `k8s-demo` (3 replicas)
4. **Service**: `k8s-service`
5. **Pods**: 3 pods đang chạy

---

## 🔌 BƯỚC 6: Truy Cập Application

**Terminal 2** (mở terminal khác):
```bash
kubectl -n k8s-demo port-forward svc/k8s-service 8080:8080
```

**Browser**: http://localhost:8080

**Health Check**:
```bash
curl http://localhost:8080/actuator/health
# Response: {"status":"UP"}
```

---

## 📊 BƯỚC 7: Kiểm Tra Metrics

```bash
curl http://localhost:8080/actuator/prometheus
```

Hoặc truy cập: http://localhost:8080/actuator/prometheus

---

## 🔄 CI/CD WORKFLOW (Tự động với ArgoCD)

Giờ khi bạn:

1. **Thay đổi code** → Commit
2. **Push to GitHub**
3. **ArgoCD tự động nhận thấy** (trong 3 phút)
4. **Tự động deploy** phiên bản mới

Kiểm tra: Vào ArgoCD dashboard xem sync status

---

## 🎮 COMMANDS TỰA DỤNG

```bash
# === Kubernetes ===
kubectl get all -n k8s-demo                    # Xem tất cả resources
kubectl logs -f pod/POD_NAME -n k8s-demo       # Xem logs
kubectl describe pod/POD_NAME -n k8s-demo      # Chi tiết pod
kubectl exec -it pod/POD_NAME -n k8s-demo bash # SSH vào pod

# === ArgoCD ===
kubectl get applications -n argocd             # Xem apps
kubectl describe application k8s-demo -n argocd # Chi tiết app
kubectl logs -f pod/argocd-server-xxx -n argocd # ArgoCD logs

# === Port Forwarding ===
kubectl -n k8s-demo port-forward svc/k8s-service 8080:8080
kubectl -n argocd port-forward svc/argocd-server 8080:443

# === Cleanup (nếu cần) ===
kubectl delete namespace k8s-demo              # Xóa tất cả app
kubectl delete application k8s-demo -n argocd  # Xóa ArgoCD app
```

---

## ⚡ QUICK CHECKLIST

```
[ ] Docker image built (docker images k8s-demo)
[ ] K8s deployment created (kubectl get deployments -n k8s-demo)
[ ] Service created (kubectl get svc -n k8s-demo)
[ ] ArgoCD application created (kubectl get applications -n argocd)
[ ] ArgoCD dashboard accessible (https://localhost:8080)
[ ] Application accessible (http://localhost:8080)
[ ] Health check passing (curl health endpoint)
```

---

## 🐛 TROUBLESHOOTING

### Problem: Pod không start
```bash
kubectl describe pod/POD_NAME -n k8s-demo
kubectl logs pod/POD_NAME -n k8s-demo
```

### Problem: ArgoCD OutOfSync
```bash
# Click "Sync" button trong dashboard
# Hoặc command:
kubectl patch application k8s-demo -n argocd --type merge -p '{"spec":{"syncPolicy":{"automated":{"prune":true,"selfHeal":true}}}}'
```

### Problem: Port 8080 đã được sử dụng
```bash
# Dùng port khác
kubectl -n k8s-demo port-forward svc/k8s-service 9090:8080
# Truy cập: http://localhost:9090
```

### Problem: Image not found
```bash
docker build -t k8s-demo:latest .
```

---

## 📞 SUPPORT

- Xem: `DEPLOYMENT_STATUS.md` - Status chi tiết
- Xem: `QUICK_START_GUIDE.md` - Các options khác
- Xem: `COMPLETE_TROUBLESHOOTING.md` - Giải pháp

---

## ✨ FINAL RESULT

Sau khi hoàn thành:

✅ **Application running on Kubernetes**
✅ **ArgoCD managing deployment**
✅ **Auto-sync enabled**
✅ **Monitoring with Prometheus**
✅ **CI/CD pipeline ready**

**Accessible at**:
- App: http://localhost:8080
- ArgoCD: https://localhost:8080 (admin / Tmpr4695958)
- Metrics: http://localhost:8080/actuator/prometheus

---

**Good luck! 🚀**

