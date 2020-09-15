provider "azurerm" {
  subscription_id = "9f33ccbb-95c4-487a-93d0-7272a2c8aa9b"
  client_id       = "a3a63ec1-bdbc-4c82-887e-64fdb5feabfe"
  client_secret   = "9~2~~UK__iHsd1G9pFu_21y-4GdBBQ1_81"
  tenant_id       = "12eea0a8-4e55-4e73-b7fc-2a20054834a0"
  version         = "=2.0.0"
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_app_service_plan" "example" {
  name                = "example-appserviceplan"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "example" {
  name                = "example-app-service"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.example.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
}