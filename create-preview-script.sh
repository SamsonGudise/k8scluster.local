__CLUSTER__=
__DOMAIN__=k8scluster.local
__STATE_BUCKET__=samsonbabu.k8scluster.local
__PRIVATESUBNETA__=192.168.5.128/26
__PRIVATESUBNETB__=192.168.5.192/26
__PRIVATESUBNETC__=192.168.5.192/26
__REGION__=us-west-2
__VPCCIDR__=192.168.5.0/24
__VPCID__=
__VERSION_=1.9.0
__SSHWHITELIST__=0.0.0.0/0
__APIWHITELIST__=0.0.0.0/0
__PUBLICSUBNETA__=192.168.5.0/26
__PUBLICSUBNETB__=192.168.5.64/26
__PUBLICSUBNETC__=192.168.5.64/26
__NODECOUNT__=2
__SSHKEY__=id_rsa.pub
__IMAGE__=ami-3fa07b47
__MYTPE__=t2.medium

## Update yaml with given parameters 
sed -i.bak -e "s/__CLUSTER__/$__CLUSTER__/g" config.yaml
sed -i.bak -e "s/__DOMAIN__/$__DOMAIN__/g" config.yaml
sed -i.bak -e "s/__STATE_BUCKET__/$__STATE_BUCKET__/g" config.yaml
sed -i.bak -e "s?__PRIVATESUBNETA__?$__PRIVATESUBNETA__?g" config.yaml
sed -i.bak -e "s?__PRIVATESUBNETB__?$__PRIVATESUBNETB__?g" config.yaml
sed -i.bak -e "s?__PRIVATESUBNETC__?$__PRIVATESUBNETC__?g" config.yaml
sed -i.bak -e "s/__REGION__/$__REGION__/g" config.yaml
sed -i.bak -e "s?__VPCCIDR__?$__VPCCIDR__?g" config.yaml
sed -i.bak -e "s/__VPCID__/$__VPCID__/g" config.yaml
sed -i.bak -e "s/__VERSION__/$__VERSION__/g" config.yaml
sed -i.bak -e "s?__SSHWHITELIST__?$__SSHWHITELIST__?g" config.yaml
sed -i.bak -e "s?__APIWHITELIST__?$__APIWHITELIST__?g" config.yaml
sed -i.bak -e "s?__PUBLICSUBNETA__?$__PUBLICSUBNETA__?g" config.yaml
sed -i.bak -e "s?__PUBLICSUBNETB__?$__PUBLICSUBNETB__?g" config.yaml
sed -i.bak -e "s?__PUBLICSUBNETC__?$__PUBLICSUBNETC__?g" config.yaml

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

echo kops  create -f config.yaml --state=s3://$__STATE_BUCKET__
echo kops create -f instancegroup/bastions.yaml --state=s3://$__STATE_BUCKET__
echo kops create -f instancegroup/master-a.yaml --state=s3://$__STATE_BUCKET__
echo kops create -f instancegroup/master-b.yaml --state=s3://$__STATE_BUCKET__
echo kops create -f instancegroup/master-c.yaml --state=s3://$__STATE_BUCKET__
echo kops create -f instancegroup/nodes.yaml --state=s3://$__STATE_BUCKET__
echo kops create secret --name $__CLUSTER__.$__DOMAIN__ sshpublickey admin -i $__SSHKEY__ --state=s3://$__STATE_BUCKET__
echo kops update cluster $__CLUSTER__.$__DOMAIN__ --state=s3://$__STATE_BUCKET__
