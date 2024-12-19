resource "kubernetes_manifest" "step_final_app_dev" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "step-final-dev"
      namespace = "argocd"
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "https://github.com/a3888s/step-final.git"
        targetRevision = "dev"
        path           = "app/k8s"
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "dev"
      }
      syncPolicy = {
        automated = {
          prune     = true
          selfHeal  = true
        }
      }
    }
  }
}

resource "kubernetes_manifest" "step_final_app_prod" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "step-final-prod"
      namespace = "argocd"
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "https://github.com/a3888s/step-final.git"
        targetRevision = "main"
        path           = "app/k8s"
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "prod"
      }
      syncPolicy = {
        automated = {
          prune     = false
          selfHeal  = false
        }
      }
    }
  }
}
