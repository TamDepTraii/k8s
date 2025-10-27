# Troubleshooting Guide

## ❌ Common Issues & Solutions

### Build Issues

#### Issue: "release version 17 not supported"

**Error**:
```
Fatal error compiling: error: release version 17 not supported
```

**Cause**: Java compiler version mismatch

**Solution**:
```bash
# Check Java version
java -version

# Install Java 11 (pom.xml requires 11)
# Windows: Download from adoptopenjdk.com
# macOS: brew install openjdk@11
# Linux: sudo apt-get install openjdk-11-jdk

# Set JAVA_HOME
export JAVA_HOME=/path/to/java11
mvn clean package
```

#### Issue: "Maven not found"

**Error**:
```
mvn: command not found
```

**Solution**:
```bash
# Use Maven wrapper instead
./mvnw clean package          # Linux/Mac
mvnw.cmd clean package        # Windows
```

---

### Docker Issues

#### Issue: "Build failed: permission denied"

**Error**:
```
permission denied while trying to connect to Docker daemon
```

**Solution**:
```bash
# Add user to docker group
sudo usermod -aG docker $USER
newgrp docker

# Or use sudo
sudo docker build -t k8s-demo:latest .
```

#### Issue: "Image not found when pushing"

**Error**:
```
Error response from daemon: manifest not found
```

**Solution**:
```bash
# Tag image correctly
docker tag k8s-demo:latest ghcr.io/username/k8s-demo:latest

# Login to registry
echo $CR_PAT | docker login ghcr.io -u USERNAME --password-stdin

# Push
docker push ghcr.io/username/k8s-demo:latest
```

#### Issue: "Docker Compose port already in use"

**Error**:
```
Error starting userland proxy: listen tcp 0.0.0.0:8080: bind: address already in use
```

**Solution**:
```bash
# Check what's using port 8080
netstat -tuln | grep 8080        # Linux/Mac
netstat -ano | findstr :8080     # Windows

# Kill the process or use different port
docker-compose down
docker-compose -f docker-compose.yml up -d
```

---

### Kubernetes Issues

#### Issue: "Pod stuck in ImagePullBackOff"

**Error**:
```
ImagePullBackOff - Back-off pulling image "k8s-demo:latest"
```

**Cause**: Image not found or imagePullPolicy incorrect

**Solution**:
```bash
# Check pod status
kubectl describe pod <pod-name> -n k8s-demo

# Verify image exists
docker images | grep k8s-demo

# Load local image to Kubernetes (for Minikube)
minikube image load k8s-demo:latest

# Or change imagePullPolicy in deployment.yaml
# imagePullPolicy: IfNotPresent  # Uses local image first
```

#### Issue: "Pod stuck in CrashLoopBackOff"

**Error**:
```
Back-off restarting failed container
```

**Cause**: Application failing to start

**Solution**:
```bash
# View pod logs
kubectl logs <pod-name> -n k8s-demo

# Check liveness probe failure
kubectl describe pod <pod-name> -n k8s-demo | grep -A 5 "Liveness"

# Increase initialDelaySeconds if app takes time to start
# In deployment.yaml: initialDelaySeconds: 60
```

#### Issue: "Readiness probe failing"

**Error**:
```
Readiness probe failed: HTTP probe failed with status 503
```

**Cause**: Application not ready (health endpoint returning error)

**Solution**:
```bash
# Test endpoint manually
kubectl port-forward svc/k8s-demo -n k8s-demo 8080:80
curl http://localhost:8080/actuator/health/readiness

# Check application logs
kubectl logs deployment/k8s-demo -n k8s-demo

# Increase readiness probe timeouts in deployment.yaml
```

#### Issue: "Service not accessible"

**Error**:
```
Connection refused when accessing service
```

**Solution**:
```bash
# Verify service exists
kubectl get svc -n k8s-demo

# Check endpoints
kubectl get endpoints -n k8s-demo

# Port forward and test
kubectl port-forward svc/k8s-demo -n k8s-demo 8080:80
curl http://localhost:8080

# Check DNS
kubectl run -it --rm debug --image=nicolaka/netshoot -- nslookup k8s-demo.k8s-demo.svc.cluster.local
```

