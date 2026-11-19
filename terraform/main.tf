terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.16"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

# 1. Install ArgoCD (NodePort 30081)
resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true

  set {
    name  = "configs.params.server\\.insecure"
    value = "true"
  }
  set {
    name  = "server.service.type"
    value = "NodePort"
  }
  set {
    name  = "server.service.nodePortHttp"
    value = "30081"
  }
}

# 2. Install Prometheus (NodePort 30083) + Grafana (NodePort 30082)
resource "helm_release" "monitoring" {
  name             = "monitoring"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "monitoring"
  create_namespace = true

  set {
    name  = "grafana.adminPassword"
    value = "admin123"
  }
  set {
    name  = "grafana.service.type"
    value = "NodePort"
  }
  set {
    name  = "grafana.service.nodePort"
    value = "30082"
  }
  set {
    name  = "prometheus.service.type"
    value = "NodePort"
  }
  set {
    name  = "prometheus.service.nodePort"
    value = "30083"
  }
}
