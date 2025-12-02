# IAM role for EKS Pod Identity with S3 full access
resource "aws_iam_role" "eks_pod_identity_role" {
    name = "eks-pod-identity-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Principal = {
                    Service = "pods.eks.amazonaws.com"
                }
                Action = [
                    "sts:AssumeRole",
                    "sts:TagSession"
                ]
            }
        ]
    })

    tags = {
        Name = "EKS Pod Identity Role"
    }
}

# Attach Secrets Manager read access policy to the role
resource "aws_iam_policy" "access_secret_policy" {
    name = "nginx-deployment-policy"
    
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = [
                    "secretsmanager:GetSecretValue",
                    "secretsmanager:DescribeSecret"
                ]
                Resource = ["arn:aws:secretsmanager:ap-south-1:829007908826:secret:eks/ums/mysql-cQN6KZ"]
            }
        ]
    })
}

# Attach S3 full access policy to the role
resource "aws_iam_role_policy_attachment" "s3_full_access" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
    role       = aws_iam_role.eks_pod_identity_role.name
}

resource "aws_iam_role_policy_attachment" "access_secret_policy_attachment" {
    policy_arn = aws_iam_policy.access_secret_policy.arn
    role       = aws_iam_role.eks_pod_identity_role.name
}

resource "aws_iam_role" "eks_pod_identity_role_ebs_csi" {
    name = "eks-pod-identity-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Principal = {
                    Service = "pods.eks.amazonaws.com"
                }
                Action = [
                    "sts:AssumeRole",
                    "sts:TagSession"
                ]
            }
        ]
    })

    tags = {
        Name = "EKS Pod Identity Role"
    }
}

# Attach EBS CSI Driver policy to the role
resource "aws_iam_role_policy_attachment" "ebs_csi_driver" {
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
    role       = aws_iam_role.eks_pod_identity_role_ebs_csi.name
}

# Attach EKS Cluster policy to the role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role       = aws_iam_role.eks_pod_identity_role_ebs_csi.name
}