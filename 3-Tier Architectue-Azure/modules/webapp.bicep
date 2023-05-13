param location string = resourceGroup().location
param subnetid string

var aspName = 'fe-asp'
var webAppName = 'fe-webapp'

//App Service Plan
resource asp 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: aspName
  location: location  
  sku: {
    name: 'B1'
  }
  kind: 'app'
  properties: {
    perSiteScaling: false
    elasticScaleEnabled: false
    maximumElasticWorkerCount: 1
    isSpot: false
    reserved: false
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: false
    
  }
}

//App Service
resource webApp 'Microsoft.Web/sites@2021-02-01' = {
  name: webAppName
  location: location
  kind: 'app'
  properties: {
    enabled: true
    serverFarmId: asp.id
    reserved: false
    isXenon: false
    hyperV: false
    siteConfig: {

    }

  }
}

//vnet integration
resource networkConfig 'Microsoft.Web/sites/networkConfig@2020-06-01' = {
  parent: webApp
  name: 'virtualNetwork'
  properties: {
    subnetResourceId: subnetid
    }
}
