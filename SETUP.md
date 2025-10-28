# K8s Demo - CI/CD Pipeline Setup

## 📊 Pipeline Architecture

```
┌──────────────┐
│  Push Code   │
│   to Main    │
└──────┬───────┘
       │
       ▼
┌──────────────────────────┐
│  GitHub Actions (CI)     │
│  ✓ Checkout              │
│  ✓ Build with Maven      │
│  ✓ Run Tests             │
│  ✓ Build Docker Image    │
│  ✓ Push to GHCR          │
│  ✓ Update Manifest       │
│  ✓ Commit & Push         │
└──────┬───────────────────┘
       │
       ▼
┌──────────────────────────┐
│  GitHub Container        │
│  Registry (GHCR)         │
└──────┬───────────────────┘
       │
       ▼
┌──────────────────────────┐
│  ArgoCD (CD)             │
│  ✓ Watch Git Repo        │
│  ✓ Sync to K8s           │
│  ✓ Auto Deploy           │
└──────┬───────────────────┘
       │
       ▼
┌──────────────────────────┐
│  Kubernetes Cluster      │
│  k8s-demo Namespace      │
└──────────────────────────┘
```

## 🚀 Quick Start

### 1. Prerequisites
```bash
# Kubernetes cluster (Docker Desktop, Minikube, or cloud)
# kubectl installed
# Git
```

### 2. Install ArgoCD
```bash
# Create ArgoCD namespace and install
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for deployment to be ready
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=300s
```

### 3. Access ArgoCD Dashboard
```bash
# Port forward to access UI
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Open browser: https://localhost:8080
# Username: admin
# Password: (get from below)
```

### 4. Get ArgoCD Admin Password
```bash
# Decode the initial password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```

### 5. Create ArgoCD Application
```bash
# Apply the ArgoCD Application manifest
kubectl apply -f argocd/app.yaml

# Check status
kubectl get application -n argocd
argocd app get k8s-demo
```

### 6. Monitor Deployment
```bash
# Watch ArgoCD sync
argocd app watch k8s-demo

# Or check kubectl
kubectl get pods -n k8s-demo -w
kubectl get svc -n k8s-demo
```

### 7. Access Application
```bash
# Port forward to the service
kubectl port-forward svc/k8s-demo 8080:80 -n k8s-demo

# Access app
curl http://localhost:8080/actuator/health
```

## 📁 Project Structure

```
k8s/
├── src/                          # Java Spring Boot source
├── k8s/                          # Kubernetes manifests
│   ├── namespace.yaml            # Namespace: k8s-demo
│   ├── service.yaml              # Service (port 80 → 8080)
│   ├── deployment.yaml           # Deployment with health checks
│   ├── application.properties    # Spring Boot config
│   └── kustomization.yaml        # Kustomize overlays
├── argocd/
│   └── application.yaml          # ArgoCD Application CRD
├── .github/workflows/
│   └── cicd-pipeline.yml         # GitHub Actions workflow
├── Dockerfile                    # Multi-stage Docker build
├── pom.xml                       # Maven dependencies
├── README.md                     # Project overview
└── SETUP.md                      # This file
```

## 🔄 How It Works

### GitHub Actions Workflow
1. **Trigger**: Push to `main` branch
2. **Build Stage**:
   - Checkout code
   - Setup Java 11
   - Build with Maven (compile + package)
   - Run unit tests
3. **Docker Stage**:
   - Setup Docker Buildx
   - Login to GHCR using GITHUB_TOKEN
   - Build multi-stage Docker image
   - Push to GHCR with tags: `{sha}` and `latest`
4. **Update Stage**:
   - Update `k8s/deployment.yaml` with new image tag
   - Commit and push manifest changes to repo
5. **ArgoCD Detection**:
   - ArgoCD watches the repo
   - Detects manifest changes
   - Auto-syncs to Kubernetes cluster

### Kustomize Configuration
```yaml
# kustomization.yaml applies:
- Namespace: k8s-demo
- Labels: app=k8s-demo, managed-by=argocd
- Image: ghcr.io/tamdeptraii/k8s/k8s-app:latest
- Resources: namespace, service, deployment
```

### ArgoCD Auto-Sync Settings
```yaml
syncPolicy:
  automated:
    prune: true        # Delete resources not in repo
    selfHeal: true     # Revert manual changes
  syncOptions:
    - CreateNamespace=true  # Auto-create namespace
```

## 🔍 Troubleshooting

### Check ArgoCD Status
```bash
# List applications
argocd app list

# Get detailed status
argocd app get k8s-demo

# Watch sync progress
argocd app wait k8s-demo --sync

# View logs
kubectl logs -n argocd -l app.kubernetes.io/name=argocd-server
```

### Check Application Deployment
```bash
# Get pods
kubectl get pods -n k8s-demo

# Get pod details
kubectl describe pod -n k8s-demo -l app=k8s-demo

# View logs
kubectl logs -n k8s-demo -l app=k8s-demo -f

# Check events
kubectl get events -n k8s-demo
```

### Debug Image Pull Issues
```bash
# Check image in deployment
kubectl get deployment k8s-demo -n k8s-demo -o yaml | grep image

# Verify GHCR image exists
curl https://ghcr.io/v2/tamdeptraii/k8s/k8s-app/tags/list

# Check image pull events
kubectl describe pod <pod-name> -n k8s-demo
```

### Force Sync
```bash
argocd app sync k8s-demo --force
```

## 📝 Common Commands

```bash
# Git
git add .
git commit -m "message"
git push origin main

# Maven
mvn clean package
mvn test
mvn clean install

# Docker (local build)
docker build -t k8s-demo:latest .
docker run -p 8080:8080 k8s-demo:latest

# Kubernetes
kubectl get all -n k8s-demo
kubectl logs -f deployment/k8s-demo -n k8s-demo
kubectl port-forward svc/k8s-demo 8080:80 -n k8s-demo

# ArgoCD
argocd app get k8s-demo
argocd app sync k8s-demo
argocd app delete k8s-demo
```

## 🎯 Next Steps

1. **Customize deployment**:
   - Update `k8s/deployment.yaml` with your app config
   - Adjust replicas, resources, ports as needed

2. **Add monitoring**:
   - Deploy Prometheus to monitor metrics
   - Create Grafana dashboards

3. **Setup notifications**:
   - Configure ArgoCD notifications (Slack, email, etc.)
   - Add commit status checks to GitHub

4. **Production setup**:
   - Use separate ArgoCD applications for staging/prod
   - Implement GitOps workflow with pull requests
   - Add RBAC policies in ArgoCD

## 📚 References

- [ArgoCD Docs](https://argo-cd.readthedocs.io/)
- [Kubernetes Docs](https://kubernetes.io/docs/)
- [GitHub Actions](https://docs.github.com/en/actions)
- [Kustomize](https://kustomize.io/)

