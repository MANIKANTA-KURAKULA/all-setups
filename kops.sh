vim .bashrc
export PATH=$PATH:/usr/local/bin/
source .bashrc

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo +x kubectl
sudo mv kubectl /usr/local/bin/

curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x kops
sudo mv kops /usr/local/bin/kops

aws s3 mb s3://argo.k8s.storage
aws s3api put-bucket-versioning --bucket argo.k8s.storage --versioning-configuration Status=Enabled
export KOPS_STATE_STORE=s3://argo.k8s.storage 
kops create cluster --name argocd.k8s.local --zones us-east-1a,us-east-1b,us-east-1c --master-count=1 --master-size t2.medium --master-count 1 --master-volume-size 28 --node-count=2 --node-size t2.micro --node-volume-size 27
kops update cluster --name  argo.k8s.storage  --yes --admin



 * list clusters with: kops get cluster
 * edit this cluster with: kops edit cluster deployment.k8s.local
 * edit your node instance group: kops edit ig --name=deployment.k8s.local nodes-us-east-1a
 * edit your control-plane instance group: kops edit ig --name=deployment.k8s.local control-plane-us-east-1a
