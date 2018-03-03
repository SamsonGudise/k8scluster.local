# k8scluster.local
* Build kubernetes cluster on AWS Private Hosted Zone  i.e., Local DNS 
* This configuration allows you to build multi-master cluster, spread accross multiple availability zones
* Customize your cluster! Choose Machine type, AMI, subnets and NAT gateway(s)
* Default configuation comes with three masters, two nodes.

## Create IAM Instance Role with
* EC2 Full Access
* S3 Full Access
* IAM Full Access 
* Route53 Full Access

##  Create VPC
*  Services -> VPC -> Your VPC -> Create VPC
*  Make note of vpc-id, you need it later

## Create Private Hosted Zone
* Services ->  Route53 -> Hosted Zones
* Create Hosted Zone 
*	Domain Name : k8scluster.local or your choice
*	Type : Private Hosted Zone for Amazon VPC
##  VPC Settings 
* enableDnsHostnames
*	 Services -> VPC -> Select VPC -> Edit DNS Hostname : Yes : Save
* enableDnsSupport
*	 Services -> VPC -> Select VPC -> Edit DNS Resolution : Yes: Save
#  Launch EC2 Instance 
*  Select IAM roles which was created in previous step while lauching this instance. 
#  Login to EC2 Instance 
* wget https://github.com/kubernetes/kops/releases/download/1.8.0/kops-linux-amd64
* curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
* chmod +x kops-linux-amd64
* mv kops-linux-amd64 /usr/local/bin/kops
# Create S3 Bucket 
* Service -> S3 : Create Bucket 
*  Name : your-clustername.k8scluster.local 
*  Enable versioning 
*  No public access, make it private  
*
## Create ssh-key
* ssh-keygen -t rsa -b 4096 -C "e-mail"
*
# State Store 
* export KOPS_STATE_STORE=s3://your-s3-bucket
# Clone this repository and edit parameters 
* clone this repository
* git clone https://github.com/SamsonGudise/k8scluster.local.git
* vi create-preview-script.sh 
*  edit  all parameters below,  Kops can build those subnets for you or you can create subnets 
*  if you choose to create subnets, make sure provide subnet-ids for each  subnets in config.yaml file 
* __CLUSTER__=
* __DOMAIN__=k8scluster.local
* __STATEBUCKET__=samsongudise.k8scluster.local
* __PRIVATESUBNETA__=10.0.0.0/24
* __PRIVATESUBNETB__=10.0.1.0/24
* __PRIVATESUBNETC__=10.0.2.0/24
* __REGION__=us-west-2
* __VPCCIDR__=10.0.0.0/16
* __VPCID__=
* __VERSION__=
* __SSHWHITELIST__=0.0.0.0/0
* __APIWHITELIST__=0.0.0.0/0
* __PUBLICSUBNETA__=10.0.3.0/24
* __PUBLICSUBNETB__=10.0.4.0/24
* __PUBLICSUBNETC__=10.0.5.0/24
* __NODECOUNT__=2
*  __SHKEY__=id_rsa.pub
* __IMAGE__=<centos_image>
* __MYTPE__=t2.medium
## Update configuraration parameters,  creates script to build cluster
*  create-preview-script.sh >  build-script.sh
*  chmod +x build-script.sh
*  sudo mv build-script.sh /usr/local/bin/
## Time to build cluster 
* execute  /usr/local/bin/build-script.sh
* verify preview.  Take your time to read and understand entire preview.
* It is your opportunity understand cluster. Such as 
* How many Autoscaling groups are being create
* Does it use Elastic Loadbalancer and how they are being used
* Public Private Subnets and NAT Gateways
* How many etcd volumes are created, where are they attached and why?  
* run update script with --yes at the end
* kops update cluster your-cluster-name --state=s3://s3bucket --yes
## Export config 
* kops export kubecfg --name=your-cluster-name --state=s3://s3bucket
## Source 
*
* https://kubernetes.io/docs/getting-started-guides/kops/
