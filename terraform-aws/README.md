# how to set up EKS

1. aws eks --region eu-west-1 update-kubeconfig --name eks --profile terraform

- kubectl get svc

- https://www.hackerxone.com/2021/08/20/steps-to-install-kubectl-eksctl-on-ubuntu-20-04/

- aws eks --region us-east-1 update-kubeconfig --name eks --profile terraform


## install prometheous:

- helm repo add stable https://charts.helm.sh/stable
- helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
- kubectl create namespace prometheus
- helm install prometheus prometheus-community/kube-prometheus-stack -n prometheus
- edit the prometheus service and change type "clusterrole" to "LoadBalancer"
 - edit the grafana service and change type to loadbalancer
