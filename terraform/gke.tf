# GKE cluster
resource "google_container_cluster" "primary" {
  name     = "${var.project_id}-gke"
  location = var.zone
  
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = ""
    services_ipv4_cidr_block = ""
  }

  vertical_pod_autoscaling { enabled = true } 
  cluster_autoscaling { 
        enabled = true 
        resource_limits { 
                resource_type = "cpu"
                maximum = 10
        }
        resource_limits {
                resource_type = "memory"
                maximum = 50
        }
  }
}

# Separately Managed Node Pool
resource "google_container_node_pool" "app-pool" {
  name       = "app-pool"
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  node_count = var.app_pool_num_nodes
  autoscaling {
        min_node_count = 1
        max_node_count = 3
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = var.project_id
    }

    # preemptible  = true
    machine_type = var.data_pool_machine_type
    tags         = ["gke-node", "${var.project_id}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}

# Separately Managed Node Pool
resource "google_container_node_pool" "data-pool" {
  name       = "data-pool"
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  node_count = var.data_pool_num_nodes

  autoscaling {
    min_node_count = 2
    max_node_count = 2
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = var.project_id
    }

    # preemptible  = true
    machine_type = var.data_pool_machine_type
    tags         = ["gke-node", "${var.project_id}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}
