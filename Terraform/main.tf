resource "azurerm_resource_group" "AKS-Cluster-RG" {
  name     = "AKS-Cluster-RG"
  location = "North Europe"

  tags = {
    location = "North Europe"
    usage    = "AKS Cluster resource group"
  }
}

module "k8s" {
  source = "./K8s"

  location = var.location
  rg-name  = azurerm_resource_group.AKS-Cluster-RG.name

}
#sprawdzic czy tak sie robi ze zmiennymi z folderow nadrzednych