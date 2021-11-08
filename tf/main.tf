module "lke" {
  source = "./lke"
}
resource "null_resource" "argocd_ns" {
  provisioner "local-exec" {
    command = "kubectl --kubeconfig /tmp/.linodekubeconfig create ns argocd"
  }

  depends_on = [
    module.lke
  ]
}
resource "null_resource" "argocd_apply" {
  provisioner "local-exec" {
    command = "kubectl --kubeconfig /tmp/.linodekubeconfig apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"
  }

  depends_on = [
    module.lke,
    null_resource.argocd_ns
  ]
}
resource "null_resource" "argocd_wait" {
  provisioner "local-exec" {
    command = "kubectl --kubeconfig /tmp/.linodekubeconfig rollout -n argocd status deploy argocd-server"
  }

  depends_on = [
    module.lke,
    null_resource.argocd_ns,
    null_resource.argocd_apply
  ]
}
resource "null_resource" "argocd_get_credencials" {
  provisioner "local-exec" {
    command = "kubectl --kubeconfig /tmp/.linodekubeconfig get -n argocd secret argocd-initial-admin-secret -o jsonpath=\"{.data.password}\" | base64 -d"
  }

  depends_on = [
    module.lke,
    null_resource.argocd_ns,
    null_resource.argocd_apply,
    null_resource.argocd_wait

  ]
}
resource "null_resource" "argocd_applications" {
  provisioner "local-exec" {
    command = "kubectl --kubeconfig /tmp/.linodekubeconfig apply -n argocd -f applications.yaml"
  }

  depends_on = [
    module.lke,
    null_resource.argocd_ns,
    null_resource.argocd_apply,
    null_resource.argocd_wait

  ]
}
