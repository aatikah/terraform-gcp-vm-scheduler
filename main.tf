# resource "google_compute_network" "tikah-vpc" {
#   name                    = "tikah-vpc"
#   auto_create_subnetworks = true

# }

resource "google_compute_network" "tikah-custom-vpc" {
  name                    = "tikah-custom-vpc"
  auto_create_subnetworks = false

}

resource "google_compute_subnetwork" "tikah-custom-subnetwork" {
  name          = "tikah-custom-subnetwork"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.tikah-custom-vpc.id

}
# resource "google_compute_subnetwork" "tikah-custom-subnetwork2" {
#   name          = "tikah-custom-subnetwork2"
#   ip_cidr_range = "10.0.2.0/24"
#   region        = var.region
#   network       = google_compute_network.tikah-custom-vpc.id

# }



resource "google_compute_instance" "tikahvm" {
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = var.zone
  # allow_stopping_for_update = false

  boot_disk {
    initialize_params {
      image = var.machine_image

    }
  }
  network_interface {
    network    = "tikah-custom-vpc"
    subnetwork = "tikah-custom-subnetwork"

    access_config {
      // Ephemeral public IP will be assigned
    }

  }
  depends_on = [
    google_compute_network.tikah-custom-vpc,
    google_compute_subnetwork.tikah-custom-subnetwork
  ]

}

locals {
  project = var.project # Google Cloud Platform Project ID
}

resource "google_storage_bucket" "function-bucket" {
  name                        = "${local.project}-gcf-source" # Every bucket name must be globally unique
  location                    = var.region
  uniform_bucket_level_access = true
  force_destroy               = true
}

resource "google_storage_bucket_object" "start-function-object" {
  name   = "startvm"
  bucket = google_storage_bucket.function-bucket.name
  source = "startvm.zip" # Add path to the zipped function source code
}

resource "google_storage_bucket_object" "stop-function-object" {
  name   = "stopvm"
  bucket = google_storage_bucket.function-bucket.name
  source = "stopvm.zip" # Add path to the zipped function source code
}

resource "google_cloudfunctions_function" "startvm-function" {
  name        = "startvm-function"
  description = "A function to start tikahvm"
  runtime     = var.runtime

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.function-bucket.name
  source_archive_object = google_storage_bucket_object.start-function-object.name
  trigger_http          = true
  entry_point           = "start_my_vm"

  depends_on = [
    google_storage_bucket.function-bucket,
    google_storage_bucket_object.start-function-object
  ]

}

# output "function_url" {
#   value = google_cloudfunctions_function.startvm-function.https_trigger_url
# }

# resource "google_cloudfunctions2_function" "startvm-function-v2" {
#   name        = "startvm-function-v2"
#   location    = "northamerica-northeast1"
#   description = "A function to start tikahvm"

#   build_config {
#     runtime     = "python39"
#     entry_point = "start_my_vm" # Set the entry point
#     environment_variables = {
#         BUILD_CONFIG_TEST = "build_test"
#     } 
#     source {
#       storage_source {
#         bucket = google_storage_bucket.function-bucket.name
#         object = google_storage_bucket_object.start-function-object.name
#       }
#     }
#   }

#   service_config {
#     max_instance_count = 1
#     available_memory   = "256M"
#     timeout_seconds    = 60
#   }

# }

resource "google_cloudfunctions2_function" "stopvm-function-v2" {
  name        = "stopvm-function-v2"
  location    = var.region
  description = "A function to stop tikahvm"

  build_config {
    runtime     = var.runtime
    entry_point = "stop_my_vm" # Set the entry point 

    source {
      storage_source {
        bucket = google_storage_bucket.function-bucket.name
        object = google_storage_bucket_object.stop-function-object.name
      }
    }
  }

  service_config {
    max_instance_count = 1
    available_memory   = "256M"
    timeout_seconds    = 60

  }
  depends_on = [
    google_storage_bucket.function-bucket,
    google_storage_bucket_object.stop-function-object
  ]

}


resource "google_cloud_scheduler_job" "stop-tikahvm" {
  name             = "stop-tikahvm"
  description      = "A  job to stop stop-tikahvm"
  schedule         = "17 17 * * *"
  time_zone        = var.time_zone
  attempt_deadline = "320s"

  retry_config {
    retry_count = 1
  }

  http_target {
    http_method = "POST"
    uri         = google_cloudfunctions2_function.stopvm-function-v2.service_config[0].uri
    oidc_token {
      service_account_email = var.service_account_email
    }

  }
  depends_on = [
    google_cloudfunctions2_function.stopvm-function-v2
  ]
}


resource "google_cloud_scheduler_job" "start-tikahvm" {
  name             = "start-tikahvm"
  description      = "A  job to start tikahvm"
  schedule         = "22 17 * * *"
  time_zone        = var.time_zone
  attempt_deadline = "320s"

  retry_config {
    retry_count = 1
  }

  http_target {
    http_method = "POST"
    uri         = google_cloudfunctions_function.startvm-function.https_trigger_url
    oidc_token {
      service_account_email = var.service_account_email
    }
  }

  depends_on = [
    google_cloudfunctions_function.startvm-function
  ]
}




