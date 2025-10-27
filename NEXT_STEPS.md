
## 📚 CHI TIẾT

Xem file: **PHASE3_KUBERNETES.md** (tương tự trong repo)

---

## 🔗 NEXT PHASES

- **Phase 4**: Advanced (HPA, Monitoring)
- **Phase 5**: ArgoCD + GitOps

---

**Thực hiện 3 bước ở trên rồi báo cáo kết quả!** ✅
# 🎯 TIẾP THEO LÀM GÌ? - QUICK GUIDE

**Status**: CI/CD workflows chạy xong ✅  
**Next**: Deploy to Kubernetes  

---

## 📍 TÓM TẮT

### ✅ Đã Xong
1. Spring Boot application
2. GitHub Actions CI/CD setup
3. Docker image building
4. Code quality scanning

### 🔄 Tiếp Theo
**PHASE 3: Deploy to Kubernetes**

---

## 🚀 3 BƯỚC NHANH CHÓNG

### **Bước 1: Enable Kubernetes**
```bash
# Docker Desktop → Settings → Kubernetes → Enable
# Chờ ~2-3 phút startup

# Verify
kubectl cluster-info
```

### **Bước 2: Deploy to K8s**
```bash
cd D:\ki1nam3\PTUDDN\k8s

# Create namespace
kubectl create namespace k8s-demo

# Create ConfigMap
cd k8s
kubectl create configmap k8s-config --from-file=application.properties -n k8s-demo

# Deploy app
kubectl apply -f deployment.yaml -n k8s-demo
kubectl apply -f service.yaml -n k8s-demo

# Check status
kubectl get pods -n k8s-demo
```

### **Bước 3: Test**
```bash
# Port forward
kubectl port-forward svc/k8s-service 9090:80 -n k8s-demo

# Test (in another terminal)
curl http://localhost:9090/actuator/health
# Expected: {"status":"UP"}
```

**Done! 🎉**

---