#### Issue: "Insufficient resources"

**Error**:
```
0/1 nodes available: 1 Insufficient cpu
```

**Solution**:
```bash
# Check node capacity
kubectl top nodes
kubectl describe node <node-name>

# Reduce resource requests
# In deployment.yaml: resources.requests.cpu: 100m

# Or add more nodes to cluster
minikube addons enable metrics-server
```

#### Issue: "ConfigMap not found"

**Error**:
```
configmap "k8s-demo-config" not found
```

**Solution**:
```bash
# Check ConfigMap exists
kubectl get configmap -n k8s-demo

# Create ConfigMap
kubectl apply -f k8s/configmap.yaml

# Verify
kubectl get configmap -n k8s-demo
kubectl describe configmap k8s-demo-config -n k8s-demo
```

---

### ArgoCD Issues

#### Issue: "ArgoCD Application stuck in 'Syncing'"

**Error**:
```
Application stuck in Syncing state for long time
```

**Solution**:
```bash
# Force sync
argocd app sync k8s-demo --force

# Check application controller logs
kubectl logs -n argocd deployment/argocd-application-controller

# Describe application for more details
kubectl describe application k8s-demo -n argocd
```

#### Issue: "ArgoCD repository access denied"

**Error**:
```
403 Forbidden when accessing repository
```

**Solution**:
```bash
# Check credentials secret
kubectl get secret -n argocd | grep credentials

# Recreate credentials
kubectl create secret generic github-credentials \
  --from-literal=username=your_github_username \
  --from-literal=password=your_github_token \
  -n argocd --dry-run=client -o yaml | kubectl apply -f -

# Or use deploy key in repository settings
```

#### Issue: "ArgoCD can't reach cluster"

**Error**:
```
Unable to connect to cluster
```

**Solution**:
```bash
# Check cluster connection
argocd cluster list

# Verify kubeconfig
kubectl cluster-info

# Check ArgoCD server logs
kubectl logs -n argocd deployment/argocd-server
```

#### Issue: "Manifest validation failed"

**Error**:
```
error validating manifests: error validating: no matches for kind "Deployment"
```

**Cause**: Invalid YAML or missing CRD

**Solution**:
```bash
# Validate manifests locally
kubectl apply -f k8s/ --dry-run=client

# Check for YAML syntax errors
yamllint k8s/

# Install missing CRDs if needed
kubectl apply -f https://github.com/prometheus-operator/prometheus-operator/releases/latest/download/bundle.yaml
```

---

### GitHub Actions Issues

#### Issue: "Secret not available"

**Error**:
```
Could not resolve secret: DOCKER_USERNAME
```

**Solution**:
```bash
# Go to GitHub → Settings → Secrets and variables → Actions
# Add required secrets:
# - DOCKER_USERNAME
# - DOCKER_PASSWORD
# - GITHUB_TOKEN (auto-available)
```

#### Issue: "Workflow job timeout"

**Error**:
```
The operation timed out after 360 seconds
```

**Solution**:
```yaml
# In workflow file, increase timeout-minutes
jobs:
  build:
    timeout-minutes: 30
    runs-on: ubuntu-latest
```

#### Issue: "Docker push fails in CI"

**Error**:
```
unauthorized: authentication required
```

**Solution**:
```bash
# Verify secrets are set
# Check GitHub Actions logs for secret names
# Ensure DOCKER_USERNAME and DOCKER_PASSWORD are correct
# For GHCR, use: username: ${{ github.actor }}
```

---

### Networking Issues

#### Issue: "Port forward doesn't work"

**Error**:
```
Unable to forward port because pod not found
```

**Solution**:
```bash
# Ensure pod is running
kubectl get pods -n k8s-demo

# Verify service name
kubectl get svc -n k8s-demo

# Port forward with correct service name
kubectl port-forward svc/k8s-demo -n k8s-demo 8080:80
```

