# IAM role for EKS Pod Identity with S3 full permissions
resource "aws_iam_role" "eks_pod_identity_role" {
    name = "eks-pod-identity-s3-role"

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
        Name = "EKS Pod Identity S3 Role"
    }
}

# Attach S3 full access policy to the role
resource "aws_iam_role_policy_attachment" "s3_full_access" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
    role       = aws_iam_role.eks_pod_identity_role.name
}