
**Output**: Git repository updated, ArgoCD automatically syncs

#### 3. Security Scan Job

**Purpose**: Scan for vulnerabilities

**Runs**: Trivy filesystem scan
**Output**: Results uploaded to GitHub Security tab

#### 4. Notification Job

**Purpose**: Send Slack notifications

**Triggers**: After all jobs complete
**Output**: Slack message with pipeline status

### Environment Variables

```yaml
env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}/k8s-app
```

### Key Features

✅ Multi-stage Docker build
✅ Caching for faster builds
✅ Push to multiple registries
✅ Security scanning with Trivy
✅ Automatic manifest updates
✅ Slack notifications

## 🎛️ ArgoCD Configuration

### Application Manifest Structure

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: k8s-demo
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/TamDepTraii/k8s.git
    targetRevision: main
    path: k8s
  destination:
    server: https://kubernetes.default.svc
    namespace: k8s-demo
  syncPolicy:
    automated:
      prune: true      # Delete resources not in Git
      selfHeal: true   # Auto-sync when cluster changes
    retry:
      limit: 5
      backoff:
        duration: 5s
        factor: 2
```

### Sync Strategies

#### 1. Manual Sync
```bash
# Manually sync application
argocd app sync k8s-demo
```

#### 2. Automatic Sync
```yaml
syncPolicy:
  automated:
    prune: true
    selfHeal: true
```

#### 3. Webhook Trigger
```bash
# GitHub webhook sends events to ArgoCD
# ArgoCD automatically syncs on new commits
```

### Prune Strategy

**What is Prune?**
- Deletes Kubernetes resources that are not in Git
- Ensures Git is the single source of truth

**Enable Prune**:
```yaml
syncPolicy:
  automated:
    prune: true
```

## 📊 Pipeline Execution Flow

### Scenario: Developer Commits Code

```
1. Developer: git push origin main
   ↓
2. GitHub: Triggers workflow (cicd-pipeline.yml)
   ↓
3. Build Job:
   - Checkout code
   - mvn clean package
   - Build Docker image: ghcr.io/user/k8s-app:sha-abc123
   - Push to GHCR & Docker Hub
   ↓
4. Deploy Job:
   - Update k8s/deployment.yaml image: sha-abc123
   - git add, commit, push
   ↓
5. Git Webhook:
   - Notifies ArgoCD of changes
   ↓
6. ArgoCD:
   - Detects new commit
   - Compares Git state vs Cluster state
   - Applies changes to cluster
   ↓
7. Kubernetes:
   - Rolling update deployment
   - Pulls new image
   - Creates new pods
   - Health checks pass
   - Old pods terminated
   ↓
8. Result: New version deployed!
```

## 🔐 Security Considerations

### Image Security

✅ **Non-root user**: Container runs as uid 1000
✅ **Read-only filesystem**: Root filesystem is read-only
✅ **Dropped capabilities**: All Linux capabilities dropped
✅ **Security context**: Pod and container security context defined

### Registry Security

✅ **GitHub Container Registry**: Private by default
✅ **Credentials**: Stored as GitHub secrets
✅ **Image scanning**: Trivy scans for vulnerabilities
✅ **Pull policies**: IfNotPresent to avoid unnecessary pulls

### RBAC

```yaml
# Service account with minimal permissions
serviceAccountName: k8s-demo

# Role limited to reading configmaps
rules:
- apiGroups: [""]
  resources: ["configmaps"]
  verbs: ["get", "watch", "list"]
```

## 📈 Monitoring & Observability

### Application Metrics

```bash
# Health endpoint
curl http://localhost:8080/actuator/health

# Liveness probe
curl http://localhost:8080/actuator/health/liveness

# Readiness probe
curl http://localhost:8080/actuator/health/readiness

# Prometheus metrics
curl http://localhost:8080/actuator/prometheus
```

### Kubernetes Monitoring

```bash
# Watch deployment status
kubectl rollout status deployment/k8s-demo -n k8s-demo

# View pod logs
kubectl logs -f deployment/k8s-demo -n k8s-demo

# Describe pod for events
kubectl describe pod <pod-name> -n k8s-demo

