param location string = resourceGroup().location
param fesubnetid string
param besubnetid string

var fnappasp = 'be-asp'
var fnAppName = 'be-fnapp'
var saName = 'demosa'


resource storageAccount 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: saName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
  }
}

// App Service Plan

resource fnasp 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: fnappasp
  location: location  
  sku: {
    name: 'B1'
    tier: 'Basic'
  }
  properties: {    
  }
}

// Function App
resource functionApp 'Microsoft.Web/sites@2020-06-01' = {
  name: fnAppName
  location: location
  kind: 'functionapp'
  properties: {
    enabled: true
    reserved: false
    isXenon: false
    hyperV: false
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${saName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower(fnAppName)
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${saName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
      ]
      ipSecurityRestrictions: [
        {
          vnetSubnetResourceId: fesubnetid
          action: 'Allow'
          tag: 'Default'
          priority: 100
          name: 'Allow fe subnet'
      }
      {
          ipAddress: 'Any'
          action: 'Deny'
          priority: 2147483647
          name: 'Deny All'
      }
      ]
    }
  }
}

//vnet integration
resource networkConfig 'Microsoft.Web/sites/networkConfig@2020-06-01' = {
  parent: functionApp
  name: 'virtualNetwork'
  properties: {
    subnetResourceId: besubnetid
  }
}
