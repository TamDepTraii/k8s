@echo off
REM Script to get ArgoCD admin password

echo.
echo ========================================
echo ArgoCD Admin Password Retrieval
echo ========================================
echo.

echo Attempting to get password from Kubernetes secret...
echo.

REM Try to get password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" > password.txt 2>nul

if exist password.txt (
    echo Password retrieved (base64 encoded):
    type password.txt
    echo.
    echo.
    echo To decode password, use PowerShell:
    echo $pass = [IO.File]::ReadAllText('password.txt')
    echo [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($pass))
    del password.txt
) else (
    echo.
    echo ERROR: Could not retrieve password from Kubernetes!
    echo.
    echo Please try:
    echo 1. Check if Kubernetes cluster is running
    echo 2. Check if ArgoCD is installed in 'argocd' namespace
    echo 3. Run: kubectl get namespace argocd
    echo.
)

echo.
echo ========================================
echo Default Credentials (if not set):
echo ========================================
echo Username: admin
echo Password: (check ArgoCD logs or use command above)
echo URL: https://localhost:8443
echo.
pause

