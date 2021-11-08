# Kubernetes cluster
resource "linode_lke_cluster" "my-cluster" {
    label       = "photoready"
    k8s_version = "1.21"
    region      = "eu-central"
    tags        = ["tests"]

    pool {
        type  = "g4-standard-2"
        count = 1

        autoscaler {
          min = 1
          max = 3
        }
    }
}

# Generating kubeconfig file
resource "local_file" "konfig" {
    content     = base64decode(linode_lke_cluster.my-cluster.kubeconfig)
    filename = "/tmp/.linodekubeconfig"
}