# Workflow Diagram

## CI/CD Pipeline Flow

```
┌─────────────────────────────────────────────────────────────────────┐
│                       GITHUB ACTIONS (CI)                           │
├─────────────────────────────────────────────────────────────────────┤
│ Trigger: git push to main                                           │
│                                                                     │
│ ┌──────────────────────────────────────────────────────────────┐   │
│ │ 1. Checkout Code                                             │   │
│ └──────────────────┬───────────────────────────────────────────┘   │
│                    │                                               │
│ ┌──────────────────▼───────────────────────────────────────────┐   │
│ │ 2. Setup JDK 11 + Maven Cache                               │   │
│ └──────────────────┬───────────────────────────────────────────┘   │
│                    │                                               │
│ ┌──────────────────▼───────────────────────────────────────────┐   │
│ │ 3. Build & Test (mvn clean package + mvn test)             │   │
│ └──────────────────┬───────────────────────────────────────────┘   │
│                    │                                               │
│ ┌──────────────────▼───────────────────────────────────────────┐   │
│ │ 4. Build Docker Image (Multi-stage)                         │   │
│ │    └─ Stage 1: Maven build on openjdk:11                    │   │
│ │    └─ Stage 2: Runtime on openjdk:11-jre-slim              │   │
│ └──────────────────┬───────────────────────────────────────────┘   │
│                    │                                               │
│ ┌──────────────────▼───────────────────────────────────────────┐   │
│ │ 5. Push to GHCR                                              │   │
│ │    └─ ghcr.io/tamdeptraii/k8s/k8s-app:{sha}                 │   │
│ │    └─ ghcr.io/tamdeptraii/k8s/k8s-app:latest               │   │
│ └──────────────────┬───────────────────────────────────────────┘   │
│                    │                                               │
│ ┌──────────────────▼───────────────────────────────────────────┐   │
│ │ 6. Update k8s/deployment.yaml                               │   │
│ │    └─ Replace image tag with {sha}                          │   │
│ │    └─ Commit: "chore: update image tag to {sha}"           │   │
│ │    └─ Push to main branch                                   │   │
│ └──────────────────┬───────────────────────────────────────────┘   │
└────────────────────┼──────────────────────────────────────────────┘
                     │
                     ▼
        ┌──────────────────────────┐
        │  GitHub Repository       │
        │  (Updated Manifests)     │
        └──────────────┬───────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────────────┐
│                    ARGOCD (CD - GITOPS)                             │
├─────────────────────────────────────────────────────────────────────┤
│ Watch: https://github.com/TamDepTraii/k8s                          │
│ Path: k8s/                                                          │
│                                                                     │
│ ┌──────────────────────────────────────────────────────────────┐   │
│ │ 1. Detect changes in Git repo (auto sync enabled)           │   │
│ └──────────────────┬───────────────────────────────────────────┘   │
│                    │                                               │
│ ┌──────────────────▼───────────────────────────────────────────┐   │
│ │ 2. Validate manifests with Kustomize                        │   │
│ │    └─ Apply namespace: k8s-demo                             │   │
│ │    └─ Apply labels: app=k8s-demo, managed-by=argocd         │   │
│ │    └─ Apply resources: namespace, service, deployment       │   │
│ └──────────────────┬───────────────────────────────────────────┘   │
│                    │                                               │
│ ┌──────────────────▼───────────────────────────────────────────┐   │
│ │ 3. Sync Policy                                               │   │
│ │    └─ automated.prune: true (delete removed resources)       │   │
│ │    └─ automated.selfHeal: true (revert manual changes)      │   │
│ │    └─ CreateNamespace: true (auto-create k8s-demo)          │   │
│ └──────────────────┬───────────────────────────────────────────┘   │
│                    │                                               │
│ ┌──────────────────▼───────────────────────────────────────────┐   │
│ │ 4. Apply to Kubernetes Cluster                              │   │
│ │    └─ kubectl apply -k k8s/                                 │   │
│ └──────────────────┬───────────────────────────────────────────┘   │
└────────────────────┼──────────────────────────────────────────────┘
                     │
                     ▼
        ┌──────────────────────────┐
        │ Kubernetes Cluster       │
        │ Namespace: k8s-demo      │
        │                          │
        │ ┌────────────────────┐   │
        │ │  Service (port 80) │   │
        │ │      ↓             │   │
        │ │ Deployment         │   │
        │ │ (replicas: 2)      │   │
        │ │   Pod 1            │   │
        │ │   Pod 2            │   │
        │ └────────────────────┘   │
        └──────────────────────────┘
```

## Deployment Manifest Structure

```
k8s/
├── namespace.yaml
│   └── kind: Namespace
│       metadata:
│         name: k8s-demo
│
├── service.yaml
│   └── kind: Service
│       spec:
│         ports:
│           - port: 80
│             targetPort: 8080  (Spring Boot)
│         selector:
│           app: k8s-demo
│
├── deployment.yaml
│   └── kind: Deployment
│       spec:
│         replicas: 2
│         selector:
│           app: k8s-demo
│         template:
│           containers:
│             - image: ghcr.io/tamdeptraii/k8s/k8s-app:{TAG}
│               port: 8080
│
└── kustomization.yaml
    └── Resources:
        - namespace.yaml
        - service.yaml
        - deployment.yaml
        
        Labels applied to all:
        - app: k8s-demo
        - managed-by: argocd
```

## Image Update Flow

```
┌──────────────────────────────────────────┐
│ GitHub Actions builds new image          │
│ Tag: ghcr.io/.../k8s-app:abc123def456   │
└────────────┬─────────────────────────────┘
             │
             ▼
┌──────────────────────────────────────────┐
│ Update deployment.yaml                   │
│ FROM: image: ghcr.io/.../k8s-app:latest │
│ TO:   image: ghcr.io/.../k8s-app:abc123 │
└────────────┬─────────────────────────────┘
             │
             ▼
┌──────────────────────────────────────────┐
│ Commit to Git                            │
│ Message: "chore: update image tag..."    │
└────────────┬─────────────────────────────┘
             │
             ▼
┌──────────────────────────────────────────┐
│ ArgoCD detects change                    │
│ Pulls new manifest from Git              │
└────────────┬─────────────────────────────┘
             │
             ▼
┌──────────────────────────────────────────┐
│ Sync to Kubernetes                       │
│ kubectl set image deployment/k8s-demo ... │
└──────────────────────────────────────────┘
```

## Status Monitoring

```
┌─────────────────────────────────────────────────┐
│ GitHub Actions Dashboard                        │
│ .github/workflows/cicd-pipeline.yml             │
│ ✓ Build complete: X min Y sec                   │
│ ✓ Image pushed: ghcr.io/.../k8s-app:abc123     │
│ ✓ Manifest updated & pushed                     │
└─────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────┐
│ ArgoCD Dashboard (https://localhost:8080)       │
│ Application: k8s-demo                           │
│ Status: Synced ✓                                │
│ Health: Healthy ✓                               │
│ Sync Result: Successful                         │
└─────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────┐
│ Kubernetes (kubectl)                            │
│ $ kubectl get all -n k8s-demo                   │
│ NAME                            READY   STATUS  │
│ pod/k8s-demo-5c8f9b6d7f-abc1   1/1     Running │
│ pod/k8s-demo-5c8f9b6d7f-def2   1/1     Running │
│ service/k8s-demo               ClusterIP       │
│ deployment/k8s-demo            2/2 running     │
└─────────────────────────────────────────────────┘
```

