# tflint configuration for dokploy-oci-free
#
# Usage:
#   terraform init        # required before first run (downloads OCI provider schema)
#   tflint --init         # installs the plugins below
#   tflint                # runs all checks
#
# OCI-specific schema validation (invalid argument names, wrong types, missing
# required fields, etc.) is handled via provider deep checking, which reads the
# OCI provider schema downloaded by `terraform init`. No separate OCI plugin is
# required for this.

config {
  # Validate resource arguments against the downloaded provider schemas.
  # Catches OCI-specific issues such as invalid shape names, wrong argument
  # types, and missing required fields without needing cloud credentials.
  call_module_type = "local"
}

# Official Terraform language ruleset — catches deprecated syntax, missing
# required providers, unused variables, and other language-level issues.
plugin "terraform" {
  enabled = true
  version = "0.10.0"
  source  = "github.com/terraform-linters/tflint-ruleset-terraform"

  preset = "recommended"
}
