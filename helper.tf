# Random resource ID
resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}
