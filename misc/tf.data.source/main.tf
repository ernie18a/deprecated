terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}
provider "kubernetes" {
  config_path = "~/.kube/config"
}

data "kubernetes_pod" "existing_pod" {
  metadata {
    name      = "nginx-ernie-test"
    namespace = "default"
  }
}

resource "kubernetes_pod" "updated_pod" {
  metadata {
    name      = "nginx-ernie-test4"
    namespace = data.kubernetes_pod.existing_pod.metadata[0].namespace
  }
}

