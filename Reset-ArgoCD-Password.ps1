# ArgoCD Password Reset Script - PowerShell Version

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ArgoCD Password Reset Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check ArgoCD pods
Write-Host "[1] Checking ArgoCD pods..." -ForegroundColor Yellow
kubectl -n argocd get pods
Write-Host ""

# Step 2: Check secrets
Write-Host "[2] Checking secrets..." -ForegroundColor Yellow
kubectl -n argocd get secrets
Write-Host ""

# Step 3: Try to get password
Write-Host "[3] Trying to get admin password..." -ForegroundColor Yellow
try {
    $secret = kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" 2>$null
    if ($secret) {
        $password = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($secret))
        Write-Host "SUCCESS! Password found:" -ForegroundColor Green
        Write-Host "Username: admin" -ForegroundColor Green
        Write-Host "Password: $password" -ForegroundColor Green
    } else {
        throw "Secret not found"
    }
} catch {
    Write-Host "Secret not found. Resetting ArgoCD..." -ForegroundColor Red
    Write-Host ""

    # Step 4: Delete old secret
    Write-Host "[4] Deleting old secret..." -ForegroundColor Yellow
    kubectl -n argocd delete secret argocd-initial-admin-secret --ignore-not-found=true
    Write-Host ""

    # Step 5: Restart server
    Write-Host "[5] Restarting argocd-server..." -ForegroundColor Yellow
    kubectl -n argocd rollout restart deployment/argocd-server
    Write-Host ""

    # Step 6: Wait for pod to be ready
    Write-Host "[6] Waiting for server to be ready (30 seconds)..." -ForegroundColor Yellow
    Start-Sleep -Seconds 30
    Write-Host ""

    # Step 7: Get new password
    Write-Host "[7] Getting new password..." -ForegroundColor Yellow
    try {
        $secret = kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" 2>$null
        if ($secret) {
            $password = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($secret))
            Write-Host "NEW PASSWORD:" -ForegroundColor Green
            Write-Host "Username: admin" -ForegroundColor Green
            Write-Host "Password: $password" -ForegroundColor Green
        } else {
            Write-Host "Could not retrieve password. Please check manually." -ForegroundColor Red
        }
    } catch {
        Write-Host "Error getting password: $_" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "[8] To access ArgoCD, run this command:" -ForegroundColor Cyan
Write-Host "kubectl -n argocd port-forward svc/argocd-server 8080:443" -ForegroundColor Cyan
Write-Host ""
Write-Host "Then open: https://localhost:8080" -ForegroundColor Cyan
Write-Host ""
Write-Host "Press any key to continue..."
Read-Host

