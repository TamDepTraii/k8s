@echo off
REM Script để reset mật khẩu ArgoCD

echo ========================================
echo   ArgoCD Password Reset Script
echo ========================================
echo.

echo [1] Kiểm tra ArgoCD pods...
kubectl -n argocd get pods
echo.

echo [2] Kiểm tra secrets...
kubectl -n argocd get secrets
echo.

echo [3] Lấy mật khẩu admin hiện tại...
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" > pass_encoded.txt
if exist pass_encoded.txt (
    echo Mật khẩu được mã hóa Base64 (được lưu vào pass_encoded.txt)
    type pass_encoded.txt
    del pass_encoded.txt
) else (
    echo Secret không tồn tại. Sẽ reset...
    echo [4] Xóa secret cũ...
    kubectl -n argocd delete secret argocd-initial-admin-secret

    echo [5] Khởi động lại server...
    kubectl -n argocd rollout restart deployment/argocd-server

    echo [6] Đợi server sẵn sàng...
    timeout /t 30

    echo [7] Lấy mật khẩu mới...
    kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}"
)

echo.
echo [8] Khởi động port-forward...
echo Truy cập: https://localhost:8080
kubectl -n argocd port-forward svc/argocd-server 8080:443

pause

