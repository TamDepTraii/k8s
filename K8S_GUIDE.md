curl http://localhost:9090/actuator/health

# Test helloWorld endpoint
curl http://localhost:9090/helloWorld

# Test load balancing (chạy nhiều lần để thấy pod name khác nhau)
curl http://localhost:9090/name

# Xem environment variables
curl http://localhost:9090/actuator/env
```

## Bước 5: Monitoring với Prometheus

Prometheus metrics có sẵn tại:
```bash
curl http://localhost:9090/actuator/prometheus
```

## Các Endpoints khả dụng

- `GET /helloWorld` - Trả về Hello World message với hostname
- `GET /name` - Trả về tên pod
- `GET /api/test` - Endpoint test
- `GET /actuator/health` - Health check
- `GET /actuator/health/liveness` - Liveness probe
- `GET /actuator/health/readiness` - Readiness probe
- `GET /actuator/env` - Environment variables
- `GET /actuator/prometheus` - Prometheus metrics

## Features được triển khai

✅ **Liveness & Readiness Probes** - Kubernetes tự động restart nếu pod không healthy
✅ **Graceful Shutdown** - Application shutdown gracefully khi Kubernetes terminate pod
✅ **Horizontal Pod Autoscaler** - Tự động scale pods dựa trên CPU/Memory
✅ **ConfigMap** - Externalize configuration
✅ **Prometheus Metrics** - Monitor application
✅ **Spring Actuator** - Health checks và metrics

## Troubleshooting

### Pod stuck in CrashLoopBackOff
```bash
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

### Health probe failures
Kiểm tra readiness probe:
```bash
kubectl get pod <pod-name> -o yaml | grep -A 10 readinessProbe
```

### Delete deployment
```bash
kubectl delete deployment k8s-demo
kubectl delete service k8s-demo-service
kubectl delete configmap k8s-demo-config
kubectl delete hpa k8s-demo-hpa
```

hoặc xóa tất cả:
```bash
kubectl delete -f k8s/
```

## Best Practices được áp dụng

1. **Resource Requests & Limits** - Để scheduler có thể allocate resources tốt
2. **Health Checks** - Liveness probe (để detect dead pods) và Readiness probe (để detect pods chưa sẵn sàng)
3. **Graceful Shutdown** - Cho phép connection cleanup trước khi shutdown
4. **ConfigMap** - Externalize configuration thay vì hardcode
5. **Labels & Selectors** - Để dễ quản lý resources
6. **Readiness for HPA** - HPA dùng readiness probe để cân bằng tải
7. **Prometheus Metrics** - Để monitoring và observability

## References

- [Spring on Kubernetes Guide](https://spring.io/guides/topicals/spring-on-kubernetes)
- [Spring Boot Actuator Documentation](https://spring.io/projects/spring-boot)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
# Spring Boot on Kubernetes - K8s Demo

Dự án này triển khai một Spring Boot application trên Kubernetes theo hướng dẫn từ Spring.io.

## Prerequisites

- Java 17 hoặc cao hơn
- Maven 3.6+
- Docker
- Kubernetes (Docker Desktop, Minikube, hoặc cluster khác)
- kubectl CLI

## Project Structure

```
k8s/
├── deployment.yaml          # Kubernetes Deployment + Service
├── service.yaml             # Kubernetes Service (already in deployment.yaml)
├── configmap.yaml           # ConfigMap cho external configuration
├── hpa.yaml                 # Horizontal Pod Autoscaler
├── prometheus-config.yaml   # Prometheus scrape configuration
└── application.properties   # Properties cho ConfigMap
```

## Bước 1: Build Docker Image

Sử dụng Cloud Native Buildpacks để tạo Docker image:

```bash
# Từ thư mục root của project
./mvnw spring-boot:build-image -Dspring-boot.build-image.imageName=k8s-demo:latest
```

Kiểm tra image đã được tạo:
```bash
docker images k8s-demo
```

## Bước 2: Test Docker Image locally

```bash
docker run -p 8080:8080 --name k8s-demo-test k8s-demo:latest
```

Test health endpoint:
```bash
curl http://localhost:8080/actuator/health
```

Test helloWorld endpoint:
```bash
curl http://localhost:8080/helloWorld
```

Dừng container:
```bash
docker stop k8s-demo-test
docker rm k8s-demo-test
```

## Bước 3: Deploy lên Kubernetes

### 3.1 Tạo ConfigMap
```bash
kubectl apply -f k8s/configmap.yaml
```

### 3.2 Deploy Application
```bash
kubectl apply -f k8s/deployment.yaml
```

### 3.3 Deploy HPA (Optional)
```bash
kubectl apply -f k8s/hpa.yaml
```

### 3.4 Kiểm tra deployment
```bash
# Xem tất cả resources
kubectl get all

# Xem pods đang chạy
kubectl get pods --selector=app=k8s-demo

# Xem logs
kubectl logs -l app=k8s-demo -f

# Xem chi tiết deployment
kubectl describe deployment k8s-demo
```

## Bước 4: Test Application trong Kubernetes

### Port-forward để access service
```bash
kubectl port-forward svc/k8s-demo-service 9090:80
```

Trong terminal khác, test:
```bash
# Test health endpoint

