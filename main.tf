

provider "vsphere" {
  user                  = "cloudadmin@vmc.local"
  password              = "XXXXXXXXXXXXXX"
  vsphere_server        = "vcenter.sddc-A-B-C-D.vmwarevmc.com"
  allow_unverified_ssl  = true
}


/*================
Deploy Virtual Machimes
=================*/

module "VMs" {
  source = "../VMs"
  data_center         = var.data_center
  cluster             = var.cluster
  workload_datastore  = var.workload_datastore
  compute_pool        = var.compute_pool 
}