resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "5.51.4"
  namespace        = "argocd"
  create_namespace = true

  values = [
    <<EOF
server:
  ingress:
    enabled: true
    annotations:
      kubernetes.io/ingress.class: nginx
      nginx.ingress.kubernetes.io/ssl-redirect: "false" # Вимкнути редирект
      nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
    hosts:
      - "argocd.a3888s.test-danit.com" # Замініть на вашу групу

  extraArgs:
    - --insecure

repoServer:
  serviceAccount:
    create: true
EOF
  ]
}
