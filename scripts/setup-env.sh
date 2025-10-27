#!/bin/bash

# Script to setup complete environment
# Usage: ./setup-env.sh

set -e

echo "🔧 Setting up complete environment..."

# Check prerequisites
echo "✓ Checking prerequisites..."

check_command() {
  if ! command -v $1 &> /dev/null; then
    echo "❌ $1 is not installed. Please install it first."
    exit 1
  fi
  echo "✓ $1 found"
}

check_command java
check_command mvn
check_command docker
check_command kubectl

# Build application
echo ""
echo "🏗️  Building application..."
mvn clean package -DskipTests

# Build Docker image
echo ""
echo "🐳 Building Docker image..."
docker build -t k8s-demo:latest .

# Create Kubernetes namespace
echo ""
echo "📦 Creating Kubernetes namespace..."
kubectl create namespace k8s-demo || echo "Namespace already exists"

# Deploy to Kubernetes
echo ""
echo "🚀 Deploying to Kubernetes..."
bash scripts/deploy.sh

echo ""
echo "✅ Environment setup complete!"
echo ""
echo "📚 Next steps:"
echo "1. Setup ArgoCD: bash scripts/setup-argocd.sh"
echo "2. Configure GitHub secrets for CI/CD"
echo "3. Push code to GitHub to trigger pipeline"
echo ""
echo "🌐 Access application:"
echo "kubectl port-forward svc/k8s-demo -n k8s-demo 8080:80"
echo "Then visit: http://localhost:8080"

