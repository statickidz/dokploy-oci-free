variable "ssh_authorized_keys" {
  description = "SSH public key for instances. For example: ssh-rsa AAEAB3NaC1yc2EAAAA....3xcoeATR ssh-key-2024-09-03"
  type        = string
}

variable "compartment_id" {
  description = "The OCID of the compartment. Find it: Profile - Tenancy: youruser - Tenancy information - OCID (copy) https://cloud.oracle.com/tenancy"
  type        = string
}

variable "source_image_id" {
  description = "Source Ubuntu 22.04 image OCID. Find it for your region: https://docs.oracle.com/en-us/iaas/images/image/128dbc42-65a9-4ed0-a2db-be7aa584c726/index.htm. For example: ocid1.image.oc1.phx.aaaaaaaa47msfuw77sfw4eabf23tko6e6kbbbogbeuo6po6ni3lfgjkc5j2q"
  type        = string
}

variable "num_worker_instances" {
  description = "Number of Dokploy worker instances to deploy."
  type        = number
  default     = 1
}

variable "availability_domain_main" {
  description = "Availability domain for dokploy-main instance. For example: AaJg:EU-FRANKFURT-1-AD-1"
  type        = string
}

variable "availability_domain_workers" {
  description = "Availability domain for dokploy-worker instances. For example: AaJg:EU-FRANKFURT-1-AD-2"
  type        = string
}

variable "instance_shape" {
  description = "The shape of the instance. VM.Standard.A1.Flex is free tier eligible."
  type        = string
  default     = "VM.Standard.A1.Flex" # OCI Free
}

variable "memory_in_gbs" {
  description = "Memory in GBs for instance shape config. 6 GB is the maximum for free tier with 3 working nodes."
  type        = string
  default     = "6" # OCI Free
}

variable "ocpus" {
  description = "OCPUs for instance shape config. 1 OCPU is the maximum for free tier with 3 working nodes."
  type        = string
  default     = "1" # OCI Free
}
