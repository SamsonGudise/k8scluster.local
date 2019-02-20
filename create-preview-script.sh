#!/bin/sh
[ -z "$__CLUSTER__" ] && __CLUSTER__=test.k8scluster.local
[ -z "$__DOMAIN__" ] && __DOMAIN__=k8scluster.local
[ -z "$__STATE_BUCKET__" ] && echo "Please export __STATE_BUCKET__" && exit 3
[ -z "$__VPCCIDR__" ] && __VPCCIDR__=10.0.0.0/20
[ -z "$__PRIVATESUBNETA__" ] && __PRIVATESUBNETA__=10.0.0.0/24
[ -z "$__PRIVATESUBNETB__" ] && __PRIVATESUBNETB__=10.0.1.0/24
[ -z "$__PRIVATESUBNETC__" ] && __PRIVATESUBNETC__=10.0.2.0/24
[ -z "$__PUBLICSUBNETA__" ] && __PUBLICSUBNETA__=10.0.3.0/24
[ -z "$__PUBLICSUBNETB__" ] && __PUBLICSUBNETB__=10.0.4.0/24
[ -z "$__PUBLICSUBNETC__" ] && __PUBLICSUBNETC__=10.0.5.0/24
[ -z "$__REGION__" ] && __REGION__=us-west-2
[ -z "$__VPCID__" ] && __VPCID__=""
[ -z "$__VERSION__" ] && __VERSION_=1.8.5
[ -z "$__SSHWHITELIST__" ] && __SSHWHITELIST__=0.0.0.0/0
[ -z "$__APIWHITELIST__" ] && __APIWHITELIST__=0.0.0.0/0
[ -z "$__NODECOUNT__" ] && __NODECOUNT__=2
[ -z "$__SSHKEY__" ] && __SSHKEY__=~/.ssh/id_rsa.pub
[ -z "$__IMAGE__" ] && __IMAGE__=ami-3fa07b47
[ -z "$__MTYPE"] && __MTYPE__=t2.medium

[ -z "$__PRIVATESUBNETIDA__" ] && __PRIVATESUBNETIDA__=""
[ -z "$__PRIVATESUBNETIDB__" ] && __PRIVATESUBNETIDB__=""
[ -z "$__PRIVATESUBNETIDC__" ] && __PRIVATESUBNETIDC__=""

[ -z "$__PUBLICSUBNETA__" ] && __PUBLICSUBNETA__=""
[ -z "$__PUBLICSUBNETB__" ] && __PUBLICSUBNETB__=""
[ -z "$__PUBLICSUBNETC__" ] && __PUBLICSUBNETC__=""

## Check for ssh key 
[ ! -f $__SSHKEY__ ] && echo "public key ($__SSHKEY__) key is missing" && exit 2

## Update yaml with given parameters 
sed -i.bak -e "s/__CLUSTER__/$__CLUSTER__/g" config.yaml
sed -i.bak -e "s/__DOMAIN__/$__DOMAIN__/g" config.yaml
sed -i.bak -e "s/__STATE_BUCKET__/$__STATE_BUCKET__/g" config.yaml
sed -i.bak -e "s?__PRIVATESUBNETA__?$__PRIVATESUBNETA__?g" config.yaml
sed -i.bak -e "s?__PRIVATESUBNETB__?$__PRIVATESUBNETB__?g" config.yaml
sed -i.bak -e "s?__PRIVATESUBNETC__?$__PRIVATESUBNETC__?g" config.yaml
sed -i.bak -e "s?__PRIVATESUBNETIDA__?$__PRIVATESUBNETIDA__?g" config.yaml
sed -i.bak -e "s?__PRIVATESUBNETIDB__?$__PRIVATESUBNETIDB__?g" config.yaml
sed -i.bak -e "s?__PRIVATESUBNETIDC__?$__PRIVATESUBNETIDC__?g" config.yaml
sed -i.bak -e "s/__REGION__/$__REGION__/g" config.yaml
sed -i.bak -e "s?__VPCCIDR__?$__VPCCIDR__?g" config.yaml
sed -i.bak -e "s/__VPCID__/$__VPCID__/g" config.yaml
sed -i.bak -e "s/__VERSION__/$__VERSION__/g" config.yaml
sed -i.bak -e "s?__SSHWHITELIST__?$__SSHWHITELIST__?g" config.yaml
sed -i.bak -e "s?__APIWHITELIST__?$__APIWHITELIST__?g" config.yaml
sed -i.bak -e "s?__PUBLICSUBNETA__?$__PUBLICSUBNETA__?g" config.yaml
sed -i.bak -e "s?__PUBLICSUBNETB__?$__PUBLICSUBNETB__?g" config.yaml
sed -i.bak -e "s?__PUBLICSUBNETC__?$__PUBLICSUBNETC__?g" config.yaml
sed -i.bak -e "s?__PUBLICSUBNETIDA__?$__PUBLICSUBNETIDA__?g" config.yaml
sed -i.bak -e "s?__PUBLICSUBNETIDB__?$__PUBLICSUBNETIDB__?g" config.yaml
sed -i.bak -e "s?__PUBLICSUBNETIDC__?$__PUBLICSUBNETIDC__?g" config.yaml

