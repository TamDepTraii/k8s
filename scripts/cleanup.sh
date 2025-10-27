#!/bin/bash

# Script to cleanup resources
# Usage: ./cleanup.sh

set -e

echo "🧹 Cleaning up resources..."

# Delete ArgoCD resources
echo "Removing ArgoCD resources..."
kubectl delete application k8s-demo -n argocd || echo "Application not found"

# Delete Kubernetes deployment
echo "Removing Kubernetes deployment..."
kubectl delete namespace k8s-demo || echo "Namespace not found"

# Delete Docker images
echo "Removing Docker images..."
docker rmi k8s-demo:latest || echo "Image not found"

echo "✅ Cleanup complete!"
#!/bin/bash

# Script to deploy application to Kubernetes
# Usage: ./deploy.sh

set -e

echo "🚀 Deploying application to Kubernetes..."

# Apply namespace and RBAC
echo "📦 Applying namespace and RBAC..."
kubectl apply -f k8s/namespace.yaml

# Apply ConfigMap
echo "📝 Applying ConfigMap..."
kubectl apply -f k8s/configmap.yaml

# Apply Service
echo "🔌 Applying Service..."
kubectl apply -f k8s/service.yaml

# Apply HPA
echo "📊 Applying Horizontal Pod Autoscaler..."
kubectl apply -f k8s/hpa.yaml

# Apply Deployment
echo "🐳 Applying Deployment..."
kubectl apply -f k8s/deployment.yaml

# Apply ServiceMonitor (if Prometheus is installed)
if kubectl get crd servicemonitors.monitoring.coreos.com >/dev/null 2>&1; then
  echo "📈 Applying ServiceMonitor..."
  kubectl apply -f k8s/servicemonitor.yaml
else
  echo "⚠️  ServiceMonitor CRD not found, skipping ServiceMonitor"
fi

# Wait for deployment
echo "⏳ Waiting for deployment to be ready..."
kubectl rollout status deployment/k8s-demo -n k8s-demo --timeout=5m

echo "✅ Deployment complete!"

# Display status
echo ""
echo "📊 Deployment Status:"
kubectl get deployment -n k8s-demo
kubectl get pods -n k8s-demo
kubectl get svc -n k8s-demo

# Show port forward instructions
echo ""
echo "🌐 Access application:"
echo "kubectl port-forward svc/k8s-demo -n k8s-demo 8080:80"
echo ""
echo "Then visit: http://localhost:8080"

