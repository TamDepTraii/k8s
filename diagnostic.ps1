# Diagnostic Script - Kiểm tra tất cả vấn đề

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "DIAGNOSTIC REPORT" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 1. Check Kubernetes
Write-Host "[1/5] Checking Kubernetes..." -ForegroundColor Yellow
Write-Host ""
try {
    $clusterInfo = kubectl cluster-info 2>&1
    if ($clusterInfo) {
        Write-Host "✓ Kubernetes is running" -ForegroundColor Green
        Write-Host $clusterInfo
    } else {
        Write-Host "✗ Kubernetes not responding" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ kubectl not found or error: $_" -ForegroundColor Red
}
Write-Host ""

# 2. Check ArgoCD Namespace
Write-Host "[2/5] Checking ArgoCD namespace..." -ForegroundColor Yellow
Write-Host ""
try {
    $pods = kubectl -n argocd get pods 2>&1
    if ($pods -match "NAME") {
        Write-Host "✓ ArgoCD namespace found" -ForegroundColor Green
        Write-Host $pods
    } else {
        Write-Host "✗ ArgoCD namespace issues" -ForegroundColor Red
        Write-Host $pods
    }
} catch {
    Write-Host "✗ Error: $_" -ForegroundColor Red
}
Write-Host ""

# 3. Check Docker Images
Write-Host "[3/5] Checking Docker images..." -ForegroundColor Yellow
Write-Host ""
try {
    $images = docker images 2>&1
    if ($images -match "k8s") {
        Write-Host "✓ Docker image k8s-demo found" -ForegroundColor Green
        $images | Select-String "k8s"
    } else {
        Write-Host "⚠ Docker image k8s-demo NOT found" -ForegroundColor Yellow
        Write-Host "Need to build: mvnw spring-boot:build-image"
    }
} catch {
    Write-Host "✗ Docker error: $_" -ForegroundColor Red
}
Write-Host ""

# 4. Check Docker Containers
Write-Host "[4/5] Checking Docker containers..." -ForegroundColor Yellow
Write-Host ""
try {
    $containers = docker ps 2>&1
    Write-Host "Running containers:" -ForegroundColor Cyan
    Write-Host $containers | head -10
} catch {
    Write-Host "✗ Docker error: $_" -ForegroundColor Red
}
Write-Host ""

# 5. Check ArgoCD Server Pod Logs
Write-Host "[5/5] Checking ArgoCD logs..." -ForegroundColor Yellow
Write-Host ""
try {
    $logs = kubectl -n argocd logs deployment/argocd-server 2>&1 | head -20
    Write-Host "ArgoCD logs (last 20 lines):" -ForegroundColor Cyan
    Write-Host $logs
} catch {
    Write-Host "Could not get logs" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "DIAGNOSIS COMPLETE" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Solutions:" -ForegroundColor Yellow
Write-Host "1. If Kubernetes not running: Enable in Docker Desktop" -ForegroundColor Cyan
Write-Host "2. If ArgoCD pods down: kubectl -n argocd rollout restart deployment/argocd-server" -ForegroundColor Cyan
Write-Host "3. If no image: Build it: mvnw spring-boot:build-image -Dspring-boot.build-image.imageName=k8s-demo:latest" -ForegroundColor Cyan
Write-Host "4. Port-forward: kubectl -n argocd port-forward svc/argocd-server 8080:443" -ForegroundColor Cyan
Write-Host ""

