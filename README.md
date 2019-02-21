## Kubernetes Cluster with KOPS on AWS
- **Build multi-master cluster on existing network Infrastrcture such as existing VPC, Subnets! With three masters and nodes**
- **Customize cluster with machine type, AMI and AWS Private HostedZone**


1. **Create User or Instance role with Policies below**
    * EC2 Full Access
    * S3 Full Access
    * IAM Full Access
    * Route53 Full Access

1. **Create Network Infrastructure**
    * Skip this step to use existing Network Infrastructure. Follow terraform project to build VPC, subnets and NAT Gateway

1. **Create Private Hosted Zone**
    * Services ->  Route53 -> Hosted Zones
    * Create Hosted Zone 
    * Domain Name : k8scluster.local or your choice
    * Type : Private Hosted Zone for Amazon VPC
1. **VPC Settings**
    1. enableDnsHostnames ( Services -> VPC -> Select VPC -> Edit DNS Hostname : Yes : Save )
    2. enableDnsSupport ( Services -> VPC -> Select VPC -> Edit DNS Resolution : Yes: Save )
1. **Launch EC2 instance or download AWS User Credentails to Mac/Linux workstation**
    * Select IAM role created in `Step:1` for your EC2 Instance
1. **Download `KOPS` and `kubectl`**
    ```
    wget https://github.com/kubernetes/kops/releases/download/1.8.0/kops-linux-amd64
    ```
    ```
    curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
    ```
    ```
    chmod +x kops-linux-amd64 kubectl
    sudo mv kops-linux-amd64 /usr/local/bin/kops
    sudo mv kubectl /usr/local/bin/
    ```
    
    **Note: Make sure to download latest and comptiable versions for your Linux or Mac**
1. **Create S3 Bucket**
    * Service -> S3 : Create Bucket
    * Name : your-clustername.k8scluster.local
    * Enable versioning
    * No public access, make it private  
1. **Create ssh-key**
    ```
    ssh-keygen -t rsa -b 4096 -C "e-mail"
    ```

1. **KOPS use s3 bucket to save configuration** 
    ```
    export KOPS_STATE_STORE=s3://your-s3-bucket
    ```
1. **Create Configuration**
    ```
    kops create cluster \
    --node-count 3 \
    --zones us-east-1a,us-east-1b,us-east-1c \
    --master-zones us-east-1a,us-east-1b,us-east-1c \
    --dns-zone k8scluster.local \
    --dns private \
    --node-size t2.micro \
    --master-size t2.medium \
    --node-security-groups  sg-xyz,sg-567 \
    --master-security-groups sg-abc,sq-123 \
    --topology private \
    --networking weave \
    --network-cidr 10.10.0.0/20 \
    --vpc vpc-identifier \
    --subnets `private-subnet-id(1a),private-subnet-id(1b),private-subnet-id(ic) \
    --utility-subnets public-subnet-id(1a),public-subnet-id(1b)public-subnet-id(ic) \
    --cloud-labels "Team=Dev,Owner=Samson Gudise" \
    --image 293135079892/k8s-1.4-debian-jessie-amd64-hvm-ebs-2016-11-16 \
    ${CLUSTER_NAME}
    ```
    ***
    * `master-zones` and `zones` should match with your s3 bucket, VPC and subnets zones and region.
    * `node-security-groups` and `master-security-groups` optional, additional security groups you may want to add to masters and nodes
    * `dns-zone` hostedzone created in step 3
    * `dns` hosted zone type. `private` in this example, can be `public` default is `public`
    * `network-cidr` must match with VPC CIDR
    * `subnets` private subnet
    * `utility-subnets` public subnets
    * `${CLUSTER_NAME}` replace with your cluster name
    * Take your time to read and understand preview. It is your opportunity to understand your cluster such as how many `autoscaling groups` are being created, do they use `Elastic Loadbalancer - ELB` and how many `etcd volumes` are being created and where are they attched?
    * Understand network topology  such as no.of  `public subnets`, `private subnets` and `NAT Gateways`. BTW we are using existing network Infrastrcture in this example, make sure these are not part of the preview.  
    ***

1. **Edit Configuration as needed ( vi editor )**
    ```
    kops edit cluster ${CLUSTER_NAME}.k8scluster.local --state=s3://your-s3-bucket
    ```

    ```
    kops edit ig --name ${CLUSTER_NAME}.k8scluster.local master-us-east-1c --state=s3://your-s3-bucket
    ```
    ```
    kops edit ig --name ${CLUSTER_NAME}.k8scluster.local nodes --state=s3://your-s3-bucket
    ```
1. **run preview to ensure changes in previos step**
    ```
    kops update cluster ${CLUSTER_NAME}.k8scluster.local --state=s3://your-s3bucket
    ```
1. **Build Cluster**
    ```
    kops update cluster ${CLUSTER_NAME}.k8scluster.local --state=s3://your-s3bucket --yes
    ```
    * `Note`:  If  you notice any error such as AMI not found or IAM error use AWS console to address while leaving this process running.
1. **Export config** 
* `kops export kubecfg --name=${CLUSTER_NAME} --state=s3://your-s3bucket`

## Source 
* https://kubernetes.io/docs/getting-started-guides/kops/
* https://github.com/kubernetes/kops/blob/master/docs/high_availability.md
* https://github.com/kubernetes/kops/blob/master/docs/aws.md
