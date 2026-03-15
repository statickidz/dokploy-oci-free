# Reserved (static) public IPs for instances when use_reserved_public_ip = true.
# OCI does not support attaching a reserved IP at instance create time in the API,
# so we create instances without a public IP then attach reserved IPs to their primary private IP.

# --- Main instance: get primary VNIC and its private IP ---
data "oci_core_vnic_attachments" "main" {
  compartment_id = var.compartment_id
  instance_id    = oci_core_instance.dokploy_main.id
}

data "oci_core_private_ips" "main_private_ips" {
  vnic_id = data.oci_core_vnic_attachments.main.vnic_attachments[0].vnic_id
}

resource "oci_core_public_ip" "main" {
  count          = var.use_reserved_public_ip ? 1 : 0
  compartment_id = var.compartment_id
  display_name   = "dokploy-main-${random_string.resource_code.result}-reserved-ip"
  lifetime       = "RESERVED"
  private_ip_id  = data.oci_core_private_ips.main_private_ips.private_ips[0].id
}

# --- Worker instances: same for each worker ---
data "oci_core_vnic_attachments" "worker" {
  count          = var.num_worker_instances
  compartment_id = var.compartment_id
  instance_id    = oci_core_instance.dokploy_worker[count.index].id
}

data "oci_core_private_ips" "worker_private_ips" {
  count   = var.num_worker_instances
  vnic_id = data.oci_core_vnic_attachments.worker[count.index].vnic_attachments[0].vnic_id
}

resource "oci_core_public_ip" "worker" {
  count          = var.use_reserved_public_ip ? var.num_worker_instances : 0
  compartment_id = var.compartment_id
  display_name   = "dokploy-worker-${count.index + 1}-${random_string.resource_code.result}-reserved-ip"
  lifetime       = "RESERVED"
  private_ip_id  = data.oci_core_private_ips.worker_private_ips[count.index].private_ips[0].id
}
