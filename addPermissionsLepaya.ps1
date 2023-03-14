param ($servicePrincipalId, $resourceId)
if(-not($servicePrincipalId)) { Throw “Value for -servicePrincipalId is required.” }

# Check dependencies
$msGraphApplicationsModule = Get-Module 'Microsoft.Graph.Applications' -List

If (!$msGraphApplicationsModule) {
    Write-Output "Installing dependencies...."
    Install-Module 'Microsoft.Graph.Applications' -Force
    Write-Output "Dependencies installed."
}

# Login
Connect-MgGraph -Scopes "Application.ReadWrite.All", "AppRoleAssignment.ReadWrite.All"

# Check service principal Id
if ([string]::IsNullOrEmpty((Get-MgServicePrincipal -ServicePrincipalId $servicePrincipalId))) {
        Throw “ERROR: Service Principal with id: $servicePrincipalId does not exist. Make sure value of -servicePrincipalId is correct.”
}

# Get all existing permissions
$existingPermissions = Get-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $servicePrincipalId

if ([string]::IsNullOrEmpty($resourceId)) {
    if (!$existingPermissions) {
        Throw “There are no existing Aplication permissions. Please provide resourceId for resource you want to assign permissions.”
    }
    $resourceId = $existingPermissions[0].ResourceId
}
# Full set of required permissions for automatic onboarding
$permissions =@(

    # GroupMember.Read.All
    @{
        PrincipalId = $servicePrincipalId
        ResourceId = $resourceId
        AppRoleId = "98830695-27a2-44f7-8c18-0c3ebc9698f6"
    }

    # User.Read.All
    @{
        PrincipalId = $servicePrincipalId
        ResourceId = $resourceId
        AppRoleId = "df021288-bdef-4463-88db-98f22de89214"
    }

    # Team.Create
    @{
        PrincipalId = $servicePrincipalId
        ResourceId = $resourceId
        AppRoleId = "23fc2474-f741-46ce-8465-674744c5c361"
    }

    # Team.ReadBasic.All
    @{
        PrincipalId = $servicePrincipalId
        ResourceId = $resourceId
        AppRoleId = "2280dda6-0bfd-44ee-a2f4-cb867cfc4c1e"
    }

    # TeamSettings.ReadWrite.All
    @{
        PrincipalId = $servicePrincipalId
        ResourceId = $resourceId
        AppRoleId = "bdd80a03-d9bc-451d-b7c4-ce7c63fe3c8f"
    }

    # TeamMember.ReadWrite.All
    @{
        PrincipalId = $servicePrincipalId
        ResourceId = $resourceId
        AppRoleId = "0121dc95-1b9f-4aed-8bac-58c5ac466691"
    }

    # TeamsAppInstallation.ReadWriteForTeam.All
    @{
        PrincipalId = $servicePrincipalId
        ResourceId = $resourceId
        AppRoleId = "5dad17ba-f6cc-4954-a5a2-a0dcc95154f0"
    }

    # TeamsActivity.Send
    @{
        PrincipalId = $servicePrincipalId
        ResourceId = $resourceId
        AppRoleId = "a267235f-af13-44dc-8385-c1dc93023186"
    }

    # AppCatalog.Read.All
    @{
        PrincipalId = $servicePrincipalId
        ResourceId = $resourceId
        AppRoleId = "e12dae10-5a57-4817-b79d-dfbec5348930"
    }

    # Application.Read.All
    @{
        PrincipalId = $servicePrincipalId
        ResourceId = $resourceId
        AppRoleId = "9a5d68dd-52b0-4cc2-bd40-abcf44ac3a30"
    }
)

# Assign full set of $permissions for automatic onboarding method

# Set the $i counter variable to zero.
$i = 0
foreach ($permission in $permissions)
{
    # Increment the $i counter variable which is used to create the progress bar.
    $i = $i+1
    # Determine the completion percentage
    $Completed = ($i/$permissions.count) * 100
    # Use Write-Progress to output a progress bar.
    Write-Progress -Activity "Seting application permissions" -Status "Progress:" -PercentComplete $Completed

    # Checks if the $permission exists in the service principal.
    $hasPermission = $existingPermissions | Where-Object AppRoleId -eq $permission.AppRoleId

    # Adds $permission to service principal if it does not exist.
    if (!$hasPermission) {
        New-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $servicePrincipalId -BodyParameter $permission | Out-Null
    }
}

# Output granted application permission
$grantedPermissions = Get-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $servicePrincipalId
Write-Output "----------------------------------------------------------------"
Write-Output ($grantedPermissions[0].ResourceDisplayName + " " + "application permissions granted to" + " " +  $grantedPermissions[0].PrincipalDisplayName + ":")
$grantedPermissions | Format-List -Property AppRoleId, CreatedDateTime
Write-Output "----------------------------------------------------------------"
Write-Output "Done."
