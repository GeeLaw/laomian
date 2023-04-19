[CmdletBinding(PositionalBinding = $False, DefaultParameterSetName = 'Interactive')]
Param
(
  [Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $True, ParameterSetName = 'NonInteractive')]
  [object[]]$Presentation
)

Begin
{
  If ($PSCmdlet.ParameterSetName -eq 'Interactive')
  {
    $Presentation = @(& ([System.IO.Path]::Combine($PSScriptRoot, 'Select-Presentation.ps1')));
  }
  $recursiveGetShapes = {
    $_;
    If ($_.Type -eq 6 <# msoGroup #>)
    {
      $_.GroupItems | ForEach-Object $recursiveGetShapes;
    }
  };
}

Process
{
  ForEach ($pptx In $Presentation)
  {
    If ($pptx -is [System.__ComObject])
    {
      $slides = $pptx.Slides | Write-Output;
      $slides | ForEach-Object {
        $index = $_.SlideIndex;
        $shapes = $_.Shapes | ForEach-Object $recursiveGetShapes;
        $names = $shapes | ForEach-Object {
          If (-not $_.Name.StartsWith('!!'))
          {
            Write-Warning "Name Style: $($_.Name) @ Slide $index."
          }
          $_.Name;
        } | Group-Object;
        $names | ForEach-Object {
          If ($_.Count -gt 1)
          {
            Write-Warning "Name Collision: $($_.Group[0]) @ Slide $index."
          }
        }
      }
      Write-Verbose "Finished: $($_.Name) (full name: $($_.FullName))";
    }
  }
}
