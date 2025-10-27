
scale:
	@echo "$(GREEN)Scaling deployment to $(REPLICAS) replicas...$(NC)"
	kubectl scale deployment k8s-demo -n $(KUBERNETES_NAMESPACE) --replicas=$(REPLICAS)

rollout-status:
	@echo "$(GREEN)Checking rollout status...$(NC)"
	kubectl rollout status deployment/k8s-demo -n $(KUBERNETES_NAMESPACE)

rollout-restart:
	@echo "$(GREEN)Restarting deployment...$(NC)"
	kubectl rollout restart deployment/k8s-demo -n $(KUBERNETES_NAMESPACE)

logs:
	@echo "$(GREEN)Showing logs for deployment...$(NC)"
	kubectl logs deployment/k8s-demo -n $(KUBERNETES_NAMESPACE) -f

logs-pod:
	@echo "$(YELLOW)Pod name required: POD_NAME=<name> make logs-pod$(NC)"
	@if [ -n "$(POD_NAME)" ]; then \
		kubectl logs $(POD_NAME) -n $(KUBERNETES_NAMESPACE) -f; \
	fi

port-forward:
	@echo "$(GREEN)Port forwarding to service...$(NC)"
	@echo "$(YELLOW)Access at: http://localhost:8080$(NC)"
	kubectl port-forward svc/k8s-demo -n $(KUBERNETES_NAMESPACE) 8080:80

describe-deployment:
	@echo "$(GREEN)Describing deployment...$(NC)"
	kubectl describe deployment k8s-demo -n $(KUBERNETES_NAMESPACE)

describe-pod:
	@echo "$(YELLOW)Pod name required: POD_NAME=<name> make describe-pod$(NC)"
	@if [ -n "$(POD_NAME)" ]; then \
		kubectl describe pod $(POD_NAME) -n $(KUBERNETES_NAMESPACE); \
	fi

delete:
	@echo "$(RED)Deleting Kubernetes resources...$(NC)"
	kubectl delete namespace $(KUBERNETES_NAMESPACE)

# ArgoCD targets
setup-argocd:
	@echo "$(GREEN)Setting up ArgoCD...$(NC)"
	@bash scripts/setup-argocd.sh

deploy-argocd:
	@echo "$(GREEN)Deploying ArgoCD application...$(NC)"
	kubectl apply -f argocd/application.yaml
	@echo "$(GREEN)✓ ArgoCD application deployed$(NC)"
	@echo "$(YELLOW)Wait a moment for ArgoCD to sync...$(NC)"

argocd-status:
	@echo "$(GREEN)Checking ArgoCD application status...$(NC)"
	argocd app get k8s-demo

argocd-sync:
	@echo "$(GREEN)Syncing ArgoCD application...$(NC)"
	argocd app sync k8s-demo

argocd-logs:
	@echo "$(GREEN)Showing ArgoCD controller logs...$(NC)"
	kubectl logs -n $(ARGOCD_NAMESPACE) deployment/argocd-application-controller -f

# Testing targets
health-check:
	@echo "$(GREEN)Checking application health...$(NC)"
	@sleep 2
	@curl -s http://localhost:8080/actuator/health | jq . || echo "$(RED)Health check failed$(NC)"

test-endpoints:
	@echo "$(GREEN)Testing application endpoints...$(NC)"
	@echo "Health: $$(curl -s http://localhost:8080/actuator/health | jq -r .status)"
	@echo "Info: $$(curl -s http://localhost:8080/actuator/info | jq -r .app.name)"

# Utility targets
status:
	@echo "$(GREEN)=== System Status ===$(NC)"
	@echo ""
	@echo "$(YELLOW)Kubernetes Cluster:$(NC)"
	@kubectl cluster-info 2>/dev/null || echo "$(RED)Kubernetes not accessible$(NC)"
	@echo ""
	@echo "$(YELLOW)Namespaces:$(NC)"
	@kubectl get namespace 2>/dev/null | grep -E "NAME|k8s-demo|argocd" || echo "$(RED)Namespaces not found$(NC)"
	@echo ""
	@echo "$(YELLOW)Deployments:$(NC)"
	@kubectl get deployment -n $(KUBERNETES_NAMESPACE) 2>/dev/null || echo "$(RED)Deployments not found$(NC)"
	@echo ""
	@echo "$(YELLOW)Pods:$(NC)"
	@kubectl get pods -n $(KUBERNETES_NAMESPACE) 2>/dev/null || echo "$(RED)Pods not found$(NC)"
	@echo ""
	@echo "$(YELLOW)Services:$(NC)"
	@kubectl get svc -n $(KUBERNETES_NAMESPACE) 2>/dev/null || echo "$(RED)Services not found$(NC)"

kube-status:
	@echo "$(GREEN)Kubernetes Status:$(NC)"
	kubectl get all -n $(KUBERNETES_NAMESPACE)

