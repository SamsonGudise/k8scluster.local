kops create cluster \
    --node-count 3 \
    --zones us-east-1a,us-east-1b,us-east-1c \
    --master-zones us-east-1a,us-east-1b,us-east-1c \
    --dns-zone k8scluster.local \
    --dns private \
    --node-size t2.medium \
    --master-size t2.medium \
    --node-security-groups  sg-003bc7e192258a3d1 \
    --master-security-groups sg-003bc7e192258a3d1 \
    --topology private \
    --networking weave \
    --network-cidr 10.10.0.0/20 \
    --vpc vpc-05ad993e438060ace \
    --subnets subnet-0c575cf68e7e0df01,subnet-02330b5c1e7ede11e,subnet-052a715a056b9226a \
    --utility-subnets subnet-0feaba45936e69033,subnet-0271917c5dfeee44c,subnet-0b2316a00495523c4 \
    --cloud-labels "Team=Dev,Owner=Samson Gudise" \
    --image 293135079892/k8s-1.4-debian-jessie-amd64-hvm-ebs-2016-11-16 \
    test.k8scluster.local

