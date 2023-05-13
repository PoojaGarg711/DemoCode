////05-12-2023: Creating a Vnet with three subnets

//parameters to be fetched from user input. Defaults are provided for demo reference**************
param location string = resourceGroup().location

//internal variables***************
var demoVnetName = 'demoVnet3Tier'
var ipRange  = '10.0.0.0/16'
var feSubnetAddress  = '10.0.0.0/26'
var beSubnetAddress = '10.0.0.64/26'

//Resources**********************

//Default NSG for demo purpose only
resource defaultNsg 'Microsoft.Network/networkSecurityGroups@2022-01-01' = {
  name: 'defaultNSG'
  location: location
  properties: {
    securityRules: [
      
    ]
  }
}

//Basic Vnet required for a 3 tier architecture
resource mainVnet 'Microsoft.Network/virtualNetworks@2022-01-01' = {
  name: demoVnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        ipRange
      ]
    }
    subnets: [ 
      {
        name: 'fe-subnet'         // fe subnet for webapp
        properties: {
          addressPrefix: feSubnetAddress
          networkSecurityGroup: {
            id: defaultNsg.id
          }
          serviceEndpoints: [
            {
              service: 'Microsoft.web'
            }
          ]
          delegations:[
            {
              name: 'delegation'
              properties: {
                serviceName: 'Microsoft.Web/serverfarms'
              }
            }
          ]
        }
      }
     {
        name: 'be-subnet'     // be subnet for function app and to communicate to db
        properties: {
          addressPrefix: beSubnetAddress
          networkSecurityGroup: {
            id: defaultNsg.id
          }
          serviceEndpoints: [
            {
              service: 'Microsoft.sql'
            }
          ]
          delegations:[
            {
              name: 'delegation'
              properties: {
                serviceName: 'Microsoft.Web/serverfarms'
              }
            }
          ]
        }
      }
    ]
    enableDdosProtection: false
  }
}

output vnetId string = mainVnet.id
output feSubnetid string = concat(mainVnet.id,'/subnets/fe-subnet')
output beSubnetid string = concat(mainVnet.id,'/subnets/be-subnet')
