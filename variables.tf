variable "project" {
  description = "The project housing the resources"
}

variable "region" {
  description = "This represents the region for resources deployment."

}
variable "zone" {
  description = "This represents the zone within the region for resources deployment."

}

variable "machine_type" {
  description = "The machine type allowed for instances deployment"

}
variable "machine_image" {
  description = "The image allowed for instances deployment"

}

variable "runtime" {
  description = "The runtime for cloud function"

}
variable "vm_name" {
  description = "The VM to schedule"

}
variable "time_zone" {
  description = "Time Zone"

}
variable "service_account_email" {
  description = "The service Account email"

}