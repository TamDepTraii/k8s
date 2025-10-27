#!/bin/bash
# Complete Setup Script for K8s + ArgoCD
# Run this after ensuring Docker Desktop and kubectl are running

set -e

echo "========================================="
echo "  K8s + ArgoCD Complete Setup Script"
echo "========================================="
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Step 1: Check Prerequisites
echo -e "${BLUE}[STEP 1/5]${NC} Checking prerequisites..."
echo ""

if ! command -v docker &> /dev/null; then
    echo "❌ Docker not found. Please install Docker Desktop."
    exit 1
fi
echo "✓ Docker found: $(docker --version)"

if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl not found. Please install kubectl."
    exit 1
fi
echo "✓ kubectl found: $(kubectl version --client --short 2>/dev/null || echo 'OK')"

if ! command -v git &> /dev/null; then
    echo "❌ Git not found. Please install Git."
    exit 1
fi
echo "✓ Git found: $(git --version)"

echo ""

# Step 2: Check Kubernetes Cluster
echo -e "${BLUE}[STEP 2/5]${NC} Checking Kubernetes cluster..."
echo ""

if ! kubectl cluster-info &> /dev/null; then
    echo "❌ Kubernetes cluster not running."
    echo "   Please enable Kubernetes in Docker Desktop settings."
    exit 1
fi
echo "✓ Kubernetes cluster is running"
echo ""

# Step 3: Check ArgoCD Installation
echo -e "${BLUE}[STEP 3/5]${NC} Checking ArgoCD..."
echo ""

if kubectl get namespace argocd &> /dev/null; then
    ARGOCD_PODS=$(kubectl -n argocd get pods --no-headers 2>/dev/null | wc -l)
    echo "✓ ArgoCD namespace found"
    echo "  Running pods: $ARGOCD_PODS"
else
    echo "⚠ ArgoCD not installed in cluster"
    read -p "  Install ArgoCD now? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Installing ArgoCD..."
        kubectl create namespace argocd || true
        kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
        echo "✓ ArgoCD installation started"
        echo "  Waiting for pods to be ready (this may take 2-3 minutes)..."
        kubectl -n argocd wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server --timeout=300s 2>/dev/null || true
    fi
fi
echo ""

# Step 4: Docker Image Check
echo -e "${BLUE}[STEP 4/5]${NC} Checking Docker images..."
echo ""

if docker images | grep -q "k8s-demo"; then
    IMAGE_ID=$(docker images | grep k8s-demo | head -1 | awk '{print $3}')
    echo "✓ k8s-demo image found (ID: ${IMAGE_ID:0:12})"
    echo "  Build new image? (y/n)"
    read -p "  " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Building new Docker image..."
        ./mvnw spring-boot:build-image -Dspring-boot.build-image.imageName=k8s-demo:latest
    fi
else
    echo "⚠ k8s-demo image not found"
    read -p "  Build Docker image now? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Building Docker image..."
        ./mvnw spring-boot:build-image -Dspring-boot.build-image.imageName=k8s-demo:latest
        echo "✓ Docker image built successfully"
    fi
fi
echo ""

# Step 5: Git Status
echo -e "${BLUE}[STEP 5/5]${NC} Checking Git status..."
echo ""

if ! git remote -v | grep -q origin; then
    echo "⚠ Git remote 'origin' not configured"
    read -p "  Configure Git remote? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        read -p "  Enter GitHub repository URL: " REPO_URL
        git remote add origin "$REPO_URL" || git remote set-url origin "$REPO_URL"
        echo "✓ Git remote configured"
    fi
else
    ORIGIN=$(git remote get-url origin)
    echo "✓ Git remote configured: $ORIGIN"
fi
echo ""

# Summary
echo "========================================="
echo -e "${GREEN}✓ Setup Check Complete!${NC}"
echo "========================================="
echo ""
echo "Next steps:"
echo ""
echo "1. Port-forward ArgoCD:"
echo "   ${YELLOW}kubectl -n argocd port-forward svc/argocd-server 8080:443${NC}"
echo ""
echo "2. Access ArgoCD:"
echo "   ${YELLOW}https://localhost:8080${NC}"
echo "   Username: admin"
echo "   Password: Tmpr4695958"
echo ""
echo "3. Push to GitHub:"
echo "   ${YELLOW}git add -A${NC}"
echo "   ${YELLOW}git commit -m \"Add: K8s and ArgoCD setup\"${NC}"
echo "   ${YELLOW}git push origin main${NC}"
echo ""
echo "4. View documentation:"
echo "   ${YELLOW}cat 00_START_HERE.md${NC}"
echo ""
echo "========================================="

