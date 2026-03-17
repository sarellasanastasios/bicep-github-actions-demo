resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: 'vmssVnet'
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'vmssSubnet'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}
param vmssName string = 'myvmss'
param adminUsername string = 'vmssadmin'
param adminPassword string

resource vmss 'Microsoft.Compute/virtualMachineScaleSets@2023-09-01' = {
  name: vmssName
  location: resourceGroup().location
  sku: {
    name: 'Standard_D2s_v3'
    tier: 'Standard'
    capacity: 2
  }
  properties: {
    upgradePolicy: {
      mode: 'Automatic'
    }
    virtualMachineProfile: {
      storageProfile: {
        imageReference: {
          publisher: 'MicrosoftWindowsServer'
          offer: 'WindowsServer'
          sku: '2022-datacenter-azure-edition'
          version: 'latest'
        }
      }
      osProfile: {
        computerNamePrefix: vmssName
        adminUsername: adminUsername
        adminPassword: adminPassword
      }
      networkProfile: {
        networkInterfaceConfigurations: [
          {
            name: 'nic'
            properties: {
              primary: true
              ipConfigurations: [
                {
                  name: 'ipconfig'
                  properties: {
                    subnet: {
                      id: vnet.properties.subnets[0].id
                    }
                  }
                }
              ]
            }
          }
        ]
      }
    }
  }
}

