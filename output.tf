output "dokploy_dashboard" {
  value = "http://${oci_core_instance.dokploy_main.public_ip}:3000/ (wait 3-5 minutes to finish Dokploy installation)"
}

output "dokploy_worker_ips" {
  value = [for instance in oci_core_instance.dokploy_worker : "${instance.public_ip} (user it to add the server in Dokploy Dashboard)"]
}
