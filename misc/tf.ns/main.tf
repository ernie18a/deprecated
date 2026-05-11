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
# resource "kubernetes_namespace" "random-string" {
#   metadata {
#     name = "customized-ns-name"
#   }
# }
data "kubernetes_namespace" "example" {
  metadata {
    name = "default"
  }
}
output "namespace_id" {
  value = data.kubernetes_namespace.example.metadata[0].uid
}
output "namespace_name" {
  value = data.kubernetes_namespace.example.metadata[0].name
}
