# Hướng dẫn Chạy Ứng dụng Spring Boot trên Kubernetes

## 1. Sửa lỗi Port

**Vấn đề**: Ứng dụng được cấu hình chạy trên port 9090, nhưng deployment mong đợi port 8080.

**Giải pháp**: Đã sửa file `src/main/resources/application.properties`
- Port thay đổi từ 9090 → 8080

## 2. Rebuild Docker Image

```cmd
cd D:\ki1nam3\PTUDDN\k8s
mvnw.cmd spring-boot:build-image -Dspring-boot.build-image.imageName=k8s-demo:latest -DskipTests
```

Chờ cho đến khi build xong (khoảng 5-10 phút).

## 3. Xóa Pod Cũ và Khởi động Lại

```cmd
kubectl delete pods -n default -l app=k8s-demo
kubectl rollout restart deployment/k8s-demo -n default
```

Chờ pod khởi động:
```cmd
kubectl get pods -n default -l app=k8s-demo
```

Chờ cho đến khi `STATUS` là `Running` và `READY` là `1/1`.

## 4. Port Forward (Chạy trong Terminal Riêng)

```cmd
kubectl port-forward svc/k8s-demo 8080:8080 -n default
```

Giữ terminal này mở.

## 5. Truy Cập Ứng dụng

### Trong PowerShell hoặc CMD:
```cmd
curl http://localhost:8080/
```

### Hoặc mở trình duyệt:
- http://localhost:8080/ - Trang chủ
- http://localhost:8080/hello - Hello endpoint
- http://localhost:8080/info - Thông tin pod
- http://localhost:8080/actuator - Health endpoints

## 6. Kiểm Tra Log

```cmd
kubectl logs -f deployment/k8s-demo -n default
```

## Các Lệnh Hữu Ích

### Xem trạng thái deployment:
```cmd
kubectl describe deployment k8s-demo -n default
```

### Xem service:
```cmd
kubectl get svc k8s-demo -n default
```

### Xem một pod cụ thể:
```cmd
kubectl get pod <POD_NAME> -n default -o yaml
```

### Scale replicas:
```cmd
kubectl scale deployment k8s-demo --replicas=2 -n default
```

## Ghi Chú

- Ứng dụng chạy trên port **8080** bên trong pod
- Service expose port **8080** 
- Port-forward mapping: `8080:8080` (local:pod)
- Graceful shutdown: 30 giây
- Health checks: `/actuator/health/liveness` và `/actuator/health/readiness`

---

**Created**: 2025-10-27

