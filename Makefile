.PHONY: init
init:
	gcloud auth application-default login && \
	terraform -chdir=terraform init

.PHONY: kube_init
kube_init:
	gcloud container clusters get-credentials `terraform -chdir=terraform output -raw kubernetes_cluster_name` --region `terraform -chdir=terraform output -raw zone`

.PHONY: tf_apply
tf_apply:
	terraform -chdir=terraform apply -input=false

.PHONY: tf_plan
tf_plan:
	terraform -chdir=terraform plan -input=false


.PHONY: helm_apply
helm_apply:
	helm upgrade --install fdp-gcp fdp-gcp/charts/fdp-gcp -f fdp-gcp/values.yaml

.PHONY: helm_delete
helm_delete:
	helm uninstall fdp-gcp

.PHONY: delete_cluster
delete_cluster:
	terraform -chdir=terraform destroy -input=false
