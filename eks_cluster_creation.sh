#Create EKS Cluster using eksctl without nodegroup
eksctl create cluster --name=app-cluster-01 \
                     --region=ap-south-1 \
                     --without-nodegroup \
                     --vpc-public-subnets=subnet-0d4478f3a5f58d8fd,subnet-0b2c40f7c2ab633b2 \
                     --vpc-private-subnets=subnet-0ec98a1e0e5be71b9,subnet-05aef20d5f16faa08

# OIDC Provider Creation
eksctl utils associate-iam-oidc-provider \
    --region ap-south-1 \
    --cluster app-cluster-01 \
    --approve

# Create Private Node Group   
eksctl create nodegroup --cluster=app-cluster-01 \
                       --region=ap-south-1 \
                       --name=app-cluster-01-ng-private1 \
                       --node-type=t3.2xlarge \
                       --nodes=2 \
                       --nodes-min=2 \
                       --nodes-max=4 \
                       --node-volume-size=20 \
                       --ssh-access \
                       --ssh-public-key=my-vpc-01-keypair \
                       --subnet-ids=subnet-0ec98a1e0e5be71b9,subnet-05aef20d5f16faa08 \
                       --node-private-networking \
                       --managed \
                       --asg-access \
                       --external-dns-access \
                       --full-ecr-access \
                       --appmesh-access \
                       --alb-ingress-access

# Create Public Node Group because of invalid NAT Gateway [Reduction of Cost for demo]
eksctl create nodegroup --cluster=app-cluster-01 \
                       --region=ap-south-1 \
                       --name=app-cluster-01-ng-public1 \
                       --node-type=t3.2xlarge \
                       --nodes=2 \
                       --nodes-min=2 \
                       --nodes-max=4 \
                       --node-volume-size=20 \
                       --ssh-access \
                       --ssh-public-key=my-vpc-01-keypair \
                       --subnet-ids=subnet-0d4478f3a5f58d8fd,subnet-0b2c40f7c2ab633b2 \
                       --managed \
                       --asg-access \
                       --external-dns-access \
                       --full-ecr-access \
                       --appmesh-access \
                       --alb-ingress-access

eksctl create addon --name eks-pod-identity-agent --cluster app-cluster-01 --region ap-south-1 --service-account-role-arn arn:aws:iam::829007908826:role/eks-pod-identity-role

# eksctl create addon --name aws-ebs-csi-driver --cluster app-cluster-01 --region ap-south-1 --service-account-role-arn arn:aws:iam::829007908826:role/eks-pod-identity-role-csi

eksctl create addon --name aws-secrets-store-csi-driver-provider --cluster app-cluster-01 --region ap-south-1 --service-account-role-arn arn:aws:iam::829007908826:role/eks-pod-identity-role

eksctl create podidentityassociation \
    --cluster app-cluster-01 \
    --namespace app-namespace \
    --region ap-south-1 \
    --service-account-name ums-pod-identity-deployment-sa \
    --role-arn arn:aws:iam::829007908826:role/eks-pod-identity-role \
    --create-service-account true

eksctl create iamserviceaccount --name ums-pod-identity-deployment-sa  --namespace app-namespace --cluster app-cluster-01 \
    --attach-role-arn arn:aws:iam::829007908826:role/eks-pod-identity-role --approve

# AWS Load Balancer Controller
# curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.14.1/docs/install/iam_policy.json

# aws iam create-policy \
#     --policy-name AWSLoadBalancerControllerIAMPolicy \
#     --policy-document file://iam_policy.json

eksctl create iamserviceaccount \
    --cluster=app-cluster-01 \
    --namespace=kube-system \
    --name=aws-load-balancer-controller \
    --attach-policy-arn=arn:aws:iam::829007908826:policy/AWSLoadBalancerControllerIAMPolicy \
    --override-existing-serviceaccounts \
    --region ap-south-1 \
    --approve

helm repo add eks https://aws.github.io/eks-charts

helm repo update eks

helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=my-cluster \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --version 1.14.0


# Delete addons

# eksctl delete addon --name eks-pod-identity-agent --cluster app-cluster-01 --region ap-south-1

# eksctl delete addon --name aws-ebs-csi-driver --cluster app-cluster-01 --region ap-south-1

# eksctl delete addon --name aws-secrets-store-csi-driver-provider --cluster app-cluster-01 --region ap-south-1

# eksctl delete addon --name metrics-server --cluster app-cluster-01 --region ap-south-1

# eksctl delete addon --name vpc-cni --cluster app-cluster-01 --region ap-south-1

# eksctl delete addon --name coredns --cluster app-cluster-01 --region ap-south-1

# eksctl delete addon --name kube-proxy --cluster app-cluster-01 --region ap-south-1

# eksctl delete nodegroup --cluster=app-cluster-01 \
#                        --region=ap-south-1 \
#                        --name=app-cluster-01-ng-private1

# eksctl delete cluster --name=app-cluster-01 \
#                      --region=ap-south-1