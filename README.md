# Spring Boot on Kubernetes - K8s Demo

Dự án demo triển khai ứng dụng Spring Boot lên Kubernetes theo hướng dẫn từ Spring.io.

## 📋 Yêu cầu

- Java 11+
- Docker Desktop (với Kubernetes enabled)
- Maven 3.6+
- kubectl
- Git

## 🚀 Hướng dẫn triển khai

### Bước 1: Build Docker Image

```bash
cd D:\ki1nam3\PTUDDN\k8s
mvn clean package
mvn spring-boot:build-image -Dspring-boot.build-image.imageName=k8s-demo:latest
```

**Nếu gặp lỗi download network:**
```bash
# Retry lần nữa hoặc sử dụng cache
mvn spring-boot:build-image -Dspring-boot.build-image.imageName=k8s-demo:latest -DskipTests
```

### Bước 2: Kiểm tra Docker Image

```bash
docker images | grep k8s-demo
docker run -p 8080:8080 k8s-demo:latest
```

Kiểm tra health: `curl http://localhost:8080/actuator/health`

### Bước 3: Tạo Kubernetes Namespace

```bash
kubectl create namespace k8s-demo
```

### Bước 4: Tạo ConfigMap

```bash
cd k8s
kubectl create configmap k8s-config --from-file=application.properties -n k8s-demo
```

### Bước 5: Deploy lên Kubernetes

```bash
# Áp dụng deployment
kubectl apply -f deployment.yaml -n k8s-demo

# Kiểm tra pods
kubectl get pods -n k8s-demo

# Kiểm tra services
kubectl get svc -n k8s-demo

# Áp dụng service
kubectl apply -f service.yaml -n k8s-demo
```

### Bước 6: Port Forward và Test

```bash
kubectl port-forward svc/k8s-service 9090:80 -n k8s-demo
curl http://localhost:9090/actuator/health
```

## 📁 Cấu trúc Dự án

```
k8s/
├── src/
│   ├── main/
│   │   ├── java/com/example/k8s/
│   │   │   ├── K8sApplication.java
│   │   │   └── controller/
│   │   │       └── TestController.java
│   │   └── resources/
│   │       └── application.properties
│   └── test/
│       └── java/com/example/k8s/
│           └── K8sApplicationTests.java
├── k8s/
│   ├── namespace.yaml
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── configmap.yaml
│   ├── application.properties
│   └── hpa.yaml (Optional)
├── Dockerfile
├── docker-compose.yml
├── pom.xml
└── README.md
```

## 🔧 Endpoints

| Endpoint | Mô tả |
|----------|-------|
| `GET /` | Trang chủ |
| `GET /actuator/health` | Health check |
| `GET /actuator/health/liveness` | Liveness probe |
| `GET /actuator/health/readiness` | Readiness probe |
| `GET /actuator/metrics` | Metrics |
| `GET /actuator/prometheus` | Prometheus metrics |

## 🐛 Troubleshooting

### Lỗi: "Unable to download JRE"
- Kiểm tra kết nối Internet
- Retry lần nữa
- Hoặc sử dụng JDK thay vì JRE

### Lỗi: "ImagePullBackOff" trong Kubernetes
- Đảm bảo Docker image đã build thành công
- Sử dụng `imagePullPolicy: Never` trong deployment (để dùng local image)

### Lỗi: "Pod không lên Ready state"
- Kiểm tra logs: `kubectl logs <pod-name> -n k8s-demo`
- Kiểm tra readiness probe: `kubectl describe pod <pod-name> -n k8s-demo`

## 📊 Monitoring

```bash
# Xem logs của pod
kubectl logs -f deployment/k8s-deployment -n k8s-demo

# Xem metrics
kubectl top pods -n k8s-demo

# Port forward Prometheus (nếu cài)
kubectl port-forward svc/prometheus 9090:9090 -n monitoring
```

## 🔄 CI/CD (Coming Soon)

- GitHub Actions workflow
- ArgoCD integration

## 📝 Tài liệu tham khảo

- [Spring on Kubernetes](https://spring.io/guides/topicals/spring-on-kubernetes)
- [Spring Boot Build Image](https://spring.io/blog/2020/08/14/buildpacks-and-spring-boot-0-5-0)
- [Kubernetes Official Docs](https://kubernetes.io/docs/)

## 👤 Tác giả

- Tam

## 📄 License

MIT