#### Issue: "DNS resolution fails"

**Error**:
```
Name resolution failed for k8s-demo.k8s-demo.svc.cluster.local
```

**Solution**:
```bash
# Check CoreDNS is running
kubectl get pod -n kube-system -l k8s-app=kube-dns

# Restart CoreDNS
kubectl rollout restart deployment coredns -n kube-system

# Test DNS
kubectl run -it --rm debug --image=nicolaka/netshoot -- nslookup kubernetes.default
```

---

### Performance Issues

#### Issue: "Application running slow"

**Debug steps**:
```bash
# Check resource usage
kubectl top pods -n k8s-demo
kubectl top nodes

# Check logs for errors
kubectl logs deployment/k8s-demo -n k8s-demo --tail=100

# Check probe metrics
kubectl get pod <pod-name> -n k8s-demo -o jsonpath='{.status.conditions[*]}'

# Check JVM memory usage
kubectl exec <pod-name> -n k8s-demo -- jps -l
kubectl exec <pod-name> -n k8s-demo -- jstat -gc 1
```

**Solution**:
```bash
# Increase resource limits in deployment.yaml
resources:
  limits:
    cpu: 1000m
    memory: 1Gi

# Or enable HPA
kubectl get hpa -n k8s-demo

# Check if HPA is scaling
kubectl describe hpa k8s-demo-hpa -n k8s-demo
```

---

## 🔍 Debugging Commands

### Kubernetes Debugging

```bash
# View all pod info
kubectl get pods -n k8s-demo -o wide

# Execute command in pod
kubectl exec -it <pod-name> -n k8s-demo -- /bin/sh

# View container logs
kubectl logs <pod-name> -n k8s-demo
kubectl logs <pod-name> -n k8s-demo -c <container-name>

# View previous logs (after crash)
kubectl logs <pod-name> -n k8s-demo --previous

# Stream logs
kubectl logs -f deployment/k8s-demo -n k8s-demo

# Debug pod
kubectl debug pod/<pod-name> -n k8s-demo -it --image=nicolaka/netshoot

# Get pod events
kubectl get events -n k8s-demo --sort-by='.lastTimestamp'

# Describe pod
kubectl describe pod <pod-name> -n k8s-demo
```

### Docker Debugging

```bash
# View container logs
docker logs <container-id>
docker logs -f <container-id>

# Execute command in running container
docker exec -it <container-id> /bin/sh

# Inspect image layers
docker history k8s-demo:latest

# Check image contents
docker run --rm -it k8s-demo:latest ls -la
```

### ArgoCD Debugging

```bash
# View application details
argocd app get k8s-demo
argocd app get k8s-demo --refresh

# View application status
kubectl describe application k8s-demo -n argocd

# View sync status
argocd app sync-status k8s-demo

# View logs
kubectl logs -f deployment/argocd-application-controller -n argocd
```

---

## 📞 Getting Help

1. **Check logs first**:
   ```bash
   kubectl logs <pod-name> -n k8s-demo
   ```

2. **Describe resources**:
   ```bash
   kubectl describe pod/deployment/service -n k8s-demo
   ```

3. **Check events**:
   ```bash
   kubectl get events -n k8s-demo --sort-by='.lastTimestamp'
   ```

4. **Review manifests**:
   ```bash
   kubectl apply -f k8s/ --dry-run=client
   ```

5. **Test endpoints manually**:
   ```bash
   kubectl port-forward svc/k8s-demo -n k8s-demo 8080:80
   curl http://localhost:8080/actuator/health
   ```

---

## 📚 Additional Resources

- [Kubernetes Troubleshooting](https://kubernetes.io/docs/tasks/debug-application-cluster/debug-application/)
- [Docker Troubleshooting](https://docs.docker.com/config/containers/logging/)
- [ArgoCD Troubleshooting](https://argo-cd.readthedocs.io/en/stable/faq/)
- [GitHub Actions Troubleshooting](https://docs.github.com/en/actions/monitoring-and-troubleshooting-workflows/about-workflow-executions)

