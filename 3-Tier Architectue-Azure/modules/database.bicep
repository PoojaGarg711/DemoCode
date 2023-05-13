
param location string = resourceGroup().location
param subnetid string


var administratorLogin ='testAdmin'
var administratorLoginPassword = '5h&h767@'
var sqlServerName = 'demoSqlServer'
var sqlDBName = 'demosqldb'

resource sqlServer 'Microsoft.Sql/servers@2022-02-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    version: '12.0'
    minimalTlsVersion: '1.2'
  }
}

//add vnet integration for be subnet
resource sqlsvrVnetInt 'Microsoft.Sql/servers/virtualNetworkRules@2022-02-01-preview' = {
  name: 'string'
  parent: sqlServer
  properties: {
    virtualNetworkSubnetId: subnetid
  }
}

resource sqlDB 'Microsoft.Sql/servers/databases@2022-02-01-preview' = {
  parent: sqlServer
  name: sqlDBName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
}
