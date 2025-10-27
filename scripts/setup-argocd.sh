#!/bin/bash

# Script to setup ArgoCD locally
# Usage: ./setup-argocd.sh

set -e

echo "🚀 Setting up ArgoCD..."

# Create argocd namespace
echo "📦 Creating argocd namespace..."
kubectl create namespace argocd || echo "Namespace already exists"

# Install ArgoCD
echo "📥 Installing ArgoCD..."
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for ArgoCD to be ready
echo "⏳ Waiting for ArgoCD to be ready..."
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=300s

# Get initial password
echo "🔐 ArgoCD Admin Password:"
ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo "$ARGOCD_PASSWORD"

# Port forward
echo "🌐 Setting up port forwarding..."
echo "Access ArgoCD at: https://localhost:8443"
echo "Username: admin"
echo "Password: $ARGOCD_PASSWORD"
echo ""
echo "Port forwarding in background..."
kubectl port-forward svc/argocd-server -n argocd 8443:443 &

echo "✅ ArgoCD setup complete!"

