# Complete Setup Check Script for Windows PowerShell
# Run this after ensuring Docker Desktop and kubectl are running

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  K8s + ArgoCD Complete Setup Script" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check Prerequisites
Write-Host "[STEP 1/5] Checking prerequisites..." -ForegroundColor Blue
Write-Host ""

# Check Docker
if (Get-Command docker -ErrorAction SilentlyContinue) {
    $dockerVersion = docker --version
    Write-Host "✓ Docker found: $dockerVersion" -ForegroundColor Green
} else {
    Write-Host "❌ Docker not found. Please install Docker Desktop." -ForegroundColor Red
    exit 1
}

# Check kubectl
if (Get-Command kubectl -ErrorAction SilentlyContinue) {
    $kubectlVersion = kubectl version --client --short 2>$null
    Write-Host "✓ kubectl found: $kubectlVersion" -ForegroundColor Green
} else {
    Write-Host "❌ kubectl not found. Please install kubectl." -ForegroundColor Red
    exit 1
}

# Check Git
if (Get-Command git -ErrorAction SilentlyContinue) {
    $gitVersion = git --version
    Write-Host "✓ Git found: $gitVersion" -ForegroundColor Green
} else {
    Write-Host "❌ Git not found. Please install Git." -ForegroundColor Red
    exit 1
}

Write-Host ""

# Step 2: Check Kubernetes Cluster
Write-Host "[STEP 2/5] Checking Kubernetes cluster..." -ForegroundColor Blue
Write-Host ""

try {
    kubectl cluster-info | Out-Null
    Write-Host "✓ Kubernetes cluster is running" -ForegroundColor Green
} catch {
    Write-Host "❌ Kubernetes cluster not running." -ForegroundColor Red
    Write-Host "   Please enable Kubernetes in Docker Desktop settings." -ForegroundColor Red
    exit 1
}

Write-Host ""

# Step 3: Check ArgoCD Installation
Write-Host "[STEP 3/5] Checking ArgoCD..." -ForegroundColor Blue
Write-Host ""

try {
    $argocdNamespace = kubectl get namespace argocd -ErrorAction SilentlyContinue
    if ($null -ne $argocdNamespace) {
        $argoPods = kubectl -n argocd get pods --no-headers 2>$null | Measure-Object | Select-Object -ExpandProperty Count
        Write-Host "✓ ArgoCD namespace found" -ForegroundColor Green
        Write-Host "  Running pods: $argoPods" -ForegroundColor Green
    }
} catch {
    Write-Host "⚠ ArgoCD not installed in cluster" -ForegroundColor Yellow
    $install = Read-Host "  Install ArgoCD now? (y/n)"
    if ($install -eq "y") {
        Write-Host "Installing ArgoCD..." -ForegroundColor Yellow
        kubectl create namespace argocd 2>$null
        kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
        Write-Host "✓ ArgoCD installation started" -ForegroundColor Green
        Write-Host "  Waiting for pods to be ready (this may take 2-3 minutes)..." -ForegroundColor Yellow
        kubectl -n argocd wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server --timeout=300s 2>$null
    }
}

Write-Host ""

# Step 4: Docker Image Check
Write-Host "[STEP 4/5] Checking Docker images..." -ForegroundColor Blue
Write-Host ""

$k8sImage = docker images | Select-String "k8s-demo"
if ($null -ne $k8sImage) {
    Write-Host "✓ k8s-demo image found" -ForegroundColor Green
    Write-Host "  $($k8sImage -join '; ')" -ForegroundColor Green
} else {
    Write-Host "⚠ k8s-demo image not found" -ForegroundColor Yellow
    $buildImage = Read-Host "  Build Docker image now? (y/n)"
    if ($buildImage -eq "y") {
        Write-Host "Building Docker image..." -ForegroundColor Yellow
        .\mvnw.cmd spring-boot:build-image "-Dspring-boot.build-image.imageName=k8s-demo:latest"
        Write-Host "✓ Docker image built successfully" -ForegroundColor Green
    }
}

Write-Host ""

# Step 5: Git Status
Write-Host "[STEP 5/5] Checking Git status..." -ForegroundColor Blue
Write-Host ""

$gitRemote = git remote -v 2>$null | Select-String "origin"
if ($null -ne $gitRemote) {
    Write-Host "✓ Git remote configured:" -ForegroundColor Green
    Write-Host "  $gitRemote" -ForegroundColor Green
} else {
    Write-Host "⚠ Git remote 'origin' not configured" -ForegroundColor Yellow
    $configGit = Read-Host "  Configure Git remote? (y/n)"
    if ($configGit -eq "y") {
        $repoUrl = Read-Host "  Enter GitHub repository URL"
        git remote add origin $repoUrl 2>$null
        if ($LASTEXITCODE -ne 0) {
            git remote set-url origin $repoUrl
        }
        Write-Host "✓ Git remote configured" -ForegroundColor Green
    }
}

Write-Host ""

# Summary
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "✓ Setup Check Complete!" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Port-forward ArgoCD:" -ForegroundColor Yellow
Write-Host "   kubectl -n argocd port-forward svc/argocd-server 8080:443" -ForegroundColor Cyan
Write-Host ""
Write-Host "2. Access ArgoCD:" -ForegroundColor Yellow
Write-Host "   https://localhost:8080" -ForegroundColor Cyan
Write-Host "   Username: admin" -ForegroundColor Cyan
Write-Host "   Password: Tmpr4695958" -ForegroundColor Cyan
Write-Host ""
Write-Host "3. Push to GitHub:" -ForegroundColor Yellow
Write-Host "   git add -A" -ForegroundColor Cyan
Write-Host "   git commit -m ""Add: K8s and ArgoCD setup""" -ForegroundColor Cyan
Write-Host "   git push origin main" -ForegroundColor Cyan
Write-Host ""
Write-Host "4. View documentation:" -ForegroundColor Yellow
Write-Host "   cat 00_START_HERE.md" -ForegroundColor Cyan
Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan

