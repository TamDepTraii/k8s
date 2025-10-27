# 🚀 HƯỚNG DẪN CHI TIẾT - SỰ KIỆN TIẾP THEO

## 📌 SITUATION HIỆN TẠI

```
✅ Code được push lên GitHub
✅ ArgoCD đã cài đặt & configured
✅ K8s manifests sẵn sàng

⏳ Docker image chưa build
⏳ K8s chưa deploy
⏳ ArgoCD chưa auto-sync
```

---

## 🎯 KHI BẠN HỎI "CÀI XONG ARGOCD RỒI LÀM GÌ?"

### **Câu trả lời:**

Bây giờ bạn cần:

1. **BUILD** Docker image từ code
2. **DEPLOY** lên K8s
3. **PUSH** code lên GitHub (nếu chưa)
4. **ARGOCD** sẽ tự động deploy mỗi khi code thay đổi

---

## 📋 CÔNG VIỆC CHI TIẾT

### **CÔNG VIỆC 1: BUILD DOCKER IMAGE** ⚙️

**Mục đích**: Tạo container image của ứng dụng

**Lệnh**:
```bash
cd D:\ki1nam3\PTUDDN\k8s

# Clear cache (avoid old build issues)
docker builder prune --all

# Clean Maven cache
mvn clean

# Build Docker image using Cloud Native Buildpacks
mvn spring-boot:build-image -Dspring-boot.build-image.imageName=k8s-demo:latest
```

**Thời gian**: 5-15 phút (lần đầu có thể lâu do network)

**Khi nào xong?**
- Terminal hiển thị: `Successfully built k8s-demo:latest` ✅
- Hoặc chạy: `docker images | grep k8s-demo` → thấy `k8s-demo:latest`

**Nếu lỗi/timeout?**
- Option 1: Chạy lại (retry)
- Option 2: Dùng Dockerfile thay thế:
  ```bash
  docker build -t k8s-demo:latest .
  ```

---

### **CÔNG VIỆC 2: TEST DOCKER CONTAINER** 🐳

**Mục đích**: Verify ứng dụng chạy đúng trong container

**Lệnh**:
```bash
# Terminal 1: Start container
docker run -p 8080:8080 k8s-demo:latest

# Sẽ thấy dòng này:
# Tomcat started on port(s): 8080 [http]
```

```bash
# Terminal 2 (khác): Test endpoint
curl http://localhost:8080/actuator/health
curl http://localhost:8080/test
```

**Khi nào xong?**
- Thấy response: `{"status":"UP"}` ✅
- Test endpoint trả về data ✅

**Dừng container**: Ctrl+C ở Terminal 1

---

### **CÔNG VIỆC 3: DEPLOY LÊN KUBERNETES** ☸️

**Mục đích**: Deploy application vào K8s cluster

**Lệnh**:
```bash
# 1. Create namespace (nơi app sẽ chạy)
kubectl create namespace k8s-demo

# 2. Apply deployment configuration
kubectl apply -f k8s/deployment.yaml -n k8s-demo

# 3. Apply service configuration
kubectl apply -f k8s/service.yaml -n k8s-demo

# 4. Check pods status
kubectl get pods -n k8s-demo

# 5. Check all resources
kubectl get all -n k8s-demo
```

**Khi nào xong?**
- Pod status = `Running` ✅
- READY = `1/1` ✅

**Xem chi tiết pod**:
```bash
kubectl describe pod <pod-name> -n k8s-demo
```

---

### **CÔNG VIỆC 4: TEST K8s DEPLOYMENT** 🧪

**Mục đích**: Verify ứng dụng chạy đúng trên K8s

**Lệnh**:
```bash
# Terminal 1: Port-forward từ K8s service sang local machine
kubectl port-forward svc/k8s-service 9090:80 -n k8s-demo

# Sẽ thấy:
# Forwarding from 127.0.0.1:9090 -> 8080
```

```bash
# Terminal 2 (khác): Test endpoint
curl http://localhost:9090/actuator/health
curl http://localhost:9090/test
```

**Khi nào xong?**
- Response từ K8s pod ✅
- App chạy bình thường ✅

**Dừng port-forward**: Ctrl+C ở Terminal 1

---

### **CÔNG VIỆC 5: PUSH CODE TO GITHUB** 📤

**Mục đích**: Sync deployment files lên GitHub (ArgoCD sẽ watch nó)

