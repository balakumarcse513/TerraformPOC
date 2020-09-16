provider "azurerm" {
  subscription_id = "9f33ccbb-95c4-487a-93d0-7272a2c8aa9b"
  client_id       = "a3a63ec1-bdbc-4c82-887e-64fdb5feabfe"
  client_secret   = "9~2~~UK__iHsd1G9pFu_21y-4GdBBQ1_81"
  tenant_id       = "12eea0a8-4e55-4e73-b7fc-2a20054834a0"
  version         = "=2.0.0"
  features {}
}

# 1.ResourceGroup
resource "azurerm_resource_group" "RG" {
  name     = "TerraformResourceGroup"
  location = "West Europe"
}

# 2.AppServicePlan for DotNet
resource "azurerm_app_service_plan" "Plan" {
  name                = "TerraformASPlanDotnet"
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

# 2.AppService for DotNet
resource "azurerm_app_service" "Appservice" {
  name                = "TerraformappserviceDotnet"
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name
  app_service_plan_id = azurerm_app_service_plan.Plan.id

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

# 3.AppServicePlan for Java
resource "azurerm_app_service_plan" "Plan2" {
  name                = "TerraformASPlanJava"
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

#3.AppService for Java
resource "azurerm_app_service" "appservice2" {
  name                = "TerraformAppServiceJava"
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name
  app_service_plan_id = azurerm_app_service_plan.Plan2.id

  site_config {
    java_version           = "1.8"
    java_container         = "TOMCAT"
    java_container_version = "9.0"
  }
}

# 4.Sql Server
resource "azurerm_sql_server" "sqlserver" {
  name                         = "terraformsqlserver"
  resource_group_name          = azurerm_resource_group.RG.name
  location                     = azurerm_resource_group.RG.location
  version                      = "12.0"
  administrator_login          = "testuser"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"

  tags = {
    environment = "production"
  }
}

# 5.Swl Database
resource "azurerm_sql_database" "SqlDatabase" {
  name                = "terraformsqldatabase"
  resource_group_name = azurerm_resource_group.RG.name
  location            = azurerm_resource_group.RG.location
  server_name         = azurerm_sql_server.sqlserver.name

  tags = {
    environment = "production"
  }
}

# 5.KeyValut
resource "azurerm_key_vault" "keyvault" {
  name                        = "terraformkeyvault"
  location                    = azurerm_resource_group.RG.location
  resource_group_name         = azurerm_resource_group.RG.name
  enabled_for_disk_encryption = true
  tenant_id                   = "12eea0a8-4e55-4e73-b7fc-2a20054834a0"
  soft_delete_enabled         = true
  #soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = "12eea0a8-4e55-4e73-b7fc-2a20054834a0"
    object_id = "96367c5f-545d-484d-9285-f5b0ae653df8"

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


