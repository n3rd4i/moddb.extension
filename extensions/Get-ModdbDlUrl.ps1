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
		[ValidatePattern('^https://www.moddb.com/downloads/start/\d+$')] [Parameter(Mandatory = $true)] [string] $srcURL
    )
    Begin
    {
		Set-StrictMode -Version 2
		$ErrorActionPreference = 'Stop'
	}
	End
    {
		$tokenURL = "($($srcURL.replace('start','mirror'))/\w+/\w+)"
		$request = [System.Net.WebRequest]::Create($srcURL)
		$response = $request.GetResponse().GetResponseStream()
		$content = (New-Object System.IO.StreamReader $response).ReadToEnd()
		return (select-string -Input $content -Pattern $tokenURL).Matches[0].Value
	}
}
