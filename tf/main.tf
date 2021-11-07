terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      # version = "..."
    }
  }
}

# Configure the Linode Provider
provider "linode" {
}

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

resource "local_file" "foo" {
    content     = linode_lke_cluster.my-cluster.kubeconfig
    filename = ".config"
}
