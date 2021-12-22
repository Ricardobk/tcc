.PHONY: init
init:
	terraform -chdir=terraform init && \
	gcloud config set account ricardoknopman@gmail.com && \
	gcloud auth application-default login && \
	gcloud container clusters get-credentials `terraform -chdir=terraform output -raw kubernetes_cluster_name` --region `terraform -chdir=terraform output -raw zone`

.PHONY: tf_apply
tf_apply:
	terraform -chdir=terraform apply -input=false

.PHONY: tf_plan
tf_plan:
	terraform -chdir=terraform plan -input=false

.PHONY: helm_upgrade
helm_upgrade:
	kubectl delete statefulset --all # --cascade=false
	helm upgrade --install fdp-gcp fdp-gcp/charts/fdp-gcp -f fdp-gcp/values.yaml


