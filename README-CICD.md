```yaml
Min replicas: 3
Max replicas: 10

Metrics:
- CPU: 70% utilization
- Memory: 80% utilization
```

### Resource Limits

```yaml
Requests:
  CPU: 200m
  Memory: 256Mi

Limits:
  CPU: 500m
  Memory: 512Mi
```

## 🔐 Security Best Practices

### Implemented

✅ Non-root user (uid: 1000)
✅ Read-only root filesystem
✅ Drop all Linux capabilities
✅ Pod Security Context
✅ Network Policy ready
✅ RBAC configured
✅ Security scanning with Trivy
✅ Private container registries

### Recommendations

- [ ] Enable Pod Security Policies
- [ ] Configure Network Policies
- [ ] Enable RBAC for service accounts
- [ ] Use sealed secrets for sensitive data
- [ ] Enable audit logging
- [ ] Use private container registries
- [ ] Regularly scan images with Trivy

## 📊 Monitoring

### Prometheus Metrics

Application exposes metrics at `/actuator/prometheus`:

```bash
# Access metrics
curl http://localhost:8080/actuator/prometheus
```

### Health Endpoints

```bash
# Overall health
curl http://localhost:8080/actuator/health

# Liveness probe
curl http://localhost:8080/actuator/health/liveness

# Readiness probe
curl http://localhost:8080/actuator/health/readiness

# Info
curl http://localhost:8080/actuator/info
```

### Install Prometheus & Grafana

```bash
# Add Prometheus Helm repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Install kube-prometheus-stack
helm install prometheus prometheus-community/kube-prometheus-stack \
  -n monitoring --create-namespace

# Port forward Prometheus
kubectl port-forward -n monitoring svc/prometheus-kube-prometheus-prometheus 9090:9090

# Port forward Grafana
kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80

# Default Grafana credentials: admin/prom-operator
```

## 🔄 ArgoCD Configuration

### Sync Policy

```yaml
automated:
  prune: true           # Delete resources not in Git
  selfHeal: true        # Sync when cluster changes
  allowEmpty: false     # Don't sync if empty
```

### Retry Strategy

```yaml
retry:
  limit: 5              # Max 5 retries
  backoff:
    duration: 5s        # Initial wait
    factor: 2           # Exponential backoff
    maxDuration: 3m     # Max wait time
```

## 🧪 Testing

### Unit Tests

```bash
mvn test
```

### Integration Tests

```bash
mvn verify
```

### Load Testing

```bash
# Using Apache Bench
ab -n 1000 -c 10 http://localhost:8080/

# Using hey
hey -n 1000 -c 10 http://localhost:8080/
```

## 🐛 Troubleshooting

### Docker Build Issues

```bash
# Check Docker daemon
docker ps

# Clean Docker resources
docker system prune -a

# Build with verbose output
docker build --progress=plain -t k8s-demo:latest .
```

### Kubernetes Issues

```bash
# Check pod status
kubectl get pods -n k8s-demo
kubectl describe pod <pod-name> -n k8s-demo
kubectl logs <pod-name> -n k8s-demo

# Check events
kubectl get events -n k8s-demo

# Check deployment status
kubectl rollout status deployment/k8s-demo -n k8s-demo

# Rollback if needed
kubectl rollout undo deployment/k8s-demo -n k8s-demo
```

### ArgoCD Issues

```bash
# Check ArgoCD application status
kubectl get application -n argocd
kubectl describe application k8s-demo -n argocd

# Check ArgoCD server logs
kubectl logs -n argocd deployment/argocd-server

# Manual sync
kubectl apply -f k8s/
```

## 📚 Documentation References

- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Docker Documentation](https://docs.docker.com/)
- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

## 🤝 Contributing

1. Fork repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

## 📝 Environment Variables

### Application Configuration

```properties
# Server
server.shutdown=graceful
server.servlet.context-path=/

# Actuator
management.endpoints.web.exposure.include=health,info,metrics,prometheus
management.endpoint.health.show-details=when-authorized
management.health.livenessState.enabled=true
management.health.readinessState.enabled=true

# Logging
logging.level.root=INFO
logging.level.com.example.k8s=DEBUG

# Spring
spring.application.name=k8s-demo
spring.profiles.active=production
```

## 🔗 Useful Links

- **GitHub Repository**: https://github.com/TamDepTraii/k8s
- **Docker Hub**: https://hub.docker.com
- **GitHub Container Registry**: https://github.com/features/packages
- **ArgoCD**: https://argo-cd.readthedocs.io/

## 📞 Support

Nếu gặp vấn đề, vui lòng:
1. Kiểm tra troubleshooting section
2. Xem GitHub Issues
3. Đọc logs và error messages
4. Tạo issue mới với chi tiết lỗi

## 📄 License

MIT License - xem LICENSE file

## 👨‍💼 Author

**TamDepTraii** - [GitHub Profile](https://github.com/TamDepTraii)

---

Made with ❤️ by TamDepTraii
# Spring Boot Kubernetes CI/CD Pipeline

> Dự án demo sử dụng **GitHub Actions** cho CI/CD và **ArgoCD** cho Continuous Deployment trên Kubernetes.

![Pipeline Architecture](./docs/pipeline-architecture.png)

## 📋 Tổng Quan

Pipeline CI/CD này thực hiện các bước sau:

1. **Build & Test** - Biên dịch ứng dụng Spring Boot và chạy unit tests
2. **Security Scan** - Quét lỗ hổng bảo mật với Trivy
3. **Build Docker Image** - Đóng gói ứng dụng thành Docker image
4. **Push to Registry** - Đẩy image lên GitHub Container Registry (GHCR) & Docker Hub
5. **Update Manifests** - Cập nhật file deployment với image tag mới
6. **ArgoCD Sync** - ArgoCD tự động đồng bộ manifest mới

## 🏗️ Cấu trúc Dự Án

```
k8s/
├── .github/
│   └── workflows/
│       └── cicd-pipeline.yml          # GitHub Actions workflow
├── k8s/
│   ├── deployment.yaml                # Kubernetes Deployment
│   ├── service.yaml                   # Kubernetes Service
│   ├── configmap.yaml                 # ConfigMap
│   ├── namespace.yaml                 # Namespace & RBAC
│   ├── hpa.yaml                       # Horizontal Pod Autoscaler
│   └── servicemonitor.yaml            # Prometheus ServiceMonitor
├── argocd/
│   ├── application.yaml               # ArgoCD Application
│   └── argocd-config.yaml             # ArgoCD Configuration
├── Dockerfile                          # Multi-stage Docker build
├── pom.xml                            # Maven configuration
└── README.md                          # This file
```

## 🚀 Quick Start

### 1. Prerequisites

- [Java 11+](https://www.oracle.com/java/technologies/downloads/)
- [Maven 3.8+](https://maven.apache.org/download.cgi)
- [Docker](https://www.docker.com/products/docker-desktop)
- [Kubernetes Cluster](https://kubernetes.io/docs/setup/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [ArgoCD CLI](https://argo-cd.readthedocs.io/en/stable/cli_installation/)

### 2. Setup GitHub Repository Secrets

Vào **Settings → Secrets and variables → Actions** và thêm các secret sau:

```bash
# Docker Hub credentials
DOCKER_USERNAME=your_docker_username
DOCKER_PASSWORD=your_docker_password

# GitHub Container Registry (auto-available)
# GITHUB_TOKEN is automatically available

# Optional: Slack notifications
SLACK_WEBHOOK_URL=https://hooks.slack.com/services/YOUR/WEBHOOK/URL

# Optional: SonarQube
SONAR_TOKEN=your_sonar_token
```

### 3. Build Locally

```bash
# Clone repository
git clone https://github.com/TamDepTraii/k8s.git
cd k8s

# Build with Maven
mvn clean package

# Run tests
mvn test

# Build Docker image locally
docker build -t k8s-demo:latest .

# Run Docker container
docker run -p 8080:8080 k8s-demo:latest

# Test health endpoint
curl http://localhost:8080/actuator/health
```

### 4. Deploy Kubernetes Namespace & RBAC

```bash
# Create namespace and RBAC
kubectl apply -f k8s/namespace.yaml

# Verify
kubectl get namespace k8s-demo
kubectl get sa -n k8s-demo
```

### 5. Deploy ConfigMap

```bash
# Apply ConfigMap
kubectl apply -f k8s/configmap.yaml

# Verify
kubectl get configmap -n k8s-demo
```

### 6. Setup ArgoCD

#### 6.1 Install ArgoCD

```bash
# Create argocd namespace
kubectl create namespace argocd

# Install ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for ArgoCD to be ready
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=300s

# Get ArgoCD admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

# Port forward
kubectl port-forward svc/argocd-server -n argocd 8443:443

# Access ArgoCD: https://localhost:8443
```

#### 6.2 Configure GitHub Access (Optional)

```bash
# Create GitHub credentials secret
kubectl create secret generic github-credentials \
  --from-literal=username=your_github_username \
  --from-literal=password=your_github_token \
  -n argocd
```

#### 6.3 Deploy ArgoCD Application

```bash
# Apply ArgoCD Application manifest
kubectl apply -f argocd/application.yaml

# Verify
kubectl get applications -n argocd
kubectl describe application k8s-demo -n argocd

# Watch sync status
argocd app watch k8s-demo -n argocd
```

### 7. Manual Trigger Sync (Optional)

```bash
# Sync manually
kubectl apply -f k8s/

# Or using ArgoCD CLI
argocd app sync k8s-demo --argocd-server localhost:8443
```

## 📊 GitHub Actions Workflow

### Trigger Events

Pipeline tự động chạy khi:
- Push code lên branch `main`, `master`, hoặc `develop`
- Tạo Pull Request

### Jobs

1. **Build Job**
   - Checkout code
   - Setup Java 11
   - Build với Maven
   - Run unit tests
   - Scan với Trivy
   - Build & push Docker image
   - Update deployment manifest

2. **Deploy Job** (chỉ khi push to main)
   - Update ArgoCD manifests
   - Commit & push changes
   - Trigger ArgoCD sync

3. **Security Job**
   - Scan filesystem với Trivy
   - Upload kết quả lên GitHub Security tab

4. **Notification Job**
   - Gửi thông báo Slack (nếu có webhook)

## 🔧 Pipeline Configuration

### GitHub Actions Secrets

| Secret | Description | Required |
|--------|-------------|----------|
| `DOCKER_USERNAME` | Docker Hub username | Yes |
| `DOCKER_PASSWORD` | Docker Hub password | Yes |
| `GITHUB_TOKEN` | Auto-generated | Auto |
| `SLACK_WEBHOOK_URL` | Slack webhook URL | No |
| `SONAR_TOKEN` | SonarQube token | No |

### Environment Variables

```yaml
REGISTRY: ghcr.io
IMAGE_NAME: ${{ github.repository }}/k8s-app
```

## 📈 Kubernetes Deployment

### Deployment Strategy

- **Type**: RollingUpdate
- **maxSurge**: 1 (1 pod extra during update)
- **maxUnavailable**: 0 (zero downtime)

### Health Checks

1. **Liveness Probe** - Restarts unhealthy pods
   - Endpoint: `/actuator/health/liveness`
   - Interval: 10s
   - Timeout: 5s

2. **Readiness Probe** - Removes from load balancing
   - Endpoint: `/actuator/health/readiness`
   - Interval: 5s
   - Timeout: 3s

3. **Startup Probe** - Waits for app startup
   - Endpoint: `/actuator/health`
   - Timeout: 3s
   - Max attempts: 30

### Auto-Scaling (HPA)


