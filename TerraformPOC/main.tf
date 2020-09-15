provider "azurerm" {
  subscription_id = "9f33ccbb-95c4-487a-93d0-7272a2c8aa9b"
  client_id       = "a3a63ec1-bdbc-4c82-887e-64fdb5feabfe"
  client_secret   = "9~2~~UK__iHsd1G9pFu_21y-4GdBBQ1_81"
  tenant_id       = "12eea0a8-4e55-4e73-b7fc-2a20054834a0"
  version         = "=2.0.0"
  features {}
}
resource "azurerm_resource_group" "RG" {
  name     = "TerraformResourceGroup"
  location = "South India"
}

resource "azurerm_app_service_plan" "Plan" {
  name                = "TerrafromAppServicePlan"
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "appservice" {
  name                = "TerraformAppService"
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name
  app_service_plan_id = azurerm_app_service_plan.Plan.id

  site_config {
    java_version           = "1.8"
    java_container         = "TOMCAT"
    java_container_version = "9.0"
  }
  