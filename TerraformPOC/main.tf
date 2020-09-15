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

resource "azurerm_app_service_plan" "RG" {
  name                = "TerrafromASPlanJava"
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "RG" {
  name                = "TerraformAppJava"
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name
  app_service_plan_id = azurerm_app_service_plan.Plan.id

  site_config {
    java_version           = "1.8"
    java_container         = "TOMCAT"
    java_container_version = "9.0"
  }
}

resource "azurerm_key_vault" "RG" {
  name                        = "TerraformKeyVault"
  location                    = azurerm_resource_group.RG.location
  resource_group_name         = azurerm_resource_group.RG.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_enabled         = true
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "get",
    ]

    secret_permissions = [
      "get",
    ]

    storage_permissions = [
      "get",
    ]
  }

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }

  tags = {
    environment = "Testing"
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
    environment = "production"
  }
}