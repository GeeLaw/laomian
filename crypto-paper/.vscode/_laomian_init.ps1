#Requires -Version 5.1

[CmdletBinding()]
Param()

End
{
  $script:RepoRoot = Split-Path -Path $PSScriptRoot -Parent;
  <# Add the repository root to PATH with error detection. #>
  If ([System.Environment]::OSVersion.Platform -eq 'Win32NT')
  {
    If ($script:RepoRoot.Contains(';'))
    {
      Write-Warning -Message "Did not add repository root to PATH.`n REASON: The repository root path contains semi-colon (PATH separator on Windows).";
    }
    Else
    {
      $script:NewPath = $script:RepoRoot + ';' + $Env:PATH;
      If ($script:NewPath.Length -gt 2047)
      {
        Write-Warning -Message "Did not add repository root to PATH.`n REASON: The new value of PATH would exceed 2047 UTF-16 code units (limit on Windows).";
      }
      Else
      {
        $Env:PATH = $script:NewPath;
      }
    }
  }
  ElseIf ([System.Environment]::OSVersion.Platform -eq 'Unix')
  {
    If ($script:RepoRoot.Contains(':'))
    {
      Write-Warning -Message "Did not add repository root to PATH.`n REASON: The repository root path contains colon (PATH separator on Unix).";
    }
    Else
    {
      $script:NewPath = $script:RepoRoot + ':' + $Env:PATH;
      <# I do not know the limit on Unix. #>
      $Env:PATH = $script:NewPath;
    }
  }
  Else
  {
    Write-Warning -Message "Did not add repository root to PATH.`n REASON: Unknown operating system.";
  }
  <# Change the current directory to "paper" if we are starting at repository root. #>
  If ((Get-Location).Path -eq $script:RepoRoot)
  {
    Set-Location -LiteralPath ([System.IO.Path]::Combine($script:RepoRoot, 'paper'));
  }
}
