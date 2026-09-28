variable "ssh_authorized_keys" {
  description = "SSH public key for instances. For example: ssh-rsa AAEAAAA....3R ssh-key-2024-09-03"
  type        = string
}

variable "compartment_id" {
  description = "The OCID of the compartment. Find it: Profile → Tenancy: youruser → Tenancy information → OCID https://cloud.oracle.com/tenancy"
  type        = string
}

variable "source_image_id" {
  description = "Source Ubuntu 22.04 image OCID. Find the right one for your region: https://docs.oracle.com/en-us/iaas/images/image/128dbc42-65a9-4ed0-a2db-be7aa584c726/index.htm"
  type        = string
}

variable "num_worker_instances" {
  description = "Number of Dokploy worker instances to deploy (max 3 for free tier)."
  type        = number
  default     = 1
}

variable "availability_domain_main" {
  description = "Availability domain for dokploy-main instance. Find it Core Infrastructure → Compute → Instances → Availability domain (left menu). For example: WBJv:EU-FRANKFURT-1-AD-1"
  type        = string
}

variable "availability_domain_workers" {
  description = "Availability domain for dokploy-main instance. Find it Core Infrastructure → Compute → Instances → Availability domain (left menu). For example: WBJv:EU-FRANKFURT-1-AD-2"
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

variable "boot_volume_size_in_gbs" {
  description = "Boot volume (disk) size in GBs for each instance (minimum 50). Leave empty to keep the image default (47 GB). 100 GB is the maximum for free tier with 1 working node (200 GB with no workers)."
  type        = number
  default     = null # Image default (47 GB)

  validation {
    condition     = var.boot_volume_size_in_gbs == null ? true : (var.boot_volume_size_in_gbs >= 50 && var.boot_volume_size_in_gbs <= 32768 && floor(var.boot_volume_size_in_gbs) == var.boot_volume_size_in_gbs)
    error_message = "boot_volume_size_in_gbs must be empty or a whole number between 50 and 32768 (OCI boot volume limits)."
  }
}

variable "use_reserved_public_ip" {
  description = "If true, assign reserved (static) public IPs to instances instead of ephemeral. Reserved IPs persist if the instance is recreated."
  type        = bool
  default     = false
}
