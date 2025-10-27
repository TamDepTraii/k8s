# 🚀 TIẾP THEO: PHASE 3 - KUBERNETES DEPLOYMENT

**Status**: ✅ CI/CD Workflows chạy xong (hoặc đang chạy)  
**Date**: 2025-10-27  
**Next Phase**: Phase 3 - Deploy to Kubernetes

---

## 📊 HIỆN TẠI

### ✅ Đã Hoàn Thành
- ✔️ Phase 1: Development (Spring Boot app)
- ✔️ Phase 2 Prep: Comprehensive documentation
- ✔️ GitHub Actions CI/CD workflow setup
- ✔️ Code Quality Check workflow setup

### 🔄 Đang Xử Lý
- 🔄 Workflow đang chạy (in progress)
- 🔄 Docker image building
- 🔄 Code quality scanning

### ⏳ Tiếp Theo
- **PHASE 3**: Deploy to Kubernetes (NGAY BÂY GIỜ)

---

## 🎯 PHASE 3: KUBERNETES DEPLOYMENT

**Thực hiện các bước sau:**

### **Step 1: Enable Kubernetes in Docker Desktop** (Nếu chưa)

```bash
# Windows: Docker Desktop Settings → Kubernetes → Enable Kubernetes
# Sau đó chờ ~2-3 phút để Kubernetes startup

# Verify Kubernetes chạy
kubectl cluster-info
kubectl get nodes

# Expected output:
# Kubernetes master is running at https://127.0.0.1:6443
```

---

### **Step 2: Create Namespace**

```bash
# Tạo namespace
kubectl create namespace k8s-demo

# Verify
kubectl get namespaces
```

---

### **Step 3: Create ConfigMap** 

```bash
cd D:\ki1nam3\PTUDDN\k8s\k8s

# Tạo ConfigMap từ application.properties
kubectl create configmap k8s-config --from-file=application.properties -n k8s-demo

# Verify
kubectl get configmap -n k8s-demo
kubectl describe configmap k8s-config -n k8s-demo
```

---

### **Step 4: Deploy to Kubernetes**

```bash
# Apply namespace
kubectl apply -f namespace.yaml

# Apply deployment
kubectl apply -f deployment.yaml -n k8s-demo

# Apply service
kubectl apply -f service.yaml -n k8s-demo

# Verify
kubectl get pods -n k8s-demo
kubectl get svc -n k8s-demo

# Expected output:
# NAME                              READY   STATUS    RESTARTS   AGE
# k8s-deployment-5d4b5c7f7f-xxxx   1/1     Running   0          2m
# 
# NAME          TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
# k8s-service   ClusterIP   10.96.xxx.xxx   <none>        80/TCP    2m
```

---

### **Step 5: Check Deployment Status**

```bash
# Xem chi tiết deployment
kubectl describe deployment k8s-deployment -n k8s-demo

# Xem pod logs
kubectl logs -f deployment/k8s-deployment -n k8s-demo

# Get pod details
kubectl get pod -n k8s-demo
```

---

### **Step 6: Port Forward & Test**

```bash
# Port forward service
kubectl port-forward svc/k8s-service 9090:80 -n k8s-demo

# Trong terminal khác, test health check
curl http://localhost:9090/actuator/health

# Expected output:
# {"status":"UP"}

# Test endpoint khác
curl http://localhost:9090/

# Xem logs từ pod
kubectl logs <pod-name> -n k8s-demo
```

---

### **Step 7: Test Readiness & Liveness Probes**

```bash
# Kiểm tra probes hoạt động
kubectl get deployment k8s-deployment -n k8s-demo -o yaml | grep -A 10 "readiness\|liveness"

# Watch pod status
kubectl get pods -n k8s-demo -w

# Nếu pod không ready, check logs
kubectl logs <pod-name> -n k8s-demo
kubectl describe pod <pod-name> -n k8s-demo
```

---

## 📋 TROUBLESHOOTING PHASE 3

### ❓ Pods không up?

```bash
# Check logs
kubectl logs <pod-name> -n k8s-demo

# Check events
kubectl describe pod <pod-name> -n k8s-demo

# Common issues:
# 1. ImagePullBackOff - image không tồn tại
#    Fix: Build Docker image trước, hoặc change imagePullPolicy: Never

# 2. CrashLoopBackOff - app crash
#    Fix: Check logs, verify application.properties

# 3. Pending - không có resources
#    Fix: Check node status, resources available
```

---

### ❓ Health check không work?

