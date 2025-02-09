# For Detailed Step by Step Guide
You can find detailed step by step guide on creating this project on the Medium post I created [HERE](https://link.medium.com/vNRrOaJiRQb).

# terraform-gcp-vm-scheduler

## Step-by-Step Guide

### Step 1: Setting Up Terraform

1. **Create a Service Account in GCP**: Create a service account with the necessary roles (e.g., Compute Network Admin, Compute Instance Admin, Storage Admin, Cloud Functions Admin, Cloud Scheduler Admin).
2. **Provider Configuration**: Configure the Google Cloud provider in `provider.tf`.
3. **Backend Configuration**: Set up a remote backend in `backend.tf` to store the Terraform state file in a Google Cloud Storage (GCS) bucket.

### Step 2: Defining Infrastructure Resources

1. **Create a Custom VPC and Subnet**: Define the VPC and subnet in `main.tf`.
2. **Create a GCP Instance VM**: Define the VM instance in `main.tf`.
3. **Declare Variables**: Define variables in `variables.tf` and assign values in `dev.tfvars`.

### Step 3: Deploying Cloud Functions

1. **Create Cloud Function Python Scripts**: Write Python scripts to start and stop the VM, and package them into zip files (`startvm.zip` and `stopvm.zip`).
2. **Create a Cloud Storage Bucket and Object**: Deploy a Cloud Storage bucket to store the Cloud Function scripts.
3. **Deploy the Start VM Function**: Deploy the start VM function using GCP's 1st Gen Cloud Function.
4. **Deploy the Stop VM Function**: Deploy the stop VM function using GCP's 2nd Gen Cloud Function.

### Step 4: Automating VM Start/Stop Using Cloud Scheduler

1. **Create a Stop VM Job**: Define a Cloud Scheduler job to stop the VM at a specified time.
2. **Create a Start VM Job**: Define a Cloud Scheduler job to start the VM at a specified time.

### Step 5: Final Code

The final Terraform configuration files (`main.tf`, `provider.tf`, `backend.tf`, `variables.tf`, and `dev.tfvars`) are provided in the repository.

### Step 6: Deploying Terraform Configuration

1. **Initialize Terraform**: Run `terraform init` to initialize the Terraform working directory.
2. **Validate Configuration**: Run `terraform validate` to check the configuration for errors.
3. **Apply Changes**: Run `terraform apply -var-file=dev.tfvars -auto-approve` to deploy the infrastructure.
4. **Destroy Infrastructure**: Run `terraform destroy -var-file=dev.tfvars -auto-approve` to tear down the infrastructure when no longer needed.

## Conclusion

This tutorial provides a fully automated way to provision GCP infrastructure using Terraform. By automating VM start/stop scheduling, you can save costs and improve operational efficiency. The infrastructure includes:

- A VPC and subnet
- A Compute Engine VM
- Cloud Functions for starting and stopping the VM
- Cloud Scheduler jobs for automation

You can find detailed step by step guide on creating this project on the Medium post I created [HERE](https://techandapps.com).

## License

This project is licensed under the MIT License.
