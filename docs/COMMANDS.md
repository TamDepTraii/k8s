#!/bin/bash

# Useful Commands for Kubernetes and CI/CD

## ============================================
## KUBERNETES COMMANDS
## ============================================

# View resources
kubectl get all -n k8s-demo
kubectl get pods -n k8s-demo -w  # Watch
kubectl describe pod <pod-name> -n k8s-demo

# View logs
kubectl logs deployment/k8s-demo -n k8s-demo
kubectl logs deployment/k8s-demo -n k8s-demo -f  # Follow
kubectl logs deployment/k8s-demo -n k8s-demo --tail=100

# Execute commands in pod
kubectl exec -it <pod-name> -n k8s-demo -- /bin/sh

# Port forward
kubectl port-forward svc/k8s-demo -n k8s-demo 8080:80

# Scale deployment
kubectl scale deployment k8s-demo -n k8s-demo --replicas=5

# Rollout status
kubectl rollout status deployment/k8s-demo -n k8s-demo
kubectl rollout history deployment/k8s-demo -n k8s-demo
kubectl rollout undo deployment/k8s-demo -n k8s-demo

# Restart deployment
kubectl rollout restart deployment/k8s-demo -n k8s-demo

# Delete resources
kubectl delete pod <pod-name> -n k8s-demo
kubectl delete deployment k8s-demo -n k8s-demo

# Apply manifests
kubectl apply -f k8s/
kubectl diff -f k8s/

# Debugging
kubectl get events -n k8s-demo --sort-by='.lastTimestamp'
kubectl debug pod <pod-name> -n k8s-demo -it --image=nicolaka/netshoot

## ============================================
## ARGOCD COMMANDS
## ============================================

# List applications
argocd app list

# Get application status
argocd app get k8s-demo
argocd app get k8s-demo --refresh

# Sync application
argocd app sync k8s-demo
argocd app sync k8s-demo --force
argocd app sync k8s-demo --async

# Wait for sync
argocd app wait k8s-demo

# Delete application
argocd app delete k8s-demo

# Watch application
argocd app watch k8s-demo

# View diff
argocd app diff k8s-demo

# History
argocd app history k8s-demo
argocd app rollback k8s-demo <revision>

## ============================================
## DOCKER COMMANDS
## ============================================

# Build image
docker build -t k8s-demo:latest .
docker build --progress=plain -t k8s-demo:latest .

# Run container
docker run -p 8080:8080 k8s-demo:latest
docker run -it k8s-demo:latest /bin/sh

# View images
docker images | grep k8s-demo

# Remove images
docker rmi k8s-demo:latest
docker system prune -a

# Push to registry
docker push ghcr.io/username/k8s-demo:latest
docker push username/k8s-demo:latest

## ============================================
## MAVEN COMMANDS
## ============================================

# Build
mvn clean package
mvn clean package -DskipTests
mvn clean package -Dmaven.test.skip=true

# Tests
mvn test
mvn test -Dtest=TestClass

# Run application
mvn spring-boot:run

# Build Docker image
mvn clean package spring-boot:build-image

# Dependency tree
mvn dependency:tree

## ============================================
## HELM COMMANDS (Optional)
## ============================================

# Validate
helm lint helm/

# Template
helm template k8s-demo helm/

# Install
helm install k8s-demo helm/ -n k8s-demo --create-namespace

# Upgrade
helm upgrade k8s-demo helm/ -n k8s-demo

# Rollback
helm rollback k8s-demo -n k8s-demo

# Uninstall
helm uninstall k8s-demo -n k8s-demo

## ============================================
## PROMETHEUS COMMANDS
## ============================================

# Query metrics endpoint
curl http://localhost:8080/actuator/prometheus

# Query Prometheus
curl 'http://prometheus:9090/api/v1/query?query=up'

## ============================================
## USEFUL ALIASES
## ============================================

# Add to ~/.bashrc or ~/.zshrc
alias k='kubectl'
alias ka='kubectl apply -f'
alias kd='kubectl delete'
alias kl='kubectl logs'
alias ke='kubectl exec -it'
alias kpf='kubectl port-forward'
alias kg='kubectl get'
alias kgp='kubectl get pods'
alias kgd='kubectl get deployment'
alias kin='kubectl get ingress'

## ============================================
## GITHUB ACTIONS COMMANDS
## ============================================

# View workflow status
gh workflow view cicd-pipeline.yml

# List workflow runs
gh run list -w cicd-pipeline.yml

# View run logs
gh run view <run-id> --log

# Trigger workflow
gh workflow run cicd-pipeline.yml

## ============================================
## GIT COMMANDS
## ============================================

# Status
git status

# Commit and push
git add .
git commit -m "message"
git push origin main

# View logs
git log --oneline
git log --graph --oneline --all

# Create branch
git checkout -b feature/new-feature

# Switch branch
git checkout main

# Merge branch
git merge feature/new-feature

# Rebase
git rebase main

## ============================================
## USEFUL SCRIPTS
## ============================================

# Get pod IP
kubectl get pod <pod-name> -n k8s-demo -o jsonpath='{.status.podIP}'

# Get node info
kubectl get nodes -o wide

# Check resource usage
kubectl top nodes
kubectl top pods -n k8s-demo

# Get all container images in cluster
kubectl get pods --all-namespaces -o jsonpath="{..image}" | tr -s '[[:space:]]' '\n'

# Watch HPA status
kubectl get hpa -n k8s-demo -w

# Check PVC status
kubectl get pvc -n k8s-demo

# Describe all resources
kubectl describe all -n k8s-demo

# Export resources to YAML
kubectl get deployment k8s-demo -n k8s-demo -o yaml > deployment-backup.yaml

# Apply from URL
kubectl apply -f https://example.com/manifest.yaml

## ============================================
## MONITORING COMMANDS
## ============================================

# Check Prometheus scrape targets
kubectl port-forward -n monitoring svc/prometheus-kube-prometheus-prometheus 9090:9090

# Check Grafana dashboards
kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80

# Check Alertmanager
kubectl port-forward -n monitoring alertmanager-kube-prometheus-alertmanager-0 9093:9093

