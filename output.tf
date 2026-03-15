output "dokploy_dashboard" {
  value = "http://${var.use_reserved_public_ip ? oci_core_public_ip.main[0].ip_address : oci_core_instance.dokploy_main.public_ip}:3000/ (wait 3-5 minutes to finish Dokploy installation)"
}

output "dokploy_worker_ips" {
  value = var.use_reserved_public_ip ? [for i in range(var.num_worker_instances) : "${oci_core_public_ip.worker[i].ip_address} (use it to add the server in Dokploy Dashboard)"] : [for instance in oci_core_instance.dokploy_worker : "${instance.public_ip} (use it to add the server in Dokploy Dashboard)"]
}
