@description('The Azure region where the resources will be deployed.')
param location string = resourceGroup().location

@description('The name of your free static web app')
param staticWebAppName string

@description('The URL of the GitHub repository.')
param repositoryUrl string

@description('The branch name to deploy from.')
param branch string

@description('The directory for Index.html.')
param indexlocation string

@description('The GitHub Personal Access Token (PAT) with repo scope permissions.')
@secure()
param githubToken string

// 1. Deploy the Free Tier Static Web App into that resource group.
resource staticWebApp 'Microsoft.Web/staticSites@2025-03-01' = {
    name: staticWebAppName
    location: location
    sku: {
        name: 'Free'
        tier: 'Free'
    }
    properties: {
        repositoryUrl: repositoryUrl
        branch: branch
        repositoryToken: githubToken
        buildProperties: {
            appLocation: indexlocation    // Directs Azure to find index.html in the repository root
            apiLocation: ''     // No API currently
            outputLocation: ''  // N/A
        }
    }
}

// 2. Output the URL so you can easily browse to your website.
output siteUrl string = staticWebApp.properties.defaultHostname
