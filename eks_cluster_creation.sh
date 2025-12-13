#Create EKS Cluster using eksctl without nodegroup
eksctl create cluster --name=app-cluster-01 \
                     --region=ap-south-1 \
                     --without-nodegroup \
                     --vpc-public-subnets=subnet-0b4db1c17220238c4,subnet-0cded58acaec1936f \
                     --vpc-private-subnets=subnet-019d2f62f16e40c52,subnet-0eae9c1f7fd38efe3

# OIDC Provider Creation
eksctl utils associate-iam-oidc-provider \
    --region ap-south-1 \
    --cluster app-cluster-01 \
    --approve

# Create Private Node Group   
eksctl create nodegroup --cluster=app-cluster-01 \
                       --region=ap-south-1 \
                       --name=app-cluster-01-ng-private1 \
                       --node-type=t3.micro \
                       --nodes=2 \
                       --nodes-min=2 \
                       --nodes-max=4 \
                       --node-volume-size=20 \
                       --ssh-access \
                       --ssh-public-key=my-vpc-01-keypair \
                       --subnet-ids=subnet-019d2f62f16e40c52,subnet-0eae9c1f7fd38efe3 \
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
                       --node-type=t3.micro \
                       --nodes=2 \
                       --nodes-min=2 \
                       --nodes-max=4 \
                       --node-volume-size=20 \
                       --ssh-access \
                       --ssh-public-key=my-vpc-01-keypair \
                       --subnet-ids=subnet-0b4db1c17220238c4,subnet-0cded58acaec1936f \
                       --managed \
                       --asg-access \
                       --external-dns-access \
                       --full-ecr-access \
                       --appmesh-access \
                       --alb-ingress-access

eksctl create addon --name eks-pod-identity-agent --cluster app-cluster-01 --region ap-south-1 --service-account-role-arn arn:aws:iam::829007908826:role/eks-pod-identity-role

eksctl create addon --name aws-ebs-csi-driver --cluster app-cluster-01 --region ap-south-1 --service-account-role-arn arn:aws:iam::829007908826:role/eks-pod-identity-role-csi

eksctl create addon --name aws-secrets-store-csi-driver-provider --cluster app-cluster-01 --region ap-south-1 --service-account-role-arn arn:aws:iam::829007908826:role/eks-pod-identity-role

# Install AWS Secrets Store CSI Driver using Helm [Aws Managed Addon not available]
helm repo add secrets-store-csi-driver https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts
helm repo update
helm install csi-secrets-store secrets-store-csi-driver/secrets-store-csi-driver --namespace kube-system

# Install AWS Secrets Store CSI Driver Provider
kubectl apply -f https://raw.githubusercontent.com/aws/secrets-store-csi-driver-provider-aws/main/deployment/aws-provider-installer.yaml

eksctl create podidentityassociation \
    --cluster "app-cluster-01" \
    --namespace default \
    --region "ap-south-1" \
    --service-account-name eks-pod-identity-role-csi-sa \
    --role-arn arn:aws:iam::829007908826:role/eks-pod-identity-role-csi \
    --create-service-account true

eksctl create podidentityassociation \
    --cluster "app-cluster-01" \
    --namespace default \
    --region "ap-south-1" \
    --service-account-name eks-pod-identity-role-sa \
    --role-arn arn:aws:iam::829007908826:role/eks-pod-identity-role \
    --create-service-account true

# Delete addons

eksctl delete addon --name eks-pod-identity-agent --cluster app-cluster-01 --region ap-south-1

eksctl delete addon --name aws-ebs-csi-driver --cluster app-cluster-01 --region ap-south-1

eksctl delete addon --name aws-secrets-store-csi-driver-provider --cluster app-cluster-01 --region ap-south-1

eksctl delete addon --name metrics-server --cluster app-cluster-01 --region ap-south-1

eksctl delete addon --name vpc-cni --cluster app-cluster-01 --region ap-south-1

eksctl delete addon --name coredns --cluster app-cluster-01 --region ap-south-1

eksctl delete addon --name kube-proxy --cluster app-cluster-01 --region ap-south-1

eksctl delete nodegroup --cluster=app-cluster-01 \
                       --region=ap-south-1 \
                       --name=app-cluster-01-ng-private1

eksctl delete cluster --name=app-cluster-01 \
                     --region=ap-south-1 