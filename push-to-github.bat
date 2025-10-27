@echo off
REM Script Push Project to GitHub
REM Usage: run-push-to-github.bat

echo ========================================
echo  Push Project to GitHub
echo ========================================
echo.

cd /d D:\ki1nam3\PTUDDN\k8s

echo [1] Checking git status...
git status
echo.

echo [2] Adding all files...
git add -A
echo Added all files successfully.
echo.

echo [3] Commit message...
set /p commit_msg="Enter commit message (default: 'Update: CI/CD setup with ArgoCD'): "
if "%commit_msg%"=="" set commit_msg=Update: CI/CD setup with ArgoCD
git commit -m "%commit_msg%"
echo.

echo [4] Pushing to GitHub...
git push -u origin main
echo.

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ✓ Successfully pushed to GitHub!
    echo.
    echo Repository: https://github.com/TamDepTraii/k8s.git
    echo Branch: main
) else (
    echo.
    echo ✗ Push failed. Please check:
    echo   - Git remote is configured
    echo   - You have GitHub credentials
    echo.
    echo Configure remote:
    echo   git remote add origin https://github.com/TamDepTraii/k8s.git
)

pause

