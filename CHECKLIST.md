# ✅ CHECKLIST - HOÀN THÀNH DỰ ÁN

## PHASE 1: DEVELOPMENT ✅ XONG

- [x] Tạo Spring Boot project
- [x] Viết TestController
- [x] Config Maven pom.xml
- [x] Build thành JAR
- [x] Push lên GitHub

---

## PHASE 2: DOCKER 🔨 ĐANG LÀM

**Lệnh chạy:**
```bash
cd D:\ki1nam3\PTUDDN\k8s
docker builder prune --all
mvn clean
mvn spring-boot:build-image -Dspring-boot.build-image.imageName=k8s-demo:latest
```

- [ ] Xóa cache (`docker builder prune --all`)
- [ ] Clean Maven (`mvn clean`)  
- [ ] Build Docker image
- [ ] Verify image exists (`docker images | grep k8s-demo`)
- [ ] Test container (`docker run -p 8080:8080 k8s-demo:latest`)
- [ ] Test endpoint (`curl http://localhost:8080/test`)

**Status**: ⏳ Waiting

---

## PHASE 3: KUBERNETES ⏳ TODO

**Lệnh chạy:**
```bash
kubectl create namespace k8s-demo
kubectl apply -f k8s/deployment.yaml -n k8s-demo
kubectl apply -f k8s/service.yaml -n k8s-demo
kubectl get pods -n k8s-demo
```

- [ ] Create namespace
- [ ] Apply deployment  
- [ ] Apply service
- [ ] Check pods status (Running)
- [ ] Port-forward test
- [ ] Test endpoint via K8s

**Status**: ⏳ Waiting for Phase 2

---

## PHASE 4: GITHUB ⏳ TODO

**Lệnh chạy:**
```bash
git add .
git commit -m "K8s deployment setup"
git push origin main
```

- [ ] Add files to git
- [ ] Commit changes
- [ ] Push to GitHub
- [ ] Verify on GitHub website

**Status**: ⏳ Waiting for Phase 3

---

## PHASE 5: ARGOCD VERIFY ⏳ TODO

**Lệnh chạy:**
```bash
kubectl describe application k8s-demo-app -n argocd
```

- [ ] Check application sync status
- [ ] Access ArgoCD UI (https://localhost:8080)
- [ ] Login (admin / 7V9NRAkYa6A-VkaU)
- [ ] Verify auto-sync enabled
- [ ] Check deployment in k8s-demo namespace

**Status**: ⏳ Waiting for Phase 4

---

## PHASE 6: MONITORING & SCALE ⏳ OPTIONAL

- [ ] Check Prometheus metrics (/actuator/prometheus)
- [ ] View logs (`kubectl logs deployment/k8s-app -n k8s-demo`)
- [ ] Scale replicas (edit deployment.yaml, push to GitHub)
- [ ] Verify auto-deployment via ArgoCD

**Status**: ⏳ After Phase 5

---

## 🎯 CURRENT TASK

### **DO THIS NOW:**

1. Open PowerShell
2. Run:
```bash
cd D:\ki1nam3\PTUDDN\k8s
docker builder prune --all
mvn clean
mvn spring-boot:build-image -Dspring-boot.build-image.imageName=k8s-demo:latest
```

3. Wait for completion (5-15 minutes)
4. Check output:
   - Success: `Successfully built k8s-demo:latest`
   - Error: Report the error message

5. Then come back and follow next steps

---

## 📊 PROGRESS TRACKER

```
Phase 1: ████████████████████ ✅ 100%
Phase 2: ████░░░░░░░░░░░░░░░ ⏳  20%
Phase 3: ░░░░░░░░░░░░░░░░░░░░ ⏳   0%
Phase 4: ░░░░░░░░░░░░░░░░░░░░ ⏳   0%
Phase 5: ░░░░░░░░░░░░░░░░░░░░ ⏳   0%
Phase 6: ░░░░░░░░░░░░░░░░░░░░ ⏳   0%

Overall: ████░░░░░░░░░░░░░░░░ 16%
```

---

## 📝 NOTES

**Important Dates:**
- Started: 2025-10-26
- Phase 1 Done: 2025-10-26
- Phase 4 (ArgoCD) Done: 2025-10-27
- Current: Phase 2 (Docker Build)

**Key Files:**
- Source: `src/main/java/com/example/k8s/`
- Configs: `k8s/*.yaml`
- Docker: `Dockerfile`
- ArgoCD: `argocd/application.yaml`

**Commands Reference:**
```bash
# Check status
docker images | grep k8s-demo
kubectl get pods -n k8s-demo
kubectl get application -n argocd

# Port forward
kubectl port-forward svc/k8s-service 9090:80 -n k8s-demo

# Logs
kubectl logs deployment/k8s-app -n k8s-demo
kubectl logs -f deployment/argocd-server -n argocd
```

---

**Last Updated**: 2025-10-27  
**Next Action**: Build Docker image  
**Est. Completion**: ~1 hour

