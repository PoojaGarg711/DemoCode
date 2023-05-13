targetScope = 'subscription'

param location string = 'USGov Virginia'

resource vnetRG 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'demo-network-rg'
  location: location
}

resource resourcesRG 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'demo-3tier-rg'
  location: location
}

module demovnet './modules/vnet.bicep' = {
  scope: vnetRG
  name: 'demo-vnet'
  params:{
    location: vnetRG.location
  }
}

module webApp './modules/webapp.bicep' = {
  scope: resourcesRG
  name: 'demo-webapp'
  params:{
    location: resourcesRG.location
    subnetid: demovnet.outputs.feSubnetid
  }
}

module fnApp './modules/fnapp.bicep' = {
  scope: resourcesRG
  name: 'demo-fnapp'
  params:{
    location: resourcesRG.location
    fesubnetid: demovnet.outputs.feSubnetid
    besubnetid: demovnet.outputs.beSubnetid
  }
}

module sql './modules/database.bicep' = {
  scope: resourcesRG
  name: 'demo-sql'
  params:{
    location: resourcesRG.location
    subnetid: demovnet.outputs.beSubnetid
  }
}
