#Create EKS Cluster using eksctl without nodegroup
eksctl create cluster --name=app-cluster-01 \
                     --region=ap-south-1 \
                     --zones=ap-south-1a \
                     --without-nodegroup \
                     --vpc-public-subnets=subnet-0f1efb0007680670f \
                     --vpc-private-subnets=subnet-01ca1a6a489c4822d

# OIDC Provider Creation
eksctl utils associate-iam-oidc-provider \
    --region ap-south-1 \
    --cluster app-cluster-01 \
    --approve

# Create Public Node Group   
eksctl create nodegroup --cluster=app-cluster-01 \
                       --region=ap-south-1 \
                       --name=app-cluster-01-ng-public1 \
                       --node-type=t3.medium \
                       --nodes=2 \
                       --nodes-min=2 \
                       --nodes-max=4 \
                       --node-volume-size=20 \
                       --ssh-access \
                       --ssh-public-key=my-vpc-01-keypair \
                       --subnet-ids=subnet-0f1efb0007680670f,subnet-01ca1a6a489c4822d \
                       --managed \
                       --asg-access \
                       --external-dns-access \
                       --full-ecr-access \
                       --appmesh-access \
                       --alb-ingress-access

eksctl create addon --name eks-pod-identity-agent --cluster app-cluster-01 --region ap-south-1

eksctl create podidentityassociation \
    --cluster "app-cluster-01" \
    --namespace default \
    --region "ap-south-1" \
    --service-account-name eks-pod-identity-role-sa \
    --role-arn $ROLE_ARN \
    --create-service-account true

eksctl create podidentityassociation \
    --cluster "app-cluster-01" \
    --namespace default \
    --region "ap-south-1" \
    --service-account-name eks-pod-identity-role-sa \
    --role-arn $ROLE_ARN \
    --create-service-account true