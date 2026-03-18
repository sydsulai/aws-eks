provider "aws" {
    region     = "ap-south-1"
    profile    = "default"
}

data "aws_eks_cluster" "app_cluster_01" {
    name = aws_eks_cluster.app_cluster_01.name
}

data "aws_eks_cluster_auth" "app_cluster_01" {
    name = aws_eks_cluster.app_cluster_01.name
}

provider "kubernetes" {
    host                   = data.aws_eks_cluster.app_cluster_01.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.app_cluster_01.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.app_cluster_01.token
}