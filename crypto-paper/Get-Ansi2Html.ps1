[CmdletBinding()]
Param()

End
{
  $script:Dest = [System.IO.Path]::Combine($PSScriptRoot, 'ansi2html.sh');
  Start-BitsTransfer -Source 'https://raw.githubusercontent.com/pixelb/scripts/master/scripts/ansi2html.sh' -Destination $script:Dest;
}
