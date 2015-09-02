<#
.SYNOPSIS
Moves a folder to a different drive at the same location and keeps the original path 
working (leaves a shadow behind).

.DESCRIPTION
This cmdlet is intended to make freeing space on a drive easier by moving 
folders without a configuration change. The original path becomes
a symbolic link to the new destination path and keeps working.

Destination path automatically becomes original path with the new drive letter
(e.g. C:\Program Files\Something gets moved to D:\Program Files\Something). 
It's not possible to specify a new folder.

.NOTES
When you have symbolic links from the system drive to other drives it's impossible
to make a "System Image Backup" on Windows. You have to resort to other tools.

.PARAMETER path
The source path

.PARAMETER destDrive
The destination drive

.EXAMPLE
C:\Program Files> Move-Shadow .\SomeApp d:

(Moves the folder C:\Program Files\SomeApp to D:\Program Files\SomeApp)

.NOTES
The permissions will be preserved in the destination directory but not on the 
symlink created. Not sure if that causes problems.

Author: Sedat Kapanoglu
Date:   August 19th, 2015

.LINK
https://github.com/ssg/Move-Shadow
#>
#Requires -RunAsAdministrator

param (
    [Parameter(Mandatory=$True)]
    [string]$path,
    [Parameter(Mandatory=$True)]
    [string]$destDrive
)

if ($destDrive -NotMatch "[a-z]\:") {
    Write-Error "Invalid destination drive"
    exit 1
}

$ErrorActionPreference = "Stop"

$obj = (Get-Item $path)
if (-not $obj -is [System.IO.DirectoryInfo]) {
    Write-Error "'$path' is not a folder"
    exit 5
}
if ($obj.Attributes -band [IO.FileAttributes]::ReparsePoint) {
    Write-Error "The folder '$path' is already a symlink, cannot be moved again"
    exit 4
}

$parentPath = $obj.Parent.FullName
$srcPath = $obj.FullName

$name = $obj.Name
$tempName = "$name.temp"
$tempPath = (Join-Path $parentPath $tempName)
$destPath = $srcPath.Replace($srcPath.Substring(0, 2), $destDrive)

if (Test-Path $destPath) {
    Write-Error "Destination path '$destPath' already exists"
    exit 2
}
Rename-Item $srcPath $tempName
cmd /c mklink /d $srcPath $destPath | Out-Null
if (-not $?) {
    Write-Error "Symbolic link creation failed. Try running as administrator. Rolling back"
    Rename-Item $tempPath $name
    exit 3
}
Move-Item $tempPath $destPath
