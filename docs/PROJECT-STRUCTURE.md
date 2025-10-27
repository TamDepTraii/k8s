# K8s Demo Application - Project Structure

## 📁 Directory Layout

```
k8s/
├── .github/
│   └── workflows/
│       ├── cicd-pipeline.yml          # Main CI/CD pipeline
│       └── code-quality.yml           # Code quality checks
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/example/k8s/
│   │   │       ├── K8sApplication.java
│   │   │       └── controller/
│   │   │           └── TestController.java
│   │   └── resources/
│   │       └── application.properties
│   └── test/
│       └── java/
│           └── com/example/k8s/
│               └── K8sApplicationTests.java
├── k8s/                               # Kubernetes manifests
│   ├── namespace.yaml                 # Namespace & RBAC setup
│   ├── configmap.yaml                 # Application configuration
│   ├── deployment.yaml                # Deployment manifest
│   ├── service.yaml                   # Service manifest
│   ├── hpa.yaml                       # Horizontal Pod Autoscaler
│   ├── servicemonitor.yaml            # Prometheus monitoring
│   └── kustomization.yaml             # Kustomize configuration
├── argocd/
│   ├── application.yaml               # ArgoCD Application manifest
│   └── argocd-config.yaml             # ArgoCD configuration
├── helm/
│   ├── values.yaml                    # Helm values
│   └── templates/                     # Helm templates (optional)
├── scripts/
│   ├── setup-argocd.sh                # ArgoCD setup script
│   ├── deploy.sh                      # Deployment script
│   ├── setup-env.sh                   # Environment setup
│   └── cleanup.sh                     # Cleanup script
├── docs/
│   ├── CICD-GUIDE.md                  # Detailed CI/CD guide
│   └── COMMANDS.md                    # Useful commands
├── monitoring/
│   └── prometheus.yml                 # Prometheus configuration
├── Dockerfile                         # Multi-stage Docker build
├── docker-compose.yml                 # Docker Compose for local dev
├── pom.xml                            # Maven configuration
├── Makefile                           # Make commands
├── README.md                          # Original README
├── README-CICD.md                     # CI/CD README
└── .gitignore                         # Git ignore rules
```

## 📝 Files Description

### GitHub Actions Workflows
- **cicd-pipeline.yml**: Main pipeline that builds, tests, and deploys the application
- **code-quality.yml**: Code quality checks with SonarQube and test coverage

### Kubernetes Manifests
- **namespace.yaml**: Namespace, ServiceAccount, RBAC Role, and RoleBinding
- **configmap.yaml**: Application configuration and properties
- **deployment.yaml**: Pod template, health probes, security context
- **service.yaml**: ClusterIP service for internal communication
- **hpa.yaml**: Horizontal Pod Autoscaler for auto-scaling
- **servicemonitor.yaml**: Prometheus metrics scraping configuration
- **kustomization.yaml**: Kustomize overlays and patches

### ArgoCD Configuration
- **application.yaml**: ArgoCD Application manifest for GitOps deployment
- **argocd-config.yaml**: ArgoCD configuration and credentials

### Helm Configuration
- **values.yaml**: Default Helm values for customization

### Scripts
- **setup-argocd.sh**: Automated ArgoCD installation and setup
- **deploy.sh**: Deploy manifests to Kubernetes
- **setup-env.sh**: Complete environment setup
- **cleanup.sh**: Cleanup resources

### Documentation
- **CICD-GUIDE.md**: Comprehensive CI/CD setup guide
- **COMMANDS.md**: Useful kubectl, docker, and argocd commands

### Build & Configuration
- **Dockerfile**: Multi-stage build for production-ready image
- **docker-compose.yml**: Local development environment with Prometheus and Grafana
- **pom.xml**: Maven project configuration
- **Makefile**: Convenient make commands for common tasks

## 🔄 Workflow

### 1. Local Development
```bash
make local-build   # Build and package locally
make docker-run    # Run Docker container
```

### 2. Push to GitHub
```bash
git add .
git commit -m "feature: new feature"
git push origin main
```

### 3. GitHub Actions Pipeline
- Triggers on push to main
- Builds Java application
- Runs tests
- Scans for vulnerabilities
- Builds Docker image
- Pushes to registries
- Updates Kubernetes manifests

### 4. ArgoCD Deployment
- Watches Git repository
- Detects manifest changes
- Deploys to Kubernetes cluster
- Maintains desired state

### 5. Kubernetes Cluster
- Pulls Docker image
- Creates/updates pods
- Performs health checks
- Auto-scales based on metrics

## 🔐 Security Files

- `.github/workflows/code-quality.yml` - Code scanning
- `k8s/namespace.yaml` - RBAC policies
- `Dockerfile` - Non-root user, read-only filesystem

## 📊 Monitoring Files

- `k8s/servicemonitor.yaml` - Prometheus integration
- `docker-compose.yml` - Local Prometheus and Grafana
- `helm/values.yaml` - Metrics configuration

## 🚀 Getting Started

1. **Clone repository**
   ```bash
   git clone https://github.com/TamDepTraii/k8s.git
   cd k8s
   ```

2. **Setup environment**
   ```bash
   make setup
   ```

3. **Deploy to Kubernetes**
   ```bash
   make deploy
   ```

4. **Setup ArgoCD**
   ```bash
   make setup-argocd
   make deploy-argocd
   ```

5. **Access application**
   ```bash
   make port-forward
   # Visit http://localhost:8080
   ```

## 🔗 Important Paths

- **Source Code**: `src/main/java/com/example/k8s/`
- **Kubernetes Manifests**: `k8s/`
- **Workflows**: `.github/workflows/`
- **Scripts**: `scripts/`
- **Documentation**: `docs/`
- **Configuration**: `helm/`, `argocd/`