**Lệnh**:
```bash
cd D:\ki1nam3\PTUDDN\k8s

# Check current status
git status

# Add all changes
git add .

# Commit
git commit -m "Add K8s deployment manifests and configurations"

# Push to main branch
git push origin main
```

**Khi nào xong?**
- Không có error message
- Xem GitHub website → files updated ✅

---

### **CÔNG VIỆC 6: VERIFY ARGOCD AUTO-SYNC** 🔄

**Mục đích**: Verify ArgoCD tự động deploy khi GitHub thay đổi

**Lệnh**:
```bash
# Check ArgoCD application status
kubectl get application -n argocd
kubectl describe application k8s-demo-app -n argocd

# Sẽ thấy: Sync Status = Synced ✅
```

**Hoặc vào UI**:
```
URL: https://localhost:8080
Username: admin
Password: 7V9NRAkYa6A-VkaU

Application name: k8s-demo-app
Status: Synced ✅
```

**Khi nào xong?**
- ArgoCD shows: `Synced` ✅
- Pods running in `k8s-demo` namespace ✅

---

## ⏱️ TIMELINE

```
Total: ~40 phút

┌─ Công việc 1 (Build Docker): 5-15 phút
├─ Công việc 2 (Test Docker): 2 phút
├─ Công việc 3 (Deploy K8s): 5 phút
├─ Công việc 4 (Test K8s): 2 phút
├─ Công việc 5 (Push GitHub): 1 phút
└─ Công việc 6 (Verify ArgoCD): 2 phút
```

---

## 🎯 ĐƠN GIẢN HÓA

Nếu bạn muốn làm nhanh, copy-paste:

**Terminal 1** (Build & test Docker):
```bash
cd D:\ki1nam3\PTUDDN\k8s
docker builder prune --all
mvn clean
mvn spring-boot:build-image -Dspring-boot.build-image.imageName=k8s-demo:latest
docker run -p 8080:8080 k8s-demo:latest
```

**Terminal 2** (Test):
```bash
curl http://localhost:8080/test
```

**Terminal 3** (Deploy K8s):
```bash
kubectl create namespace k8s-demo
kubectl apply -f k8s/deployment.yaml -n k8s-demo
kubectl apply -f k8s/service.yaml -n k8s-demo
kubectl get pods -n k8s-demo
```

**Terminal 4** (Port-forward):
```bash
kubectl port-forward svc/k8s-service 9090:80 -n k8s-demo
```

**Terminal 5** (Test K8s):
```bash
curl http://localhost:9090/test
```

**Terminal 3** (Push GitHub):
```bash
cd D:\ki1nam3\PTUDDN\k8s
git add .
git commit -m "Deploy setup"
git push origin main
```

**Terminal 3** (Verify ArgoCD):
```bash
kubectl describe application k8s-demo-app -n argocd
```

---

## 🎁 SAU KHI XONG

Bây giờ bạn có:
1. ✅ Docker image (can reuse)
2. ✅ K8s deployment (can scale)
3. ✅ GitHub repo (single source of truth)
4. ✅ ArgoCD (auto-deploy on changes)

**Workflow GitOps:**
```
Edit k8s/deployment.yaml
    ↓
git commit + push
    ↓
ArgoCD detect (30-60 sec)
    ↓
Auto-deploy new version
    ↓
Check: kubectl get pods -n k8s-demo
```

---

## ❓ FAQ

### Q: Bao lâu để hoàn thành?
**A**: ~40 phút nếu network tốt

### Q: Docker image build quá lâu?
**A**: Normal, đặc biệt lần đầu. Có thể lên đến 15 phút. Nếu >30 phút, dùng `docker build -t k8s-demo:latest .`

### Q: Pod status CrashLoopBackOff?
**A**: 
```bash
kubectl logs deployment/k8s-app -n k8s-demo
kubectl describe pod <pod-name> -n k8s-demo
```

### Q: ArgoCD không sync?
**A**: 
```bash
kubectl describe application k8s-demo-app -n argocd
# Check: repo URL, path, branch
```

---

## 📞 SUPPORT

**Terminal commands không chạy?**
- Ensure PowerShell running as Admin
- Check: `kubectl version`, `docker --version`

**Pod failed to start?**
- Check logs: `kubectl logs ...`
- Check events: `kubectl get events -n k8s-demo`

**Network timeout?**
- Retry build
- Check internet connection
- Try alternative: `docker build -t ...`

---

**Ready?** → Start with Công Việc 1! 🚀

