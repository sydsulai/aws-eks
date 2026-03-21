# AWS EKS Kubernetes Manifests

This repository contains Kubernetes manifests for deploying microservices on Amazon Elastic Kubernetes Service (EKS).

## Application Infrastructure Repo

Github: https://github.com/sydsulai/centralized-platform.git
Directory: https://github.com/sydsulai/centralized-platform/tree/main/application-infrastructure

## Application Cluster Configuration

Github: https://github.com/sydsulai/centralized-platform.git
Directory: https://github.com/sydsulai/centralized-platform/tree/main/app-cluster-configuration

## 📁 Repository Structure

```
eks/
├── README.md                         # This file
└── manifests/
    ├── dummy-app1/                   # Sample nginx application
    │   └── app1-resources.yaml
    ├── dummy-app2/                   # Second sample application
    │   └── app2-resources.yaml
    ├── notifications-services/       # Email notification microservice
    │   ├── notifications-resources.yaml
    │   ├── notifications-hpa.yaml
    │   └── notifications-vpa.yaml
    └── usermanagement-services/      # User management microservice
        └── ums-resources.yaml
```

## 📋 Manifests Overview

### 1. Dummy App 1 (`dummy-app1/app1-resources.yaml`)

**Purpose:** Sample Nginx application for testing basic EKS deployment

**Resources:**

- **Namespace:** `app1-ns`
- **Deployment:** Single replica Nginx pod
- **Image:** `829007908826.dkr.ecr.ap-south-1.amazonaws.com/eks/nginx:1.0.0`
- **Service:** NodePort service on port 80
- **Note:** Includes comments for ALB health check configuration

**Key Features:**

- Basic containerized application deployment
- NodePort service for external access
- Ready for ALB integration with health checks

---

### 2. Dummy App 2 (`dummy-app2/app2-resources.yaml`)

**Purpose:** Second sample application (details pending review)

---

### 3. Notifications Services (`notifications-services/`)

**Purpose:** Email notification microservice with AWS SES integration

**Resources:**

- **Namespace:** `notifications-ns`
- **Secret:** AWS SES SMTP credentials (requires base64 encoding)
- **ExternalName Service:** Routes to AWS SES endpoint (`email-smtp.ap-south-1.amazonaws.com`)
- **Deployment:** Notification microservice pods
- **HPA:** Horizontal Pod Autoscaler for dynamic scaling
- **VPA:** Vertical Pod Autoscaler for resource optimization

**AWS Credentials Required:**

- SMTP Endpoint
- SMTP Username
- SMTP Password
- Mail From Address

**Files:**

- `notifications-resources.yaml` - Core resources (Namespace, Secret, Service, Deployment)
- `notifications-hpa.yaml` - Horizontal scaling configuration
- `notifications-vpa.yaml` - Vertical scaling configuration

---

### 4. User Management Services (`usermanagement-services/`)

**Purpose:** User management microservice with AWS Secrets Manager and RDS integration

**Resources:**

- **Namespace:** `ums-ns`
- **SecretProviderClass:** AWS CSI driver integration for Secrets Manager
- **Deployment:** User management application pods
- **AWS Services:** RDS database with managed secrets

**Features:**

- AWS Secrets Manager integration via CSI driver
- Pod Identity for secure AWS credentials
- Automatic secret injection into pods
- Database connection management (host, port, credentials)

**AWS Secrets Required:**

- Secret path: `eks/ums/rds`
- Contains: hostname, port, dbname, username, password

---

## 🚀 Quick Start

### Prerequisites

- AWS EKS cluster running
- `kubectl` configured with cluster access
- AWS CLI configured with appropriate IAM permissions
- AWS Secrets Manager and RDS configured (for UMS)

### Deployment

**Deploy all manifests:**

```bash
kubectl apply -f manifests/
```

**Deploy specific service:**

```bash
# Deploy Dummy App 1
kubectl apply -f manifests/dummy-app1/

# Deploy Notifications Service
kubectl apply -f manifests/notifications-services/

# Deploy User Management Service
kubectl apply -f manifests/usermanagement-services/
```

### Verify Deployment

```bash
# Check all namespaces
kubectl get ns

# Check deployments in each namespace
kubectl get deployments -A

# Check services
kubectl get svc -A

# Check pods
kubectl get pods -A
```

---

## 🔐 Configuration Notes

### Notifications Service

Before deploying, encode AWS SES credentials in base64:

```bash
echo -n "your-smtp-endpoint" | base64
echo -n "your-smtp-username" | base64
echo -n "your-smtp-password" | base64
echo -n "your-mail-from-address" | base64
```

Update the `notifications-resources.yaml` Secret data section with encoded values.

### User Management Service

Ensure AWS Secrets Manager secret exists at path `eks/ums/rds` with the following JSON structure:

```json
{
  "host": "your-rds-endpoint",
  "port": "3306",
  "dbname": "your-database",
  "username": "your-username",
  "password": "your-password"
}
```

---

## 📊 Scaling Configuration

### Notifications Service Scaling

- **HPA** (`notifications-hpa.yaml`): Horizontal scaling based on metrics
- **VPA** (`notifications-vpa.yaml`): Vertical scaling for resource optimization

Monitor scaling:

```bash
kubectl get hpa -n notifications-ns
kubectl get vpa -n notifications-ns
```

---

## 📝 Region & AWS Account Notes

- **Region:** `ap-south-1` (Asia Pacific - Mumbai)
- **AWS Account:** `829007908826`
- **ECR Registry:** `829007908826.dkr.ecr.ap-south-1.amazonaws.com`

---

## ⚠️ Important Considerations

1. **Image Registry:** Update ECR image paths for your AWS account
2. **Secrets Management:** Never commit actual credentials; use base64 encoding or AWS Secrets Manager
3. **Health Checks:** App1 includes ALB health check configuration - uncomment as needed
4. **Pod Identity:** UMS uses Pod Identity for secure AWS credential access
5. **CSI Driver:** Ensure AWS Secrets Manager CSI driver is installed on your cluster

---

## 📖 Additional Resources

- [AWS EKS Documentation](https://docs.aws.amazon.com/eks/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [AWS Secrets Manager CSI Driver](https://github.com/aws/secrets-store-csi-driver-provider-aws)
- [Kubernetes HPA/VPA](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/)

---

## 📄 License & Support

For questions or issues, review individual manifest files for configuration details.