# django-application-deployment

## PART1

The API is connected to a postgresql database which stores information about people who 
plans to travel together. 

## PART 2

We made a Github  repository. We chose github mainly for CI/CD. 
the CI contains one job the which contains steps to build a dockerfile and push to dockerhub from which the image will be pulled to deploy our kubernetes manifest.

## PART 3

Next big thing to talk about is Kubernetes. We used the AWS EKS cluster, using terraform for automating the creation. We choosed to use EKS due to all the heavy lifting
that has been done which includes logging, configuring ingress and and egress, loadbalancers. We installed kubectl and eksctl inside the ec2 instance that allows us run
commands against the cluster.

## PART 4

For monitoring, we used the helm package manager to install prometheus and grafana for visualization and integrated it our cluster.

## PART 5: Backup

This app stores data in a postgresql database. Therefore, we spinned up a postgresql RDS database in AWS and configured to do backups and take snapshots of the data
stored in the database. We also integrated with with cloudwatch to monitor for memory usage.





# HOW TO DEPLOY THE APPLICATION FROM SCRATCH

__PREREQUISITES__

a. AWS account
b. terraform cloud account to store state files.
c. create an iam profile using this command `aws iam create-user --user-name terraform`


#### Follow these steps:

1. `git clone`

2. `cd terraform-aws`

3. `terraform apply --auto-approve` This command will deploy and create the EKS Cluster in AWS.



## To work with the cluster

1. `aws eks --region us-east-1 update-kubeconfig --name eks --profile terraform`
2. follow this https://www.hackerxone.com/2021/08/20/steps-to-install-kubectl-eksctl-on-ubuntu-20-04/ to install kubectl and eksctl


## To make application externally accessible

1. Setup a postgresql database in a private subnet and make it privately accessible from the security group of the created worker node.

2. `kubectl apply -f k8s/django.yml` to create a deployment and service

3. `kubectl exec -i -t <pod name> bash` to do some configurations in the container

__inside the container, run the following commands__

a. `pip install -r requirements.txt`

b. `vim nomad/settings` and change the database username and password and host to the one given during the rds creation. Also change the TZ=False. save and exit.

c. `python3 manage.py makemigrations`

d. `python3 manage.py migrate`

e. `python3 manage.py createsuperuser` and exit the container

4. `kubectl exec -i it <pod name> python3 manage.py runserver 0.0.0.0:8000`

5. `kubectl get svc` . copy the DNS and paste in the  browser



<img width="940" alt="image" src="https://user-images.githubusercontent.com/99150197/182586253-858847a8-9007-46f3-b4aa-a568db7d7f3a.png">


# MONITORING

1. helm repo add stable https://charts.helm.sh/stable

2. helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

3. kubectl create namespace prometheus

4. helm install prometheus prometheus-community/kube-prometheus-stack -n prometheus

5. edit the prometheus service and change type "clusterrole" to "LoadBalancer"

6.  edit the grafana service and change type to loadbalancer


<img width="942" alt="image" src="https://user-images.githubusercontent.com/99150197/182591117-2b6ebc56-e990-4457-b1fc-14fa828f11d3.png">


source code credit:  https://github.com/project-travel-mate/server



