<#
.SYNOPSIS
    Get download URL from specific [Mod] moddb.com download link

.DESCRIPTION
    Function returns the direct download URL based on available mirrors on moddb

.EXAMPLE
    PS> Get-ModdbDlUrl 'https://www.moddb.com/downloads/start/ID_HERE'

    Returns the download URL of the application 'ID_HERE'.

.OUTPUTS
    [String] or $null
#>
function Get-ModdbDlUrl {
	[CmdletBinding()]
    Param
    (
		[ValidatePattern('^https://www.moddb.com/(downloads|addons)/start/\d+$')] [Parameter(Mandatory = $true)] [string] $srcURL
    )
    Begin
    {
		Set-StrictMode -Version 2
		$ErrorActionPreference = 'Stop'
	}
	End
    {
		# Write-Host $srcURL
		if ($srcURL -like '*addons*') {
			$filtered = $srcURL.replace('addons','downloads')
		} else {
			$filtered = $srcURL
		}
		# Write-Host $filtered
		$tokenURL = "($($filtered.replace('start','mirror'))/\w+/\w+)"
		$request = [System.Net.WebRequest]::Create($srcURL)
		$response = $request.GetResponse().GetResponseStream()
		$content = (New-Object System.IO.StreamReader $response).ReadToEnd()
		# Write-Host $content
		return (select-string -Input $content -Pattern $tokenURL).Matches[0].Value
	}
}
