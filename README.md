# photoready
Postgresql and redis example

## Requirements
* Kubernetes engine - Recomended [Rancher Desktop](https://www.suse.com/c/rancher_blog/rancher-desktop-an-open-source-app-for-desktop-kubernetes-and-container-management/) but it can be used [k3d](https://k3d.io/v5.0.3/) or minikube
* Docker envaironoment - If using Rancher Desktop it's recomended [nerdctl](https://github.com/containerd/nerdctl)
* DevSpace - Live dev tool [Quickstart](https://github.com/loft-sh/devspace#quickstart)
* Visual Studio - IDE

## Build Service Image
* Using nerdctl and docker namespaces:
```bash
 $ alias docker=nerdctl
 $ docker -n k8s.io build -t photoready .
 ```

 ## Deploy Redis, Postgres and service
```bash
 $ kustomize build kustomize/base | kubectl apply -f
 ```
## Restart photoready service
```bash
$ kubectl rollout restart deploy photoready
```