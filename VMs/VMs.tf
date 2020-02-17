

variable "data_center" {}
variable "cluster" {}
variable "workload_datastore" {}
variable "compute_pool" {}



data "vsphere_datacenter" "dc" {
  name          = var.data_center
}
data "vsphere_compute_cluster" "cluster" {
  name          = var.cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_datastore" "datastore" {
  name          = var.workload_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = var.compute_pool
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = "sddc-cgw-network-1"
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_virtual_machine" "vm_template" {
  name          = "centos-vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}


# ================================================

resource "vsphere_virtual_machine" "vm1" {
  name             = "terraform-testVM"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = "Workloads"
  num_cpus = 2
  memory   = 1024
  guest_id = "centos6_64Guest"

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label = "disk0"
    size  = 20
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.vm_template.id
  }
}
