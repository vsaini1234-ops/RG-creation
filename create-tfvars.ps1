# $csvFile = "C:\Vikram\Pipeline\Pipe line prctice-01-sep\RG-Creation\azure_10_resources_portal.csv"
# $tfvarsFile = ".\terraform.tfvars"

# $resources = Import-Csv $csvFile

# $lines = @()
# $lines += "rgs = {"

# foreach ($resource in $resources) {
#     $rgName = $resource.'Resource Group Name'.Trim()
#     $location = $resource.Location.Trim()

#     $lines += "  `"$rgName`" = {"
#     $lines += "    name     = `"$rgName`""
#     $lines += "    location = `"$location`""
#     $lines += "  }"
# }

# $lines += "}"

# $lines | Set-Content -Path $tfvarsFile -Encoding UTF8

# Write-Host "terraform.tfvars created successfully!" -ForegroundColor Green
# Write-Host "File: $tfvarsFile"




####################################################


## script local and pipeline

# ==========================================
# CSV to Terraform TFVARS Generator
# ==========================================

# Script jis folder mein hai
$scriptFolder = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Input CSV - script ke same folder mein
$csvFile = Join-Path $scriptFolder "resources.csv"

# Output terraform.tfvars - script ke same folder mein
$tfvarsFile = Join-Path $scriptFolder "terraform.tfvars"

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "   Terraform TFVARS Generator" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Script Folder : $scriptFolder"
Write-Host "CSV File      : $csvFile"
Write-Host "Output File   : $tfvarsFile"
Write-Host ""

# Check CSV exists
if (-not (Test-Path $csvFile)) {
    Write-Host "ERROR: resources.csv not found!" -ForegroundColor Red
    Write-Host "Please keep resources.csv in the same folder as this script."
    exit 1
}

# Read CSV
$resources = Import-Csv $csvFile

# Start Terraform map
$lines = @()
$lines += 'resource_groups = {'

foreach ($resource in $resources) {

    $rgName = $resource.'Resource Group Name'.Trim()
    $location = $resource.Location.Trim()

    $lines += "  `"$rgName`" = {"
    $lines += "    name     = `"$rgName`""
    $lines += "    location = `"$location`""
    $lines += "  }"
}

$lines += '}'

# Create terraform.tfvars
$lines | Set-Content -Path $tfvarsFile -Encoding UTF8

Write-Host ""
Write-Host "==========================================" -ForegroundColor Green
Write-Host " terraform.tfvars CREATED SUCCESSFULLY" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""

Write-Host "Saved at:"
Write-Host $tfvarsFile -ForegroundColor Yellow

Write-Host ""
Write-Host "File exists:" (Test-Path $tfvarsFile)
Write-Host ""