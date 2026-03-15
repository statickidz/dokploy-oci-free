# Dokploy Deployment on OCI Free Tier

This Terraform project deploys a Dokploy instance along with worker nodes in Oracle Cloud Infrastructure (OCI) Free Tier. **Dokploy** is an open-source platform to manage your app deployments and server configurations.

## Deploy

[![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/statickidz/dokploy-oci-free/archive/refs/heads/main.zip)

*Clicking the "Deploy to Oracle Cloud" button will load the Oracle Cloud Resource Manager to deploy the infrastructure described in this Terraform project. During deployment, you'll be prompted to configure the stack parameters. Review the settings, then launch the stack deployment.*

## About Dokploy

![Dokploy Logo](doc/dokploy-logo.webp)

Dokploy is an open-source deployment tool designed to simplify the management of servers, applications, and databases on your own infrastructure with minimal setup. It streamlines CI/CD pipelines, ensuring easy and consistent deployments.

For more information, visit the official page at [dokploy.com](https://dokploy.com).

![Dokploy Screenshot](doc/dokploy-screenshot.png)

## OCI Free Tier Overview

Oracle Cloud Infrastructure (OCI) offers a Free Tier with resources ideal for light workloads, such as the VM.Standard.E2.1.Micro instance. These resources are free as long as usage remains within the limits.

For detailed information about the free tier, visit [OCI Free Tier](https://www.oracle.com/cloud/free/).

*Note: Free Tier instances are subject to availability, and you might encounter "Out of Capacity" errors. To bypass this, upgrade to a paid account. This keeps your free-tier benefits but removes the capacity limitations, ensuring access to higher-tier resources if needed.*

## Prerequisites

Before you begin, ensure you have the following:

-   An Oracle Cloud Infrastructure (OCI) account with Free Tier resources available.
-   An SSH public key for accessing the instances.

## Servers & Cluster

### Add Servers to Dokploy

To begin deploying applications, you need to add servers to your Dokploy cluster. A server in Dokploy is where your applications will be deployed and managed.

#### Steps to Add Servers:

1.  **Login to Dokploy Dashboard**:
    -   Access the Dokploy dashboard via the main instance's public IP address. You'll need to use the login credentials configured during setup.
1.  **Generate SSH Keys**:
    -   On the left-hand menu, click on "SSH Keys" and add your private and public SSH key to connect your server.
2.  **Navigate to Servers Section**:
    -   On the left-hand menu, click on "Servers" and then "Add Server."
3.  **Fill in Server Details**:
    -   **Server Name**: Give your server a meaningful name.
    -   **IP Address**: Enter the public IP address of the instance. If you’re using private networking, you can enter the private IP address instead.
    -   **SSH Key**: Select the previous created SSH key.
    -   **Username**: The SSH user for connecting to the server, use `root`.
4.  **Submit**:
    -   After filling out the necessary fields, click "Submit" to add the server.

### Configure a Dokploy Cluster with new workers

After setting up the main Dokploy instance, you can expand your cluster by adding worker nodes. These worker instances will help distribute the workload for your deployments.

See more info about configuring your cluster on the [Dokploy Cluster Docs](https://docs.dokploy.com/docs/core/cluster).

### Updating the server IP in Dokploy (e.g. after switching to reserved IP)

If you change the instance’s public IP (for example from ephemeral to reserved), let Dokploy know about it:

1. In the Dokploy dashboard, go to **Servers**.
2. Click the server whose IP changed.
3. Use **Update server IP** and the “set current public IP” control (double arrows) to set the server’s IP to the new public address.

Note: **Reserved** Static IP does not change unless you release it. It stays in your account until you delete it.

## Project Structure

-   `bin/`: Contains bash scripts for setting up Dokploy on both the main instance and the worker instances.
    -   `dokploy-main.sh`: Script to install Dokploy on the main instance.
    -   `dokploy-worker.sh`: Script to configure necessary dependencies on worker instances.
-   `helper.tf`: Contains helper functions and reusable modules to streamline the infrastructure setup.
-   `doc/`: Directory for images used in the README (e.g., screenshots of Dokploy setup).
-   `locals.tf`: Defines local values used throughout the Terraform configuration, such as dynamic values or reusable expressions.
-   `main.tf`: Core Terraform configuration file that defines the infrastructure for Dokploy's main and worker instances.
-   `network.tf`: Configuration for setting up the required OCI networking resources (VCNs, subnets, security lists, etc.).
-   `output.tf`: Specifies the output variables such as the IP addresses for the dashboard and worker nodes.
-   `reserved_ips.tf`: Optional reserved (static) public IPs for the main and worker instances when `use_reserved_public_ip` is enabled (see [Reserved public IPs](#reserved-static-public-ips)).
-   `providers.tf`: Declares the required cloud providers and versions, particularly for Oracle Cloud Infrastructure.
-   `README.md`: This file, providing instructions on deployment and usage.
-   `variables.tf`: Defines input variables used in the project, including compartment ID, SSH keys, instance shape, and more.

## Terraform Variables

Below are the key variables for deployment which are defined in `variables.tf`:

-   `ssh_authorized_keys`: Your SSH public key for accessing the instances.
-   `compartment_id`: OCI compartment ID for instance deployment.
-   `num_worker_instances`: Number of worker instances to deploy for Dokploy.
-   `availability_domain_main`: Availability domain for the main instance.
-   `availability_domain_workers`: Availability domains for worker instances.
-   `instance_shape`: Instance shape (e.g., VM.Standard.E2.1.Micro) used for deployment.
-   `memory_in_gbs`: Memory size (GB) per instance.
-   `ocpus`: Number of OCPUs per instance.
-   `use_reserved_public_ip`: If `true`, assign reserved (static) public IPs to the main and worker instances instead of ephemeral IPs. Default is `false`. See [Reserved (static) public IPs](#reserved-static-public-ips).
