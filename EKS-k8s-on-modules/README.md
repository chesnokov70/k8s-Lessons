# Terraform: EKS Cluster by Modules

**Deploys an EKS cluster on AWS using Terraform modules.**

**Minimum Files for creating an EKS cluster:**
* `00-locals.tf`: Defines local variables.
* `01-providers.tf`: Configures the AWS provider.
* `02-vpc.tf`: Creates the VPC.
* `03-eks.tf`: Creates the EKS cluster.

Run `terraform apply` to create the resources. It may take up to 10-15 minutes to create the EKS cluster.

**Update your local kubeconfig to connect to the cluster:**
1. Update kubeconfig: `aws eks update-kubeconfig --name dev-eks-by-modules`
2. Verify connection: `kubectl get nodes`

### Connecting to Your Cluster with OpenLens

Once you've successfully deployed your cluster, you can use OpenLens.

**Installing OpenLens:**
* Download the latest version of OpenLens: [download OpenLens](https://github.com/MuhammedKalkan/OpenLens/releases)
* Follow the installation instructions for your operating system.

**Connecting to Cluster with OpenLens:**
1. Launch OpenLens.
2. Click "Connect" to your cluster.

### Deploying a Metric Server - file 05-metrics_server.tf

The file provides two deployment options. Choose one deployment option and run `terraform apply` to create the resources:
1. Helm chart: deploy file 05-metrics_server.tf
2. EKS Blueprint addon: uncomment the block in file 04-eks-addons.tf

Run the following command to check Metric Server:

```shell
kubectl kubectl top pods -A
```

### Deploying a Cluster Autoscaler and Pod Autoscaler - file 06-cluster_autoscaler.tf

The file provides two deployment options. Choose one deployment option and run `terraform apply` to create the resources:
1. Helm chart: deploy file 06-cluster_autoscaler.tf
2. EKS Blueprint addon: uncomment the block in file 04-eks-addons.tf

#### Check Cluster Autoscaler

Apply the file 1-test-cluster_autoscaler.yaml to check Cluster Autoscaler. After a couple of minutes, your cluster should be scaled (the number of EC2 instances are scaled).

```shell
kubectl apply -f 1-test-cluster_autoscaler.yaml
```
Don't forget to destroy. After a 5-10 minutes, your cluster should be unscaled.

```shell
kubectl delete -f 1-test-cluster_autoscaler.yaml
```
#### Check Pod Autoscaler

Apply the file 2-test-hpa-autoscaler.yaml to check Pod Autoscaler.
```shell
kubectl apply -f 2-test-hpa-autoscaler.yaml
```
This deployment creates a Pod with a CPU stress load 95%. 
After a couple of minutes, your POD should be scaled. You can check the CPU usage by running the following command:
```shell
kubectl kubectl top pods -A
```
Don't forget to destroy. After a couple of minutes, your PODs should be unscaled.

```shell
kubectl delete -f 2-test-hpa-autoscaler.yaml
```

### Deploying a AWS Load Balancer - file 07-aws_load_balancer.tf

The file provides two deployment options. Choose one deployment option and run `terraform apply` to create the resources:
1. Helm chart
2. EKS Blueprint addon

#### Check AWS Network Load Balancer without Ingress

Apply the file 3-test-nlb-without-ingress.yaml to check AWS Network Load Balancer without Ingress.

```shell
kubectl apply -f 3-test-nlb-without-ingress.yaml
```
To check the load balancer just follow the link from the AWS Load Balancer in AWS account.

Don't forget to destroy. 

```shell
kubectl delete -f 3-test-nlb-without-ingress.yaml
```

## For check next 4 steps better to have an own domain and added in AWS Route53

#### Check AWS Application Load Balancer without Ingress

1. Change host in file 4-test-alb-with-ingress.yaml to your domain
2. Apply the file
3. Add A-record to your domain with DNS from Load Balancer
```shell
kubectl apply -f 4-test-alb-with-ingress.yaml
```
Don't forget to destroy.

#### Check AWS Application Load Balancer with Ingress and SSL/HTTPS/TLS
1. Change host in file 5-test-alb-with-ingress-and-SSL.yaml to your domain
2. Apply the file
3. Add CNAME-record to your domain with DNS from Load Balancer
```shell
kubectl apply -f 5-test-alb-with-ingress-and-SSL.yaml
```
Don't forget to destroy.

### Deploying a NGINX-Ingress - file 08-nginx-ingress.tf

The file provides two deployment options. Choose one deployment option and run `terraform apply` to create the resources:
1. Helm chart
2. EKS Blueprint addon

#### Check NGINX-Ingress without Cert manager
1. Change host in file 6-test-nginx-ingress-without-cert-manager.yaml to your domain
2. Apply the file
3. Add A-record to your domain with DNS from Load Balancer

```shell
kubectl apply -f 6-test-nginx-ingress-without-cert-manager.yaml
```
Don't forget to destroy.
### Deploying a Cert manager - file 09-cert-manager.tf
The file provides two deployment options. Choose one deployment option and run `terraform apply` to create the resources:
1. Helm chart
2. EKS Blueprint addon
#### Check NGINX-Ingress with Cert manager
1. Change host in file 6-test-nginx-ingress-without-cert-manager.yaml to your domain
2. Apply the file
3. Add CNAME-record to your domain with DNS from Load Balancer
```shell
kubectl apply -f 7-test-nginx-ingress-with-cert-manager.yaml
```
Don't forget to destroy.

### Deploying a EBS CSI Driver and creating Persistent Volumes - file 10-ebs.tf

The file provides two deployment options. Choose one deployment option:
1. Helm chart
2. EKS Blueprint addon

#### Check EBS CSI Driver

Apply the file 9-ebs.yaml to check EBS CSI Driver.
```shell
kubectl apply -f 8-test-ebs-and-StatefulSet.yaml
```
Check the AWS account for existing a new EBS volume or check OpenLens

Don't forget to destroy.


Uninstall cluster

```shell
terraform destroy --target module.eks_blueprints_addons.module.ingress_nginx.helm_release.this -auto-approve
terraform destroy -auto-approve
```

If the cluster is stuck in destruction VPC you need to remove:
- all load balancers with target groups
- security groups created for load balancers, ingress, grafana, etc in AWS account.