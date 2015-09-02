<#
.SYNOPSIS
Retrieves folders with sizes in given directory (current directory by default)

.DESCRIPTION
This cmdlet calculates size of folders in a given folder.

.PARAMETER path
The source path (default '.')

.EXAMPLE
C:\Program Files> Get-FolderSize

.NOTES
Author: Sedat Kapanoglu
Date:   August 31st, 2015

.LINK
https://github.com/ssg/Move-Shadow
#>
param (
    [string]$path = "."
)

$items = Get-ChildItem -Directory -Path $path

foreach ($item in $items) {
    $size = Get-ChildItem -Path $item.FullName -Recurse -ErrorAction 0 | Measure-Object -ErrorAction 0 -Sum -Property Length | Select Sum
    New-Object PSObject -Property @{ 
        Size = $size.Sum 
        Item = $item
    }
}