```bash
# Check endpoint
curl -v http://localhost:9090/actuator/health

# Check readiness endpoint
curl http://localhost:9090/actuator/health/readiness

# Check liveness endpoint
curl http://localhost:9090/actuator/health/liveness

# If not responding, check probes in deployment.yaml
kubectl get deployment k8s-deployment -n k8s-demo -o yaml
```

---

### ❓ Service không accessible?

```bash
# Check service
kubectl get svc k8s-service -n k8s-demo
kubectl describe svc k8s-service -n k8s-demo

# Check endpoints
kubectl get endpoints -n k8s-demo

# Port forward verbose
kubectl port-forward svc/k8s-service 9090:80 -n k8s-demo -v 5
```

---

## 🔍 KIỂM CHỨNG THÀNH CÔNG

✅ **Success Criteria:**

- [x] Kubernetes cluster running
- [ ] Namespace created
- [ ] ConfigMap created
- [ ] Deployment created
- [ ] Pod running (READY 1/1)
- [ ] Service created
- [ ] Port-forward working
- [ ] Health check responding: `{"status":"UP"}`
- [ ] App logs visible

**Tất cả đủ → PHASE 3 SUCCESS!** 🎉

---

## 📊 COMMANDS REFERENCE

```bash
# Namespace
kubectl create namespace k8s-demo
kubectl get namespaces
kubectl delete namespace k8s-demo

# ConfigMap
kubectl create configmap k8s-config --from-file=application.properties -n k8s-demo
kubectl get configmap -n k8s-demo
kubectl describe configmap k8s-config -n k8s-demo

# Deployment
kubectl apply -f deployment.yaml -n k8s-demo
kubectl get deployment -n k8s-demo
kubectl describe deployment k8s-deployment -n k8s-demo
kubectl delete deployment k8s-deployment -n k8s-demo

# Pod
kubectl get pods -n k8s-demo
kubectl describe pod <pod-name> -n k8s-demo
kubectl logs <pod-name> -n k8s-demo
kubectl logs -f <pod-name> -n k8s-demo
kubectl exec -it <pod-name> -n k8s-demo -- /bin/bash

# Service
kubectl apply -f service.yaml -n k8s-demo
kubectl get svc -n k8s-demo
kubectl describe svc k8s-service -n k8s-demo

# Port Forward
kubectl port-forward svc/k8s-service 9090:80 -n k8s-demo

# Debugging
kubectl get events -n k8s-demo
kubectl top pods -n k8s-demo
kubectl top nodes
```

---

## 🚀 QUICK START (Copy-Paste)

```bash
# 1. Create namespace
kubectl create namespace k8s-demo

# 2. Create ConfigMap
cd D:\ki1nam3\PTUDDN\k8s\k8s
kubectl create configmap k8s-config --from-file=application.properties -n k8s-demo

# 3. Deploy
kubectl apply -f deployment.yaml -n k8s-demo
kubectl apply -f service.yaml -n k8s-demo

# 4. Check status
kubectl get pods -n k8s-demo
kubectl get svc -n k8s-demo

# 5. Test
kubectl port-forward svc/k8s-service 9090:80 -n k8s-demo
# In another terminal:
curl http://localhost:9090/actuator/health
```

---

## 📈 ROADMAP

```
Phase 1: Development              ✅ DONE
Phase 2: Docker Build & CI/CD     ✅ DONE
Phase 3: Kubernetes Deploy        🔄 NOW
  ├─ Namespace
  ├─ ConfigMap
  ├─ Deployment
  ├─ Service
  └─ Verification

Phase 4: Advanced Features        ⏳ NEXT
  ├─ HPA (Horizontal Pod Autoscaler)
  ├─ Monitoring (Prometheus)
  └─ Logging (optional)

Phase 5: CI/CD Integration        ⏳ FINAL
  ├─ ArgoCD setup
  └─ GitOps automation
```

---

## 📝 NOTES

- **Kubernetes Dashboard**: `kubectl proxy` then visit http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/
- **Metrics Server**: Required for HPA (usually pre-installed in Docker Desktop)
- **Persistence**: Current setup uses ephemeral storage (no PVC)

---

## ✅ CHECKLIST - PHASE 3

- [ ] Docker Desktop Kubernetes enabled
- [ ] kubectl installed & working
- [ ] Namespace created
- [ ] ConfigMap created
- [ ] Deployment applied
- [ ] Service applied
- [ ] Pods running (Ready 1/1)
- [ ] Port-forward working
- [ ] Health check OK: {"status":"UP"}
- [ ] Logs visible

**After all ✓ → Move to Phase 4!**

---

**Status**: 🟢 Ready for Phase 3  
**Next**: Start with Step 1 above  
**ETA**: 20-30 minutes  

**Let's deploy to Kubernetes! 🚀**