sed -i.bak -e "s/__NODECOUNT__/$__NODECOUNT__/g" instancegroup/nodes.yaml
sed -i.bak -e "s/__IMAGE__/$__IMAGE__/g" instancegroup/nodes.yaml
sed -i.bak -e "s/__MTYPE__/$__MTYPE__/g" instancegroup/nodes.yaml
sed -i.bak -e "s/__DOMAIN__/$__DOMAIN__/g" instancegroup/nodes.yaml
sed -i.bak -e "s/__CLUSTER__/$__CLUSTER__/g" instancegroup/nodes.yaml
sed -i.bak -e "s/__REGION__/$__REGION__/g" instancegroup/nodes.yaml

sed -i.bak -e "s/__IMAGE__/$__IMAGE__/g" instancegroup/bastions.yaml
sed -i.bak -e "s/__MTYPE__/$__MTYPE__/g" instancegroup/bastions.yaml
sed -i.bak -e "s/__DOMAIN__/$__DOMAIN__/g" instancegroup/bastions.yaml
sed -i.bak -e "s/__CLUSTER__/$__CLUSTER__/g" instancegroup/bastions.yaml
sed -i.bak -e "s/__REGION__/$__REGION__/g" instancegroup/bastions.yaml


sed -i.bak -e "s/__IMAGE__/$__IMAGE__/g" instancegroup/master-a.yaml
sed -i.bak -e "s/__MTYPE__/$__MTYPE__/g" instancegroup/master-a.yaml
sed -i.bak -e "s/__DOMAIN__/$__DOMAIN__/g" instancegroup/master-a.yaml
sed -i.bak -e "s/__CLUSTER__/$__CLUSTER__/g" instancegroup/master-a.yaml
sed -i.bak -e "s/__REGION__/$__REGION__/g" instancegroup/master-a.yaml

sed -i.bak -e "s/__IMAGE__/$__IMAGE__/g" instancegroup/master-b.yaml
sed -i.bak -e "s/__MTYPE__/$__MTYPE__/g" instancegroup/master-b.yaml
sed -i.bak -e "s/__DOMAIN__/$__DOMAIN__/g" instancegroup/master-b.yaml
sed -i.bak -e "s/__CLUSTER__/$__CLUSTER__/g" instancegroup/master-b.yaml
sed -i.bak -e "s/__REGION__/$__REGION__/g" instancegroup/master-b.yaml

sed -i.bak -e "s/__IMAGE__/$__IMAGE__/g" instancegroup/master-c.yaml
sed -i.bak -e "s/__MTYPE__/$__MTYPE__/g" instancegroup/master-c.yaml
sed -i.bak -e "s/__DOMAIN__/$__DOMAIN__/g" instancegroup/master-c.yaml
sed -i.bak -e "s/__CLUSTER__/$__CLUSTER__/g" instancegroup/master-c.yaml
sed -i.bak -e "s/__REGION__/$__REGION__/g" instancegroup/master-c.yaml

echo kops  create -f config.yaml --state=s3://$__STATE_BUCKET__  >  create-cluster.sh
echo kops create -f instancegroup/bastions.yaml --state=s3://$__STATE_BUCKET__ >> create-cluster.sh
echo kops create -f instancegroup/master-a.yaml --state=s3://$__STATE_BUCKET__ >> create-cluster.sh
echo kops create -f instancegroup/master-b.yaml --state=s3://$__STATE_BUCKET__ >> create-cluster.sh
echo kops create -f instancegroup/master-c.yaml --state=s3://$__STATE_BUCKET__ >> create-cluster.sh
echo kops create -f instancegroup/nodes.yaml --state=s3://$__STATE_BUCKET__ >> create-cluster.sh
echo kops create secret --name $__CLUSTER__.$__DOMAIN__ sshpublickey admin -i $__SSHKEY__ --state=s3://$__STATE_BUCKET__ >> create-cluster.sh
echo kops update cluster $__CLUSTER__.$__DOMAIN__ --state=s3://$__STATE_BUCKET__ >> create-cluster.sh

echo kops update cluster $__CLUSTER__.$__DOMAIN__ --state=s3://$__STATE_BUCKET__  --yes > build-cluster.sh
echo kops delete cluster $__CLUSTER__.$__DOMAIN__ --state=s3://$__STATE_BUCKET__  --yes > delete-cluster.sh
chmod 750 *-cluster.sh
rm *.bak instancegroup/*.bak

