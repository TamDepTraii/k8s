# ✅ ARGOCD SETUP - QUICK START

**Status**: ✅ INSTALLED & RUNNING  
**Date**: 2025-10-27  

---

## 🚀 QUICK ACCESS

### ArgoCD UI
```
URL: https://localhost:8080

Credentials:
├─ Username: admin
└─ Password: 7V9NRAkYa6A-VkaU
```

### Access Steps
1. Open: https://localhost:8080
2. Login: admin / 7V9NRAkYa6A-VkaU
3. View application: k8s-demo-app
4. Check sync status

---

## 📊 WHAT'S SETUP

✅ **ArgoCD Installed**
- Namespace: argocd
- All pods running

✅ **Application Created**
- Name: k8s-demo-app
- Repo: https://github.com/TamDepTraii/k8s.git
- Path: k8s/
- Sync: Automatic (auto-heal, prune)

✅ **Auto-Sync Enabled**
- Automatic sync when Git changes
- Self-heal enabled
- Prune enabled

---

## 🔧 COMMANDS

```bash
# Check ArgoCD pods
kubectl get pods -n argocd

# Check application status
kubectl get application -n argocd
kubectl describe application k8s-demo-app -n argocd

# View logs
kubectl logs -f deployment/argocd-server -n argocd

# Port-forward (if stopped)
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

---

## 📝 HOW IT WORKS

1. **GitHub Push** → Code changes
2. **ArgoCD Watches** → Detects changes
3. **Auto-Sync** → Deploys automatically
4. **Application Updates** → New version running

---

## 🎯 WORKFLOW

```
You push code to GitHub main branch
    ↓
ArgoCD detects changes in k8s/ folder
    ↓
ArgoCD syncs deployment automatically
    ↓
New version deployed to Kubernetes
    ↓
Check status in ArgoCD UI (localhost:8080)
```

---

## ✨ FEATURES

✅ GitOps workflow
✅ Automatic deployment
✅ Self-healing
✅ Declarative configs
✅ Single source of truth (Git)

---

## 🧪 TEST IT

1. **Access UI**: https://localhost:8080
2. **Login**: admin / 7V9NRAkYa6A-VkaU
3. **View App**: k8s-demo-app
4. **Check Sync**: Should show "Synced"
5. **View Pods**: Deployment in k8s-demo namespace

---

## 📚 NEXT

Try making a change to k8s deployment files and pushing to Git - ArgoCD will auto-deploy!

```bash
# Example: Modify k8s/deployment.yaml
# Push to GitHub
git add k8s/deployment.yaml
git commit -m "Update deployment"
git push origin main

# ArgoCD will auto-sync within ~30 seconds
# Check: https://localhost:8080
```

---

**Status**: 🟢 ArgoCD Ready!
**Access**: https://localhost:8080
**User**: admin
**Pass**: 7V9NRAkYa6A-VkaU

