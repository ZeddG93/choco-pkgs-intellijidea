﻿$ErrorActionPreference = 'Stop';

$softwareName = 'IntelliJ IDEA*'
[array]$key = Get-UninstallRegistryKey -SoftwareName $softwareName

if ($key.Count -gt 0) {
    Invoke-Expression -Command $PSScriptRoot\chocolateyUninstall.ps1
}

$url = 'https://download.jetbrains.com/idea/ideaIU-2020.3.2.exe'
$sha256sum = 'b09888627c24a5f4be48e8d0a63a6dd46add3befef4f527feff760b82e03b2d9'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
if ([System.Environment]::Is64BitOperatingSystem) {
    $programFiles = $env:ProgramFiles
} else {
    $programFiles = ${env:ProgramFiles(x86)}
}

$installDir = "$programFiles\JetBrains\IntelliJ IDEA $env:ChocolateyPackageVersion"

$pp = Get-PackageParameters
if ($pp.InstallDir) {
    $installDir = $pp.InstallDir
}



$silentArgs = "/S /CONFIG=$toolsDir\silent.config "
$silentArgs += "/D=$installDir"

New-Item -ItemType Directory -Force -Path $installDir

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = $url
    url64bit       = $url

    softwareName   = $softwareName

    checksum       = $sha256sum
    checksumType   = 'sha256'
    checksum64     = $sha256sum
    checksumType64 = 'sha256'

    silentArgs     = $silentArgs
    validExitCodes = @(0, 1641, 3010)
}

Install-ChocolateyPackage @packageArgs
