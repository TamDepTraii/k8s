@echo off
REM Script to deploy application to Kubernetes

echo.
echo ========================================
echo   Deploying K8s Application
echo ========================================
echo.

REM Check if kubectl is available
kubectl version >nul 2>&1
if errorlevel 1 (
    echo ERROR: kubectl is not installed or not in PATH
    pause
    exit /b 1
)

REM Check Kubernetes cluster
echo [1] Checking Kubernetes cluster...
kubectl cluster-info >nul 2>&1
if errorlevel 1 (
    echo ERROR: Kubernetes cluster is not running
    pause
    exit /b 1
)
echo OK: Kubernetes cluster is running

REM Create namespace if not exists
echo [2] Creating namespace...
kubectl create namespace k8s-app 2>nul
echo OK: Namespace ready

REM Apply configuration
echo [3] Applying Kubernetes manifests...
kubectl apply -f k8s/ -n k8s-app
if errorlevel 1 (
    echo ERROR: Failed to apply Kubernetes manifests
    pause
    exit /b 1
)
echo OK: Manifests applied

REM Wait for deployment
echo [4] Waiting for deployment...
kubectl wait --for=condition=ready pod -l app=k8s-app -n k8s-app --timeout=300s

REM Show deployment status
echo.
echo ========================================
echo   Deployment Status
echo ========================================
kubectl get deployments -n k8s-app
echo.
kubectl get services -n k8s-app
echo.
kubectl get pods -n k8s-app
echo.

REM Port forward
echo [5] Setting up port-forward...
echo Accessing application at http://localhost:8080
kubectl -n k8s-app port-forward svc/k8s-service 8080:8080

pause