# Check resource usage
kubectl top pods -n k8s-demo
kubectl top nodes
```

### ArgoCD Monitoring

```bash
# Watch application sync
argocd app watch k8s-demo

# Get application status
argocd app get k8s-demo

# View sync history
argocd app history k8s-demo
```

## 🧪 Testing the Pipeline

### Local Testing

```bash
# 1. Build locally
mvn clean package

# 2. Build Docker image
docker build -t k8s-demo:latest .

# 3. Run Docker container
docker run -p 8080:8080 k8s-demo:latest

# 4. Test endpoints
curl http://localhost:8080/actuator/health
curl http://localhost:8080/actuator/info
```

### Kubernetes Testing

```bash
# 1. Deploy to Kubernetes
bash scripts/deploy.sh

# 2. Wait for deployment
kubectl rollout status deployment/k8s-demo -n k8s-demo

# 3. Port forward
kubectl port-forward svc/k8s-demo -n k8s-demo 8080:80

# 4. Test
curl http://localhost:8080/actuator/health
```

### ArgoCD Testing

```bash
# 1. Deploy ArgoCD application
kubectl apply -f argocd/application.yaml

# 2. Monitor sync
argocd app watch k8s-demo

# 3. Make Git change
echo "# test" >> README.md
git add .
git commit -m "test"
git push

# 4. Verify ArgoCD syncs automatically
```

## 🚨 Troubleshooting

### GitHub Actions Failing

**Problem**: Build job fails

```bash
# Check workflow logs
# Go to: Repository → Actions → Latest run → View logs

# Common causes:
- Java/Maven version mismatch
- Docker build context issues
- Missing secrets
```

**Solution**:
```bash
# Test locally first
mvn clean package
docker build -t k8s-demo:latest .

# Check secrets are configured
# Go to Settings → Secrets
```

### Docker Push Failing

**Problem**: Image push fails

```bash
# Error: "invalid reference format"
# Solution: Check IMAGE_NAME format
REGISTRY: ghcr.io
IMAGE_NAME: tamdeptraii/k8s-demo/k8s-app
```

### ArgoCD Not Syncing

**Problem**: Application stuck in "Syncing" state

```bash
# Check logs
kubectl logs -n argocd deployment/argocd-application-controller

# Describe application
kubectl describe application k8s-demo -n argocd

# Manual sync
argocd app sync k8s-demo --force
```

**Common causes**:
- Missing namespace
- RBAC issues
- Invalid manifests
- Image pull failures

### Pod Crashing

**Problem**: Pods not starting

```bash
# Check pod status
kubectl get pods -n k8s-demo
kubectl describe pod <pod-name> -n k8s-demo

# View logs
kubectl logs <pod-name> -n k8s-demo

# Check events
kubectl get events -n k8s-demo --sort-by='.lastTimestamp'
```

**Common causes**:
- Image pull failures
- Health probe timeouts
- ConfigMap missing
- Resource limits exceeded

## 📚 References

- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [ArgoCD Docs](https://argo-cd.readthedocs.io/)
- [Kubernetes Docs](https://kubernetes.io/docs/)
- [Spring Boot Docs](https://spring.io/projects/spring-boot)

## 💡 Best Practices

### Git Strategy

✅ Use main branch for production deployments
✅ Use develop branch for development
✅ Use feature branches for new features
✅ Require pull request reviews before merge

### Kubernetes Best Practices

✅ Define resource requests and limits
✅ Use health probes (liveness, readiness, startup)
✅ Enable security contexts
✅ Use namespaces for isolation
✅ Configure RBAC

### ArgoCD Best Practices

✅ Use GitOps: Git as source of truth
✅ Enable automatic pruning
✅ Enable self-healing
✅ Monitor sync status
✅ Use different projects for different teams

### CI/CD Best Practices

✅ Test early and often
✅ Scan for vulnerabilities
✅ Use multi-stage builds
✅ Tag images properly
✅ Maintain audit logs

---

Tài liệu này được cập nhật lần cuối: 2025-10-27
# Hướng Dẫn Chi Tiết CI/CD với GitHub Actions và ArgoCD

## 📖 Mục Lục

1. [Kiến Trúc Pipeline](#kiến-trúc-pipeline)
2. [Cài Đặt Từng Bước](#cài-đặt-từng-bước)
3. [GitHub Actions Configuration](#github-actions-configuration)
4. [ArgoCD Configuration](#argocd-configuration)
5. [Giám Sát và Troubleshooting](#giám-sát-và-troubleshooting)

## 🏗️ Kiến Trúc Pipeline

```
Developer Push Code
    ↓
GitHub Actions CI/CD Pipeline
    ├── Build & Test (Maven)
    ├── Security Scan (Trivy)
    ├── Build Docker Image
    ├── Push to Registry (GHCR & Docker Hub)
    └── Update Manifests
        ↓
    Git Repository
        ↓
    ArgoCD (watches repository)
        ├── Detect changes
        ├── Validate manifests
        ├── Apply to Kubernetes
        └── Report status
            ↓
        Kubernetes Cluster
            ├── Pull image
            ├── Create pods
            ├── Health checks
            └── Running application
```

## 🛠️ Cài Đặt Từng Bước

### Bước 1: Prepare GitHub Repository

```bash
# Clone repository (nếu chưa có)
git clone https://github.com/TamDepTraii/k8s.git
cd k8s

# Configure git
git config user.email "your-email@example.com"
git config user.name "Your Name"
```

### Bước 2: Setup GitHub Secrets

1. Vào **GitHub Repository → Settings → Secrets and variables → Actions**

2. Thêm các secret sau:

#### Docker Hub Credentials
```
Name: DOCKER_USERNAME
Value: your_docker_hub_username

Name: DOCKER_PASSWORD
Value: your_docker_hub_password (Personal Access Token)
```

#### Slack Notification (Optional)
```
Name: SLACK_WEBHOOK_URL
Value: https://hooks.slack.com/services/YOUR/WEBHOOK/URL
```

### Bước 3: Setup Kubernetes Cluster

```bash
# For local development, use Docker Desktop or Minikube

# Minikube setup
minikube start --driver=docker --memory=4096 --cpus=4

# Or Docker Desktop: Enable Kubernetes in settings

# Verify
kubectl cluster-info
kubectl get nodes
```

### Bước 4: Install ArgoCD

```bash
# Create argocd namespace
kubectl create namespace argocd

# Install ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for installation
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=300s

# Get admin password
ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo "Admin Password: $ARGOCD_PASSWORD"

# Port forward to access ArgoCD UI
kubectl port-forward svc/argocd-server -n argocd 8443:443

# Access: https://localhost:8443
# Username: admin
# Password: (from above command)
```

### Bước 5: Configure ArgoCD Repository Access

#### Option A: Using Personal Access Token

```bash
# Create GitHub PAT secret
kubectl create secret generic github-credentials \
  --from-literal=username=your_github_username \
  --from-literal=password=your_github_token \
  -n argocd

# Or using SSH key
kubectl create secret generic argocd-repo-ssh \
  --from-file=ssh-privatekey=$HOME/.ssh/id_rsa \
  -n argocd
```

### Bước 6: Deploy ArgoCD Application

```bash
# Apply ArgoCD application manifest
kubectl apply -f argocd/application.yaml

# Verify
kubectl get applications -n argocd
kubectl describe application k8s-demo -n argocd

# Watch status
argocd app watch k8s-demo --argocd-server localhost:8443 --auth-token $(argocd account generate-token --account admin)
```

## 📋 GitHub Actions Configuration

### Workflow File Location

```
.github/workflows/cicd-pipeline.yml
```

### Workflow Triggers

```yaml
on:
  push:
    branches:
      - main
      - master
      - develop
  pull_request:
    branches:
      - main
      - master
```

### Jobs Explanation

#### 1. Build Job

**Purpose**: Build application, run tests, build Docker image

**Steps**:
1. Checkout code
2. Setup Java 11
3. Build with Maven
4. Run unit tests
5. Login to registries
6. Build and push Docker image

**Output**: Docker image pushed to GHCR and Docker Hub

#### 2. Deploy Job (Runs after build on main branch)

**Purpose**: Update Kubernetes manifests and trigger ArgoCD

**Steps**:
1. Checkout code
2. Update deployment.yaml with new image tag
3. Commit and push changes
4. Trigger ArgoCD sync

