Param(
    [Parameter(Mandatory = $true)]
    [String] $ResourceGroupName,
    [Parameter(Mandatory = $true)]
    [String] $AppServicePlanName,
    [Parameter(Mandatory = $true)]
    [String] $Tier,
    [Parameter(Mandatory = $true)]
    [String] $WorkerSize
)

$connectionName = "AzureRunAsConnection"
try
{
    # Get the connection "AzureRunAsConnection "
    $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName         

    "Logging in to Azure..."
    Add-AzureRmAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 
}
catch {
    if (!$servicePrincipalConnection)
    {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    } else{
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}

Set-AzureRmAppServicePlan `
 -Name $AppServicePlanName `
 -ResourceGroupName $ResourceGroupName `
 -Tier $Tier `
 -WorkerSize $WorkerSize
