# 🎯 TÓM TẮT - LÀM NGAY

## ✅ CÁI ĐÃ XONG

1. **Code**: Spring Boot App ✅
2. **Build**: Maven JAR ✅  
3. **GitHub**: Push code ✅
4. **K8s Configs**: Manifests ready ✅
5. **ArgoCD**: Installed & configured ✅

---

## ⏳ BƯỚC TIẾP THEO (3 LẦN)

### **LẦN 1: BUILD DOCKER IMAGE** (5-15 min)

```bash
cd D:\ki1nam3\PTUDDN\k8s
docker builder prune --all
mvn clean
mvn spring-boot:build-image -Dspring-boot.build-image.imageName=k8s-demo:latest
```

**Nếu lâu quá 10 phút hoặc timeout:**
```bash
docker build -t k8s-demo:latest .
```

✅ **Done**: `Successfully built k8s-demo:latest`

---

### **LẦN 2: DEPLOY K8S** (10 min)

```bash
kubectl create namespace k8s-demo
kubectl apply -f k8s/deployment.yaml -n k8s-demo
kubectl apply -f k8s/service.yaml -n k8s-demo
kubectl get pods -n k8s-demo
```

✅ **Done**: Pod running

---

### **LẦN 3: PUSH + ARGOCD VERIFY** (5 min)

```bash
git add .
git commit -m "Deploy"
git push origin main

kubectl describe application k8s-demo-app -n argocd
```

✅ **Done**: Status = Synced

---

## 🎁 KẾT QUẢ CUỐI CÙNG

```
Code on GitHub → ArgoCD watches → Auto-deploy to K8s ✅
```

**Access App**:
```bash
kubectl port-forward svc/k8s-service 9090:80 -n k8s-demo
curl http://localhost:9090/test
```

---

**Start Now!** → Run BƯỚC 1: Build Docker Image

**Thời gian**: ~30 phút

