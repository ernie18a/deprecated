terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }

  backend "kubernetes" {
    config_path   = "~/.kube/config"
    secret_suffix = "tfstate"
    namespace     = "default"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_pod_v1" "nginx_ernie_test" {
  metadata {
    name = "nginx-ernie-test"
    namespace = "default"
  }
  spec {
    container {
      name  = "nginx"
      image = "nginx:alpine-slim"
      port {
        container_port = 80
      }
    }
  }
}
resource "kubernetes_pod_v1" "nginx_ernie_test2" {
  metadata {
    name = "nginx-ernie-test2"
    namespace = "default"
  }
  spec {
    container {
      name  = "nginx"
      image = "nginx:alpine-slim"
      port {
        container_port = 80
      }
    }
  }
}
resource "kubernetes_pod_v1" "nginx_ernie_test3" {
  metadata {
    name = "nginx-ernie-test3"
    namespace = "default"
  }
  spec {
    container {
      name  = "nginx"
      image = "nginx:alpine-slim"
      port {
        container_port = 80
      }
    }
  }
}

resource "kubernetes_service" "nginx_ernie_test_service" {
  metadata {
    name = "nginx-ernie-test"
    namespace = "default"
  }
  spec {
    type = "LoadBalancer"
    selector = {
      app = "nginx-ernie-test"
    }
    port {
      port        = 80
      target_port = 80
    }
  }
}

