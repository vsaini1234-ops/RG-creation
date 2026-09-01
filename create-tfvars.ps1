$csvFile = "C:\Vikram\Pipeline\Pipe line prctice-01-sep\RG-Creation\azure_10_resources_portal.csv"
$tfvarsFile = ".\terraform.tfvars"

$resources = Import-Csv $csvFile

$lines = @()
$lines += "resource_groups = {"

foreach ($resource in $resources) {
    $rgName = $resource.'Resource Group Name'.Trim()
    $location = $resource.Location.Trim()

    $lines += "  `"$rgName`" = {"
    $lines += "    name     = `"$rgName`""
    $lines += "    location = `"$location`""
    $lines += "  }"
}

$lines += "}"

$lines | Set-Content -Path $tfvarsFile -Encoding UTF8

Write-Host "terraform.tfvars created successfully!" -ForegroundColor Green
Write-Host "File: $tfvarsFile"