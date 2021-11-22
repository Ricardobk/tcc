.PHONY: init
init:
	terraform -chdir=terraform init && \
	gcloud config set account ricardoknopman@gmail.com && \
	gcloud auth application-default login && \
	gcloud container clusters get-credentials `terraform -chdir=terraform output -raw kubernetes_cluster_name` --region `terraform -chdir=terraform output -raw zone`

.PHONY: services
services:
	kubectl apply -f k8s/services

.PHONY: deployments
deployments:
	kubectl apply -f k8s/deployments

.PHONY: start
start: services deployments

.PHONY: apply
apply:
	terraform -chdir=terraform apply -input=false

.PHONY: plan
plan:
	terraform -chdir=terraform plan -input=false
