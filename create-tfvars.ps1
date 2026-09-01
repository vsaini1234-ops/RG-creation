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

# # ============================================
# Terraform TFVARS Generator
# Works in Local PowerShell + Azure DevOps
# ============================================

# Script folder
$scriptFolder = $PSScriptRoot

# CSV file name
$csvFile = Join-Path $scriptFolder "azure_10_resources_portal.csv"

# Output terraform.tfvars
$tfvarsFile = Join-Path $scriptFolder "terraform.tfvars"

Write-Host ""
Write-Host "=========================================="
Write-Host "      Terraform TFVARS Generator"
Write-Host "=========================================="
Write-Host ""

Write-Host "Script Folder : $scriptFolder"
Write-Host "CSV File      : $csvFile"
Write-Host "Output File   : $tfvarsFile"
Write-Host ""

# Check CSV file
if (-not (Test-Path $csvFile)) {

    Write-Host "ERROR: azure_10_resources_portal.csv not found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Files available in script folder:"
    Get-ChildItem $scriptFolder | Select-Object Name

    exit 1
}

# Read CSV
$resources = Import-Csv $csvFile

Write-Host "Total resources found: $($resources.Count)" -ForegroundColor Cyan
Write-Host ""

# Create Terraform content
$lines = @()

$lines += "rgs = {"

foreach ($resource in $resources) {

    $rgName = $resource.'Resource Group Name'.Trim()
    $location = $resource.Location.Trim()

    Write-Host "Adding Resource Group:"
    Write-Host "  Name     : $rgName"
    Write-Host "  Location : $location"
    Write-Host ""

    $lines += "  `"$rgName`" = {"
    $lines += "    name     = `"$rgName`""
    $lines += "    location = `"$location`""
    $lines += "  }"
}

$lines += "}"

# Create terraform.tfvars
$lines | Set-Content -Path $tfvarsFile -Encoding UTF8

Write-Host ""
Write-Host "=========================================="
Write-Host " terraform.tfvars created successfully!"
Write-Host "=========================================="
Write-Host ""

# Display generated file
Write-Host "===== terraform.tfvars ====="
Get-Content $tfvarsFile
Write-Host "============================"
Write-Host ""