variable "ssh_authorized_keys" {
  description = "One or more SSH public keys for instance access. For example: [\"ssh-rsa AAAA...key1\", \"ssh-rsa AAAA...key2\"]"
  type        = list(string)
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
  description = "Number of Dokploy worker instances to deploy. Max 3 for Always Free tier. Default is 1 (1 main + 1 worker = 2 instances, 4 OCPUs, 24 GB total)."
  type        = number
  default     = 1
}

variable "availability_domain_main" {
  description = "Availability domain for dokploy-main instance. Find it Core Infrastructure → Compute → Instances → Availability domain (left menu). For example: WBJv:EU-FRANKFURT-1-AD-1"
  type        = string
}

variable "availability_domain_workers" {
  description = "Availability domain for dokploy-worker instances. Find it Core Infrastructure → Compute → Instances → Availability domain (left menu). For example: WBJv:EU-FRANKFURT-1-AD-2"
  type        = string
}

variable "instance_shape" {
  description = "The shape of the instance. VM.Standard.A1.Flex is free tier eligible."
  type        = string
  default     = "VM.Standard.A1.Flex" # OCI Free
}

variable "memory_in_gbs" {
  description = "Memory in GBs per instance. At 12 GB with 2 instances (1 main + 1 worker), total is 24 GB — the Always Free ceiling."
  type        = string
  default     = "12" # OCI Free
}

variable "ocpus" {
  description = "OCPUs per instance. At 2 OCPUs with 2 instances (1 main + 1 worker), total is 4 OCPUs — the Always Free ceiling."
  type        = string
  default     = "2" # OCI Free
}

variable "use_reserved_public_ip" {
  description = "If true, assign reserved (static) public IPs to instances instead of ephemeral. Reserved IPs persist if the instance is recreated."
  type        = bool
  default     = false
}
