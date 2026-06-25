# CloudSPC OpenStack Provider
provider "openstack" {
  version     = ">= 1.19.0"
  auth_url    = "https://authr2.cs1.cloudspc.it:5000/v3"
  domain_name = "SPC_R2"
  region      = var.def_region
  tenant_name = var.project_name
  # user_name   = ""
  # password    = ""

  token       = "gAAAAABfThkDzc8lleiJMO7nPJmpm8D1dDZXfTnFmgI2PBViqijh6AUabG_wnLI_snuHbt0-yebzI6i-zqJRofRlIKxw2Kqqmxvp62ZbnU_yevBPTQBaE0PhpPtFy5UOi6zB8cV00O8FxbTJYaPyWdTJKQDXXKJ75AONmvPaTDi0rcaFvNvvachRrCr4WMtrzDAfXmLovUWCwCFJ-Me7PhyueuNDnf7LhZfguJBqQGW910GOoxPP8Mi-mqIN-wG2D1-PHOVDX1xOeFi7DqK3laURCpU4tefJBg"
}
