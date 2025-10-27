# 📚 CI/CD Pipeline with GitHub Actions & ArgoCD - Complete Summary

## 🎯 Mục Đích Dự Án

Dự án này demo **CI/CD Pipeline** hoàn chỉnh cho ứng dụng **Spring Boot trên Kubernetes** sử dụng:
- **GitHub Actions** cho Continuous Integration
- **ArgoCD** cho Continuous Deployment (GitOps)
- **Kubernetes** cho orchestration
- **Docker** cho containerization
- **Prometheus** cho monitoring

---

## 📁 Files Được Tạo

### 1. GitHub Actions Workflows (`.github/workflows/`)

#### `cicd-pipeline.yml` ⭐
Pipeline chính bao gồm:
- **Build Job**: Build, test, scan, build docker image, push to registry
- **Deploy Job**: Update manifests, commit & push, trigger ArgoCD
- **Security Job**: Scan vulnerabilities with Trivy
- **Notification Job**: Slack notifications

#### `code-quality.yml`
Code quality checks:
- SonarQube analysis
- Checkstyle code style check
- JaCoCo test coverage
- Codecov upload

### 2. Docker Files

#### `Dockerfile`
Multi-stage production-ready build:
- Build stage: Maven build
- Runtime stage: Slim JRE, non-root user, security hardening
- Health checks
- Optimized JVM parameters

#### `docker-compose.yml`
Local development environment:
- Application container
- Prometheus monitoring
- Grafana dashboards

### 3. Kubernetes Manifests (`k8s/`)

#### `namespace.yaml`
- Namespace creation
- ServiceAccount setup
- RBAC (Role & RoleBinding)

#### `configmap.yaml`
- Application properties
- Logging configuration
- Environment-specific settings

#### `deployment.yaml`
- 3 replicas
- Rolling update strategy
- Health probes (liveness, readiness, startup)
- Security context (non-root user)
- Resource requests & limits
- Prometheus annotations

#### `service.yaml`
- ClusterIP service
- Port mapping
- Service discovery labels

#### `hpa.yaml`
- Auto-scaling configuration
- Min/Max replicas
- CPU & Memory metrics
- Scaling policies

#### `servicemonitor.yaml`
- Prometheus integration
- Metrics scraping config

#### `kustomization.yaml`
- Kustomize overlays
- Common labels & annotations
- Image customization

### 4. ArgoCD Configuration (`argocd/`)

#### `application.yaml`
ArgoCD Application manifest:
- Git repository source
- Automatic sync policy
- Auto-prune enabled
- Retry strategy

#### `argocd-config.yaml`
ArgoCD configuration:
- Repository credentials
- Webhook configuration

### 5. Scripts (`scripts/`)

#### `setup-argocd.sh`
Automated ArgoCD installation:
- Create namespace
- Install ArgoCD
- Get admin password
- Port forwarding

#### `deploy.sh`
Deploy to Kubernetes:
- Apply all manifests
- Wait for deployment
- Display status

#### `setup-env.sh`
Complete environment setup:
- Check prerequisites
- Build application
- Build Docker image
- Deploy to Kubernetes

#### `cleanup.sh`
Cleanup resources:
- Delete ArgoCD application
- Delete Kubernetes namespace
- Remove Docker images

### 6. Helm Configuration (`helm/`)

#### `values.yaml`
Helm values for template customization:
- Image configuration
- Resource limits
- Auto-scaling settings
- Health probe configuration

### 7. Monitoring (`monitoring/`)

#### `prometheus.yml`
Prometheus configuration:
- Global settings
- Scrape configs for app, docker, kubernetes

#### `alert-rules.yml`
Prometheus alert rules:
- Application availability
- CPU & Memory usage
- Error rates
- Response times
- Database connections

### 8. Makefile
Convenient commands:
- Build, test, clean
- Docker build & push
- Kubernetes deploy
- ArgoCD setup
- Utilities for status checking

### 9. Documentation (`docs/`)

#### `CICD-GUIDE.md`
Detailed guide covering:
- Architecture overview
- Step-by-step setup
- Workflow explanation
- Best practices

#### `COMMANDS.md`
Useful commands for:
- Kubernetes
- ArgoCD
- Docker
- Maven
- GitHub Actions

#### `TROUBLESHOOTING.md`
Common issues & solutions:
- Build issues
- Docker problems
- Kubernetes errors
- ArgoCD issues

#### `PROJECT-STRUCTURE.md`
Project layout & file descriptions

### 10. Other Files

#### `.gitignore`
Comprehensive Git ignore rules

#### `docker-compose.yml`
Local development environment

#### Configuration Files
- `pom.xml` - Maven configuration
- `.github/workflows/code-quality.yml` - Code quality checks

---

## 🔄 Pipeline Flow

```
Developer commits code
    ↓
GitHub webhook triggers workflow
    ↓
GitHub Actions Pipeline:
    1. Build & Test (Maven)
    2. Security Scan (Trivy)
    3. Build Docker Image
    4. Push to GHCR & Docker Hub
    5. Update k8s/deployment.yaml
    6. Commit & Push
    ↓
Git Repository Updated
    ↓
ArgoCD Webhook Triggered
    ↓
ArgoCD:
    1. Detect changes in Git
    2. Compare with cluster state
    3. Apply changes
    ↓
Kubernetes Cluster:
    1. Pull new image
    2. Create/Update pods
    3. Health checks
    4. Rolling update
    ↓
Application Running!
```

