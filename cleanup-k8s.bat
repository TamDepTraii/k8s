@echo off
REM Cleanup Kubernetes resources

echo.
echo ===== Cleaning up Kubernetes resources =====
echo.

echo Deleting all k8s-demo resources...
kubectl delete deployment k8s-demo
kubectl delete service k8s-demo-service
kubectl delete configmap k8s-demo-config
kubectl delete hpa k8s-demo-hpa

echo.
echo ===== Cleanup Complete =====
echo.
echo Verify all resources deleted:
echo   kubectl get all -l app=k8s-demo
echo.

