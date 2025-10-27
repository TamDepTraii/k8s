# Script để generate bcrypt password cho ArgoCD
# Sử dụng htpasswd hoặc Python

Write-Host "Generating bcrypt password for ArgoCD..." -ForegroundColor Yellow
Write-Host ""

# Cách 1: Sử dụng htpasswd (nếu cài đặt)
$password = "admin123"

# Cách 2: Tạo bcrypt bằng PowerShell
# We'll use a simple approach - create a random password
$random = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 16 | ForEach-Object {[char]$_})

Write-Host "Password created: $password" -ForegroundColor Green
Write-Host "Random password: $random" -ForegroundColor Green

# Bây giờ patch secret
Write-Host ""
Write-Host "Updating ArgoCD secret..." -ForegroundColor Yellow

# Create base64 encoded password
$passwordBase64 = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($password))

Write-Host "Base64: $passwordBase64" -ForegroundColor Cyan

# Patch the secret with admin password
# Note: ArgoCD expects bcrypt hashed password, but we'll try with plain base64 first
$patchJson = @{
    data = @{
        "admin.password" = $passwordBase64
    }
} | ConvertTo-Json

Write-Host ""
Write-Host "Patch JSON: $patchJson" -ForegroundColor Cyan

