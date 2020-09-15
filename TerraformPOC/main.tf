provider "azurerm" {
  subscription_id = "9f33ccbb-95c4-487a-93d0-7272a2c8aa9b"
  client_id       = "a3a63ec1-bdbc-4c82-887e-64fdb5feabfe"
  client_secret   = "9~2~~UK__iHsd1G9pFu_21y-4GdBBQ1_81"
  tenant_id       = "12eea0a8-4e55-4e73-b7fc-2a20054834a0"
  version         = "=2.0.0"
  features {}
}

resource "azurerm_resource_group" "RG" {
  name     = "TerraformRG"
  location = "South India"
}

resource "azurerm_app_service_plan" "RG" {
  name                = "TerraformASPlanDotNet"
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "RG" {
  name                = "TerraformAppDotnet"
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name
  app_service_plan_id = azurerm_app_service_plan.RG.id

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


resource "azurerm_sql_server" "RG" {
  name                         = "TerraformSqlserver"
  resource_group_name          = azurerm_resource_group.RG.name
  location                     = "South India"
  version                      = "12.0"
  administrator_login          = "testuser"
  administrator_login_password = "TestUser@123"

  tags = {
    environment = "production"
  }
}

resource "azurerm_sql_database" "RG" {
  name                = "TerraformSqldatabase"
  resource_group_name = azurerm_resource_group.RG.name
  location            = "South India"
  server_name         = azurerm_sql_server.RG.name

  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.RG.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.RG.primary_access_key
    storage_account_access_key_is_secondary = true
    retention_in_days                       = 6
  }



  tags = {
    environment = "Testing"
  }
}

