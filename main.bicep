param storageName string = 'st${uniqueString(resourceGroup().id)}'
param location string = resourceGroup().location

resource stg 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}
