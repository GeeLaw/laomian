& {
  $local:current = Get-Item -LiteralPath ((Get-Location).Path) -ErrorAction 'Stop';
  While ($current -ne $null)
  {
    If ([System.IO.File]::Exists([System.IO.Path]::Combine($current.FullName, '.vscode', '_laomian_init.ps1')))
    {
      & ([System.IO.Path]::Combine($current.FullName, '.vscode', '_laomian_init.ps1'));
      Return;
    }
    $current = $current.Parent;
  }
  Write-Error -Category 'NotInstalled' -Message 'Could not find "_laomian_init.ps1".';
}
