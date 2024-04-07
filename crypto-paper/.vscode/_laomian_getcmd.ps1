#Requires -Version 5.1

<#

.SYNOPSIS
  Convert "_laomian_cmd.ps1" into $EncodedCommand format.

.DESCRIPTION
  The script returns a single string, the value of $EncodedCommand.

  The maximum command line length on Windows is 32767 UTF-16 code units.
  If the encoded command length exceeds 31000, an error is produced.
  If it exceeds 2048, a warning is produced.

#>
[CmdletBinding()]
Param()

End
{
  $script:cmd = Get-Content -LiteralPath ([System.IO.Path]::Combine($PSScriptRoot, '_laomian_cmd.ps1')) -Encoding 'UTF8' -Raw -ErrorAction 'Stop';
  If ($script:cmd -eq $null)
  {
    Return;
  }
  $script:cmd = [regex]::new('[ \r\n]+').Replace($script:cmd, ' ').Trim();
  Write-Verbose -Message "After space coalescing, the command string is`n$script:cmd";
  $script:cmd = [System.Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($script:cmd));
  If ($script:cmd.Length -gt 31000)
  {
    Write-Error -Category 'LimitsExceeded' -Message 'The encoded command length exceeds 31000. The maximum command line length on Windows is 32767 UTF-16 code units.';
  }
  ElseIf ($script:cmd.Length -gt 2048)
  {
    Write-Warning -Message 'The encoded command length exceeds 2048.';
  }
  Return $script:cmd;
}