events:
	@echo "$(GREEN)Recent events:$(NC)"
	kubectl get events -n $(KUBERNETES_NAMESPACE) --sort-by='.lastTimestamp' -w

all-status: status kube-status

# Development targets
local-build: build docker-build

local-run: docker-run

local-test: local-build test

# Full setup
setup: build docker-build deploy setup-argocd deploy-argocd
	@echo "$(GREEN)✓ Full setup complete!$(NC)"
	@echo ""
	@echo "$(YELLOW)Next steps:$(NC)"
	@echo "  make port-forward   - Access application at http://localhost:8080"
	@echo "  make logs           - View application logs"
	@echo "  make status         - Check system status"

# Clean everything
clean-all: delete docker-stop
	@echo "$(GREEN)✓ Full cleanup complete$(NC)"

# Default target
.DEFAULT_GOAL := help
.PHONY: help build test docker-build docker-push deploy deploy-argocd clean logs status

# Variables
DOCKER_IMAGE ?= k8s-demo:latest
DOCKER_REGISTRY ?= ghcr.io/tamdeptraii
KUBERNETES_NAMESPACE ?= k8s-demo
ARGOCD_NAMESPACE ?= argocd

# Colors
RED=\033[0;31m
GREEN=\033[0;32m
YELLOW=\033[1;33m
NC=\033[0m # No Color

help:
	@echo "$(GREEN)K8s CI/CD Pipeline - Available Commands$(NC)"
	@echo ""
	@echo "$(YELLOW)Build & Package:$(NC)"
	@echo "  make build          - Build Java application with Maven"
	@echo "  make test           - Run unit tests"
	@echo "  make clean          - Clean build artifacts"
	@echo ""
	@echo "$(YELLOW)Docker:$(NC)"
	@echo "  make docker-build   - Build Docker image"
	@echo "  make docker-push    - Push Docker image to registry"
	@echo "  make docker-run     - Run Docker container locally"
	@echo ""
	@echo "$(YELLOW)Kubernetes:$(NC)"
	@echo "  make deploy         - Deploy to Kubernetes"
	@echo "  make deploy-argocd  - Deploy ArgoCD application"
	@echo "  make scale          - Scale deployment (REPLICAS=5 make scale)"
	@echo "  make rollout-status - Check deployment rollout status"
	@echo "  make logs           - View deployment logs"
	@echo "  make port-forward   - Port forward to service"
	@echo "  make delete         - Delete Kubernetes deployment"
	@echo ""
	@echo "$(YELLOW)ArgoCD:$(NC)"
	@echo "  make setup-argocd   - Install and setup ArgoCD"
	@echo "  make argocd-sync    - Manually sync ArgoCD application"
	@echo "  make argocd-status  - Check ArgoCD application status"
	@echo ""
	@echo "$(YELLOW)Utilities:$(NC)"
	@echo "  make status         - Show overall system status"
	@echo "  make health-check   - Check application health"

# Build targets
build:
	@echo "$(GREEN)Building Java application...$(NC)"
	mvn clean package -DskipTests

test:
	@echo "$(GREEN)Running tests...$(NC)"
	mvn test

clean:
	@echo "$(GREEN)Cleaning build artifacts...$(NC)"
	mvn clean
	rm -rf target/

# Docker targets
docker-build:
	@echo "$(GREEN)Building Docker image: $(DOCKER_IMAGE)$(NC)"
	docker build -t $(DOCKER_IMAGE) .
	@echo "$(GREEN)✓ Docker image built successfully$(NC)"

docker-push: docker-build
	@echo "$(GREEN)Pushing Docker image...$(NC)"
	docker tag $(DOCKER_IMAGE) $(DOCKER_REGISTRY)/$(DOCKER_IMAGE)
	docker push $(DOCKER_REGISTRY)/$(DOCKER_IMAGE)
	@echo "$(GREEN)✓ Docker image pushed successfully$(NC)"

docker-run:
	@echo "$(GREEN)Running Docker container...$(NC)"
	docker run -p 8080:8080 --name k8s-demo-container $(DOCKER_IMAGE)

docker-stop:
	@echo "$(YELLOW)Stopping Docker container...$(NC)"
	docker stop k8s-demo-container
	docker rm k8s-demo-container

# Kubernetes targets
deploy:
	@echo "$(GREEN)Deploying to Kubernetes...$(NC)"
	kubectl apply -f k8s/namespace.yaml
	kubectl apply -f k8s/configmap.yaml
	kubectl apply -f k8s/service.yaml
	kubectl apply -f k8s/deployment.yaml
	kubectl apply -f k8s/hpa.yaml
	@echo "$(GREEN)✓ Deployment complete$(NC)"

deploy-full: deploy
	@echo "$(GREEN)Deploying ServiceMonitor (requires Prometheus CRD)...$(NC)"
	kubectl apply -f k8s/servicemonitor.yaml || echo "$(YELLOW)ServiceMonitor CRD not found, skipping...$(NC)"

