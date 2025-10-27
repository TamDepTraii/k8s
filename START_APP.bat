@echo off
REM Script to start the K8s application

echo.
echo ========================================
echo   Starting K8s Spring Boot Application
echo ========================================
echo.

REM Check if Docker is running
echo [1] Checking Docker...
docker ps >nul 2>&1
if errorlevel 1 (
    echo ERROR: Docker is not running. Please start Docker Desktop.
    pause
    exit /b 1
)
echo OK: Docker is running

REM Check if Kubernetes is running
echo [2] Checking Kubernetes...
kubectl cluster-info >nul 2>&1
if errorlevel 1 (
    echo ERROR: Kubernetes is not running. Please enable it in Docker Desktop.
    pause
    exit /b 1
)
echo OK: Kubernetes is running

REM Check ArgoCD
echo [3] Checking ArgoCD...
kubectl -n argocd get pods >nul 2>&1
if errorlevel 1 (
    echo WARNING: ArgoCD namespace not found. This is optional.
) else (
    echo OK: ArgoCD is running
)

REM Build and run
echo.
echo [4] Building application...
call mvnw.cmd clean spring-boot:run

pause