---

## 🚀 Quick Start

### 1. Setup GitHub Repository

```bash
# Clone repo
git clone https://github.com/TamDepTraii/k8s.git
cd k8s

# Add GitHub Secrets
# Go to: Settings → Secrets and variables → Actions
# Add:
# - DOCKER_USERNAME
# - DOCKER_PASSWORD
# - (Optional) SLACK_WEBHOOK_URL
```

### 2. Setup Kubernetes Cluster

```bash
# Using Docker Desktop or Minikube
kubectl cluster-info

# Create namespace
kubectl apply -f k8s/namespace.yaml
```

### 3. Setup ArgoCD

```bash
# Using provided script
bash scripts/setup-argocd.sh

# Or manually
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

### 4. Deploy with ArgoCD

```bash
# Apply ArgoCD application
kubectl apply -f argocd/application.yaml
```

### 5. Push Code to Trigger Pipeline

```bash
git add .
git commit -m "Initial commit"
git push origin main
```

---

## 📊 What's Included

### Build & Test
✅ Maven build
✅ Unit tests
✅ Integration tests (ready)
✅ Code quality checks

### Containerization
✅ Multi-stage Docker build
✅ Non-root user
✅ Minimal image size
✅ Security hardening

### Kubernetes
✅ Deployment with rolling updates
✅ Health probes (liveness, readiness, startup)
✅ Resource limits & requests
✅ Auto-scaling (HPA)
✅ ConfigMap management
✅ RBAC setup

### Security
✅ Trivy vulnerability scanning
✅ Pod security context
✅ Non-root containers
✅ Read-only filesystem
✅ Network policies (ready)

### Monitoring
✅ Prometheus metrics
✅ Prometheus alerts
✅ Grafana dashboards (ready)
✅ Health endpoints

### CI/CD
✅ GitHub Actions automation
✅ Docker image push
✅ Manifest updates
✅ ArgoCD GitOps
✅ Automated notifications

---

## 🔑 Key Features

### 1. GitOps Approach
- Git is the single source of truth
- All changes tracked in Git
- Automatic deployment on push

### 2. Automated Testing
- Unit tests in pipeline
- Code quality checks
- Security scanning

### 3. Scalability
- Horizontal Pod Autoscaler
- Auto-scales based on CPU & memory
- Min 3, Max 10 replicas

### 4. Reliability
- Health checks (3 types)
- Graceful shutdown
- Rolling updates (zero downtime)

### 5. Observability
- Prometheus metrics
- Health endpoints
- Structured logging
- Event tracking

### 6. Security
- Non-root containers
- Minimal image
- RBAC configured
- Vulnerability scanning

---

## 📚 Documentation

| Document | Purpose |
|----------|---------|
| README-CICD.md | Main CI/CD guide |
| docs/CICD-GUIDE.md | Detailed setup guide |
| docs/COMMANDS.md | Useful commands |
| docs/TROUBLESHOOTING.md | Problem solving |
| docs/PROJECT-STRUCTURE.md | Project layout |

---

## 🛠️ Technology Stack

| Component | Technology |
|-----------|-----------|
| Language | Java 11 |
| Framework | Spring Boot 2.7 |
| Build Tool | Maven 3.8 |
| Container | Docker |
| Orchestration | Kubernetes |
| GitOps | ArgoCD |
| CI/CD | GitHub Actions |
| Monitoring | Prometheus |
| Visualization | Grafana |
| Package Manager | Helm (optional) |
| Overlay Manager | Kustomize (optional) |

---

## 🎓 Learning Resources

- [Spring Boot on Kubernetes](https://spring.io/guides/topicals/spring-on-kubernetes)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)
- [Kubernetes Best Practices](https://kubernetes.io/docs/concepts/configuration/overview/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Push and create a Pull Request
5. Changes will trigger CI/CD pipeline

---

## 📞 Support

- Check `docs/TROUBLESHOOTING.md` for common issues
- Review logs: `kubectl logs deployment/k8s-demo -n k8s-demo`
- Check GitHub Actions logs for pipeline errors
- ArgoCD logs: `kubectl logs -n argocd deployment/argocd-application-controller`

---

## 📝 License

MIT License

---

## 👨‍💼 Author

**TamDepTraii** - DevOps Engineer

GitHub: https://github.com/TamDepTraii

---

## ✅ Checklist untuk Production

- [ ] Configure GitHub secrets
- [ ] Setup Kubernetes cluster
- [ ] Install ArgoCD
- [ ] Create Git repository for manifests
- [ ] Configure webhook (optional)
- [ ] Setup Prometheus & Grafana
- [ ] Configure alerting
- [ ] Test failover scenarios
- [ ] Document runbooks
- [ ] Setup backup strategy
- [ ] Configure logging aggregation
- [ ] Setup rate limiting
- [ ] Configure network policies
- [ ] Enable pod security policies
- [ ] Setup disaster recovery

---

## 🔮 Future Enhancements

- [ ] Add Istio service mesh
- [ ] Add Kyverno policy management
- [ ] Add Sealed Secrets for sensitive data
- [ ] Add Tekton for advanced pipelines
- [ ] Add Flux as alternative to ArgoCD
- [ ] Add Falco for runtime security
- [ ] Add Velero for backup/restore
- [ ] Add external secrets management

---

**Last Updated**: 2025-10-27

---

Made with ❤️ by TamDepTraii

