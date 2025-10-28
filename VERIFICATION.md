# ✅ Setup Verification Checklist

## Prerequisites
- [ ] Kubernetes cluster running (Docker Desktop, Minikube, etc.)
- [ ] `kubectl` installed and configured
- [ ] `argocd` CLI installed (optional but recommended)
- [ ] Git repository pushed to GitHub
- [ ] Java 11+ installed locally

## GitHub Repository Setup
- [ ] Repository cloned locally
- [ ] `main` branch is default
- [ ] `.github/workflows/cicd-pipeline.yml` exists
- [ ] GitHub Actions enabled in repository settings

## ArgoCD Installation
- [ ] ArgoCD namespace created: `kubectl create namespace argocd`
- [ ] ArgoCD manifests applied
- [ ] ArgoCD server pod is running: `kubectl get pods -n argocd`
- [ ] ArgoCD server service exists: `kubectl get svc -n argocd`

## ArgoCD Configuration
- [ ] Accessed ArgoCD Dashboard: `kubectl port-forward svc/argocd-server -n argocd 8080:443`
- [ ] Logged in with admin credentials
- [ ] Retrieved initial password: `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`
- [ ] Changed admin password (recommended)

## Application Setup
- [ ] `argocd/application.yaml` created
- [ ] Application applied to cluster: `kubectl apply -f argocd/application.yaml`
- [ ] Application status is "Synced": `argocd app get k8s-demo`

## Kubernetes Manifests
- [ ] `k8s/namespace.yaml` exists
- [ ] `k8s/service.yaml` exists
- [ ] `k8s/deployment.yaml` exists
- [ ] `k8s/kustomization.yaml` exists
- [ ] `k8s/application.properties` exists

## First Deployment Test
- [ ] Code committed to `main` branch
- [ ] GitHub Actions workflow triggered
- [ ] Build completed successfully
- [ ] Docker image pushed to GHCR
- [ ] Manifest updated with new image tag
- [ ] Changes committed and pushed to repo
- [ ] ArgoCD detected changes
- [ ] Deployment created in `k8s-demo` namespace
- [ ] Pods are running: `kubectl get pods -n k8s-demo`
- [ ] Service is created: `kubectl get svc -n k8s-demo`

## Application Verification
- [ ] Port-forward to service: `kubectl port-forward svc/k8s-demo 8080:80 -n k8s-demo`
- [ ] Application accessible: `curl http://localhost:8080/actuator/health`
- [ ] Health endpoint returns `UP`
- [ ] Metrics endpoint works: `curl http://localhost:8080/actuator/prometheus`

## Monitoring & Status
- [ ] ArgoCD Dashboard shows healthy status
- [ ] No ArgoCD health warnings
- [ ] Deployment replicas all ready
- [ ] Liveness probes passing
- [ ] Readiness probes passing
- [ ] No recent events/errors

## Troubleshooting (if needed)
- [ ] Check GitHub Actions logs: https://github.com/{user}/k8s/actions
- [ ] Check ArgoCD logs: `kubectl logs -n argocd -l app.kubernetes.io/name=argocd-server`
- [ ] Check deployment events: `kubectl describe deployment k8s-demo -n k8s-demo`
- [ ] Check pod logs: `kubectl logs -l app=k8s-demo -n k8s-demo`
- [ ] Force ArgoCD sync: `argocd app sync k8s-demo`

## Production Readiness (Optional)
- [ ] Setup ArgoCD notifications (Slack/email)
- [ ] Configure GitHub branch protection rules
- [ ] Setup monitoring/alerting (Prometheus, Grafana)
- [ ] Document deployment procedure
- [ ] Create backup strategy
- [ ] Plan disaster recovery
- [ ] Setup RBAC policies

---

## Quick Command Summary

```bash
# 1. Install ArgoCD
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# 2. Create application
kubectl apply -f argocd/app.yaml

# 3. Check everything
argocd app get k8s-demo
kubectl get all -n k8s-demo

# 4. Access application
kubectl port-forward svc/k8s-demo 8080:80 -n k8s-demo
curl http://localhost:8080/actuator/health

# 5. View logs
kubectl logs -f deployment/k8s-demo -n k8s-demo
kubectl logs -n argocd -l app.kubernetes.io/name=argocd-server
```

## Common Issues & Solutions

### Issue: Image pull errors
**Solution:** 
```bash
# Check if GHCR image exists
curl https://ghcr.io/v2/tamdeptraii/k8s/k8s-app/tags/list

# Check image details
kubectl describe pod <pod-name> -n k8s-demo
```

### Issue: Application not syncing
**Solution:**
```bash
# Force sync
argocd app sync k8s-demo --force

# Check logs
kubectl logs -n argocd deployment/argocd-application-controller
```

### Issue: Pods not starting
**Solution:**
```bash
# Get pod events
kubectl describe pod <pod-name> -n k8s-demo

# Check logs
kubectl logs <pod-name> -n k8s-demo

# Check resource limits
kubectl top pods -n k8s-demo
```

### Issue: Service not accessible
**Solution:**
```bash
# Verify service
kubectl get svc k8s-demo -n k8s-demo

# Check endpoints
kubectl get endpoints k8s-demo -n k8s-demo

# Test connectivity
kubectl run -it --rm debug --image=alpine --restart=Never -- sh
# Inside pod: wget http://k8s-demo.k8s-demo.svc.cluster.local
```

---

**Status:** Ready for deployment! ✅

