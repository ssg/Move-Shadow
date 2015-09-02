# Move-Shadow
PowerShell cmdlets to move folders transparently between drives

# Usage
`Move-Shadow <path> <destination_drive>`

Given a path Move-Shadow moves the folder to the exact same location in another drive and creates a symlink to it from the original location. So even applications or games can be moved without any configuration change, repair or reinstallation.

I wrote this when I was really short on space on my system drive and needed a simple tool to move some folders to D: but keep existing paths working. Because of that I included another script called `Get-FolderSize` which is a "dir for directories with total sizes included". 

# Example
`PS C:\Program Files> Move-Shadow SomeApp d:`

1. Moves `C:\Program Files\SomeApp` to `D:\Program Files\SomeApp` 
2. Creates a symlink from `C:\Program Files\SomeApp` to `D:\Program Files\SomeApp`.

So SomeApp keeps working.

# Issues
- Must be run as Administrator (PowerShell 4.0+ will warn you about it)
- Windows Backup "Create a System Recovery Image" WILL NOT work after you have symlinks pointing to non-system drive.
- Apps whose folders about to be moved must be quit first before moving otherwise you'll get an error
- If the process is interrupted for any reason the original folder can be found as `FolderName.temp` at the same original location if script fails to restore it for some reason. I didn't implement PowerShell transactions because `mklink` doesn't support it. 
- I wanted this as simple as possible so, no, you can't specify a destination folder yourself. That actually helps in avoiding complications from forgetting folder names and links between them.

# Contact
Sedat Kapanoglu <ssg@sourtimes.org>

# License
MIT. See LICENSE
