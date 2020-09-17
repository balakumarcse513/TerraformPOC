provider "azurerm" {
  subscription_id = "2f7ae9e5-d9f2-4c61-9ada-14eb2aadb0b4"
  client_id       = "a4b9d474-e2f6-468f-a6e8-db9a344270e1"
  client_secret   = "ZFab50v-Y719-~ApJQ-O6YT.RQ1oq6~AZL"
  tenant_id       = "edf442f5-b994-4c86-a131-b42b03a16c95"
  version         = "=2.0.0"
  features {}
}

# 1.ResourceGroup
resource "azurerm_resource_group" "RG" {
  name     = "tfresourcegroup"
  location = "West Europe"
}

# 2.AppServicePlan for DotNet
resource "azurerm_app_service_plan" "Plan" {
  name                = "tfasplandotnet"
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

# 2.AppService for DotNet
resource "azurerm_app_service" "Appservice" {
  name                = "tfappservicedotnet"
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
  name                = "tfasplanjava"
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

#3.AppService for Java
resource "azurerm_app_service" "appservice2" {
  name                = "tfappservicejava"
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
  name                         = "tfsqlservernew"
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
  name                = "tfsqldatabasenew"
  resource_group_name = azurerm_resource_group.RG.name
  location            = azurerm_resource_group.RG.location
  server_name         = azurerm_sql_server.sqlserver.name

  tags = {
    environment = "production"
  }
}

# 5.KeyValut
resource "azurerm_key_vault" "keyvault" {
  name                        = "tfkeyvaultnew"
  location                    = azurerm_resource_group.RG.location
  resource_group_name         = azurerm_resource_group.RG.name
  enabled_for_disk_encryption = true
  tenant_id                   = "edf442f5-b994-4c86-a131-b42b03a16c95"
  soft_delete_enabled         = true
  #soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = "edf442f5-b994-4c86-a131-b42b03a16c95"
    object_id = "7bd66435-c50d-4689-9c27-95964bd64957"

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


