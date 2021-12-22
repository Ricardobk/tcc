variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "region"
}

variable "zone" {
  description = "zone"
}

variable "gke_username" {
  default     = ""
  description = "gke username"
}

variable "gke_password" {
  default     = ""
  description = "gke password"
}

variable "app_pool_num_nodes" {
  default     = 1
  description = "number of gke nodes on the app pool"
}

variable "data_pool_num_nodes" {
  default     = 2
  description = "number of gke nodes on the data pool"
}

variable "app_pool_machine_type" {
  default     = "n1-standard-1"
  description = "gcp host family for the app pool"
}

variable "data_pool_machine_type" {
  default     = "n1-standard-1"
  description = "gcp host family for the data pool"
}


