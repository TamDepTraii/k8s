| 5. CI/CD | ⏳ Pending | Final phase |

---

## 🎯 Next Action

**Priority 1**: Fix Docker build image issue
1. Run: `docker builder prune --all`
2. Run: `mvn clean`
3. Run: `mvn spring-boot:build-image -Dspring-boot.build-image.imageName=k8s-demo:latest`
4. If error persists, use: `docker build -t k8s-demo:latest .`

**Then**: Report result and continue to Step 2.2

---

## 📝 Commands Reference

```bash
# Phase 2
docker builder prune --all
mvn clean package
mvn spring-boot:build-image -Dspring-boot.build-image.imageName=k8s-demo:latest
docker run -p 8080:8080 k8s-demo:latest

# Phase 3
kubectl create namespace k8s-demo
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/deployment.yaml -n k8s-demo
kubectl apply -f k8s/service.yaml -n k8s-demo
kubectl get pods -n k8s-demo
kubectl port-forward svc/k8s-service 9090:80 -n k8s-demo

# Phase 5
git push origin main
```

---

**Last Updated**: 2025-10-26
**Status**: Ready for Phase 2.1
# 🎯 PLAN VÀ PROGRESS TRACKING

## Phase 1: Development ✅ COMPLETED

- [x] Tạo Spring Boot application
- [x] Cấu hình Maven pom.xml
- [x] Viết TestController
- [x] Tạo application.properties
- [x] Build Maven package thành công
- [x] Push lên GitHub

**Issue**: Lỗi khi build Docker image (network timeout)

---

## Phase 2: Docker & Container Image 🔄 IN PROGRESS

### Step 2.1: Fix build-image error
- [ ] Clean Docker cache
- [ ] Clean Maven cache  
- [ ] Retry build-image
- [ ] Verify image exists

**Command:**
```bash
docker builder prune --all
mvn clean
mvn spring-boot:build-image -Dspring-boot.build-image.imageName=k8s-demo:latest
docker images | grep k8s-demo
```

### Step 2.2: Test Docker image locally
- [ ] Run container
- [ ] Test health endpoint
- [ ] Stop container

**Commands:**
```bash
docker run -p 8080:8080 --name k8s-demo k8s-demo:latest
curl http://localhost:8080/actuator/health
docker stop k8s-demo
```

### Step 2.3: Create Dockerfile (optional backup)
- [x] Dockerfile created
- [ ] Test build with Dockerfile as backup

---

## Phase 3: Kubernetes Setup ⏳ TODO

### Step 3.1: Environment setup
- [ ] Verify kubectl installed
- [ ] Verify Kubernetes cluster running (Docker Desktop)
- [ ] Verify docker image available locally

### Step 3.2: Create namespace
```bash
kubectl create namespace k8s-demo
```

### Step 3.3: Create ConfigMap
```bash
cd k8s
kubectl create configmap k8s-config --from-file=application.properties -n k8s-demo
```

### Step 3.4: Deploy to Kubernetes
```bash
kubectl apply -f namespace.yaml
kubectl apply -f deployment.yaml -n k8s-demo
kubectl apply -f service.yaml -n k8s-demo
```

### Step 3.5: Verify deployment
```bash
kubectl get pods -n k8s-demo
kubectl get svc -n k8s-demo
kubectl logs deployment/k8s-deployment -n k8s-demo
```

### Step 3.6: Test application
```bash
kubectl port-forward svc/k8s-service 9090:80 -n k8s-demo
curl http://localhost:9090/actuator/health
```

---

## Phase 4: Advanced Configuration ⏳ TODO

### Step 4.1: Horizontal Pod Autoscaler (HPA)
```bash
kubectl apply -f hpa.yaml -n k8s-demo
kubectl get hpa -n k8s-demo
```

### Step 4.2: Prometheus Monitoring
- [ ] Deploy Prometheus
- [ ] Configure ServiceMonitor
- [ ] Test metrics

---

## Phase 5: CI/CD with GitHub Actions ⏳ TODO

### Step 5.1: Create GitHub Actions workflow
- [ ] Create `.github/workflows/build.yml`
- [ ] Configure Maven build
- [ ] Configure Docker build & push

### Step 5.2: Create ArgoCD integration
- [ ] Setup ArgoCD
- [ ] Create Application CRD
- [ ] Configure auto-sync

---

## 📊 Status Summary

| Phase | Status | Notes |
|-------|--------|-------|
| 1. Development | ✅ Done | Code pushed to GitHub |
| 2. Docker | 🔄 In Progress | Fix build error, then test |
| 3. Kubernetes | ⏳ Pending | Wait for docker image ready |
| 4. Advanced | ⏳ Pending | After K8s working |

