# IAM роль для EKS кластера
resource "aws_iam_role" "cluster" {
  name = "${var.name}-eks-role"

  # Політика, яка дозволяє сервісу EKS використовувати цю роль
  assume_role_policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "eks.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  POLICY

  # Теги для ідентифікації ресурсу
  tags = merge(
    var.tags,
    { Name = "${var.name}-eks-role" }
  )
}

# Прикріплення необхідних політик до ролі кластера
resource "aws_iam_role_policy_attachment" "kubeedge-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role_policy_attachment" "kubeedge-cluster-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.cluster.name
}

# Отримання сертифіката провайдера OIDC
data "tls_certificate" "cert" {
  url = aws_eks_cluster.danit.identity[0].oidc[0].issuer
}

# Визначення провайдера OIDC для кластера
resource "aws_iam_openid_connect_provider" "openid_connect" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cert.certificates.0.sha1_fingerprint]
  url             = aws_eks_cluster.danit.identity[0].oidc[0].issuer
}

# Модуль для отримання деталей провайдера OIDC
module "oidc-provider-data" {
  source     = "reegnz/oidc-provider-data/aws"
  version    = "0.0.3"
  issuer_url = aws_eks_cluster.danit.identity[0].oidc[0].issuer
}

# IAM роль для вузлів (Node Group)
resource "aws_iam_role" "danit-node" {
  name = "${var.name}-eks-node"

  # Політика, яка дозволяє EC2 інстансам використовувати цю роль
  assume_role_policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  POLICY

  # Теги для ідентифікації ресурсу
  tags = merge(
    var.tags,
    { Name = "${var.name}-eks-node-role" }
  )
}

# Політика для доступу до секретів AWS (опціонально)
resource "aws_iam_policy" "secrets_policy" {
  name        = "GetSecrets"
  path        = "/"
  description = "Політика для доступу до секретів AWS"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid      = "AllowListHostedZones1",
        Effect   = "Allow",
        Action   = [
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets"
        ],
        Resource = "*"
      }
    ]
  })
}

# Прикріплення політики доступу до секретів до ролі вузлів
resource "aws_iam_role_policy_attachment" "kubeedge-node-AmazonSecretsPolicy" {
  policy_arn = aws_iam_policy.secrets_policy.arn
  role       = aws_iam_role.danit-node.name
}

# Прикріплення необхідних політик AWS до ролі вузлів
resource "aws_iam_role_policy_attachment" "kubeedge-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.danit-node.name
}

resource "aws_iam_role_policy_attachment" "kubeedge-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.danit-node.name
}

resource "aws_iam_role_policy_attachment" "kubeedge-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.danit-node.name
}
