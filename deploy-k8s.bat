@echo off
REM Deploy to Kubernetes

echo.
echo ===== Deploying to Kubernetes =====
echo.

echo Step 1: Creating ConfigMap...
kubectl apply -f k8s\configmap.yaml

echo.
echo Step 2: Deploying Application...
kubectl apply -f k8s\deployment.yaml

echo.
echo Step 3: Deploying HPA (Horizontal Pod Autoscaler)...
kubectl apply -f k8s\hpa.yaml

echo.
echo ===== Deployment Complete =====
echo.
echo Check status:
echo   kubectl get all -l app=k8s-demo
echo.
echo View logs:
echo   kubectl logs -l app=k8s-demo -f
echo.
echo Port-forward to test:
echo   kubectl port-forward svc/k8s-demo-service 9090:80
echo.
echo Then test:
echo   curl http://localhost:9090/helloWorld
echo.

