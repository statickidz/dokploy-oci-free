# Copy to backend.oci.hcl and set your Object Storage bucket and namespace.
# Your namespace is in: OCI Console → Profile → Tenancy → Object Storage namespace.
# Create a bucket (e.g. tf-state) and enable versioning for state recovery.

bucket     = "tf-state"
namespace  = "frxdletmraqo"
region     = "eu-frankfurt-1"
key        = "dokploy/terraform.tfstate"
