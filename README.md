# k8scluster.local
Build private kubernetes cluster by Kops
* private Hosted zone
* Internal api cluster 
* Private DNS zone 
* NAT Gateway(s)

# Create  IAM Instance  Role
* EC2 Full Access
* S3 Full Access
* IAM  Full Access 
* Route53 Full Access

#  Create VPC
* Services -> VPC ->  Your VPC -> Create VPC
*  Make note of vpc-id  you need it later

# Create Private Hosted Zone
* Services ->  Route53 -> Hosted Zones
* Create Hosted Zone 
*     Domain Name : k8scluster.local
*     Type : Private Hosted Zone for Amazon VPC
#  VPC Settings 
* enableDnsHostnames
*   Services -> VPC -> Select VPC -> Edit DNS Hostname : Yes : Save
* enableDnsSupport
*   Services -> VPC -> Select VPC -> Edit DNS Resolution : Yes: Save
#  Launch EC2 Instance 
*  Select IAM roles which was created in previous step while lauching this instance. 
#  Login to EC2 Instance 
* yum install wget 
* yum update 
* wget https://github.com/kubernetes/kops/releases/download/1.8.0/kops-linux-amd64
* chmod +x kops-linux-amd64
* mv kops-linux-amd64 /usr/local/bin/kops
# Create S3 Bucket 
* Service -> S3 : Create Bucket 
*  Name : <clustername>.k8scluster.local 
*  Enable version 
*  Private 
# State Store 
* export KOPS_STATE_STORE=s3://<your s3 bucket>
# Clone this repository and edit parameters 
* git clone  <this repository> 
* vi create-preview-script.sh 
*  edit  all parameters below,  Kops can build those subnets for you or you can create subnets 
*  if you choose to create subnets, make sure provide subnet-ids for each  subnets in config file 
* __CLUSTER__=
* __DOMAIN__=k8scluster.local
* __STATEBUCKET__=samsongudise.k8scluster.local
* __PRIVATESUBNETA__=192.168.5.128/26
* __PRIVATESUBNETB__=192.168.5.192/26
* __PRIVATESUBNETC__=192.168.5.192/26
* __REGION__=us-west-2
* __VPCCIDR__=192.168.5.0/24
* __VPCID__=
* __VERSION__=
* __SSHWHITELIST__=0.0.0.0/0
* __APIWHITELIST__=0.0.0.0/0
* __PUBLICSUBNETA__=192.168.5.0/26
* __PUBLICSUBNETB__=192.168.5.64/26
* __PUBLICSUBNETC__=192.168.5.64/26
* __NODECOUNT__=2
*  __SHKEY__=id_rsa.pub
* __IMAGE__=<centos_image>
* __MYTPE__=t2.medium
# Create ssh-key
* ssh-keygen -t rsa -b 4096 -C "e-mail"
# Create script to build Cluster
*  create-preview-script.sh >  build-script.sh
*  chmod +x build-script.sh
*  sudo mv build-script.sh /usr/local/bin/
# Time to Build Cluster 
* execute  /usr/local/bin/build-script.sh
* verify preview run i
* kops update cluster <clustername> --state=s3://<s3bucket>
# Export config 
* kops export kubecfg --name=<cluster> --state=s3://s3bucket> 
