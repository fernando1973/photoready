# photoready
Postgresql and redis example.With this repository we try to show how we can use Rancher Desktop, Devspace and Kustomize to build the service docker image and also deploy it locally as on production/test.This repository it's prepared to integrate with any Ci tool like, Jenkins, Argo Workflows, Gitlab Ci, etc.We can use Devspace to deploy to production but I suggest to use ArgoCD, FluxCD or any other GitOps Tool.
## Requirements
* Kubernetes engine - Tested with [Rancher Desktop](https://www.suse.com/c/rancher_blog/rancher-desktop-an-open-source-app-for-desktop-kubernetes-and-container-management/) but it can be used [k3d](https://k3d.io/v5.0.3/) or minikube
* [kustomize](https://kubectl.docs.kubernetes.io/installation/kustomize/binaries/)
* Docker - If using Rancher Desktop it's not needed. Rancher Desktop install, [nerdctl](https://github.com/containerd/nerdctl)
* [DevSpace](https://github.com/loft-sh/devspace#quickstart) - Live development tool 
* Visual Studio Code - IDE (Optional)
## Build Service Image.
Tested with Rancher Desktop
Using devspace and nerdctl with docker namespaces:
```bash
 $ devspace build
```
# Local Development
### Deploy only on local kubernetes.
This may take some minutes to startup the Postgres and Redis cluster for the first time
```bash
$ devspace deploy
 ... 
$ kubectl get pods
NAME                                 READY   STATUS    RESTARTS   AGE
postgres-operator-569b58b8c6-wc2vl   1/1     Running   0          33m
redis-leader-84b544548f-qzl5c        1/1     Running   0          33m
photoready-69649d64c9-gqjzq          1/1     Running   0          60s
acid-photoready-0                    1/1     Running   0          32m
```
### Creating port-forward for tests
```bash
$ devspace open
```
### Editing php files and testing them on local kubernetes cluster live
```bash
$ devspace dev or devspace sync
```
# Production
To simulate production is deployed a kustomization with two replicas of postgres and three of Redis
```bash
$ devspace deploy -p production
  ...
$ kubectl get pods
NAME                                 READY   STATUS    RESTARTS   AGE
postgres-operator-569b58b8c6-wc2vl   1/1     Running   0          30m
redis-leader-84b544548f-qzl5c        1/1     Running   0          30m
redis-follower-b8986d699-s9zzd       1/1     Running   0          2m2s
redis-follower-b8986d699-vqzq6       1/1     Running   0          2m2s
photoready-6465488db7-qdhsg          1/1     Running   0          2m2s
acid-photoready-0                    1/1     Running   0          29m
acid-photoready-1                    1/1     Running   0          119s
```