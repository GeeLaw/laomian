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
        $targets = @($shapes | ForEach-Object {
          If ($_.PlaceholderFormat.Type -eq 13 <# ppPlaceholderTitle #>)
          {
            $_;
          }
        });
        If ($targets.Count -gt 1)
        {
          Write-Warning "Slide $($index): multiple matches, skipped.";
        }
        ElseIf ($targets.Count -eq 1)
        {
          If ($targets[0].Name -ne '!!SlideNumber')
          {
            Write-Verbose "Slide $($index): renaming $($targets[0].Name).";
            $targets[0].Name = '!!SlideNumber';
          }
          Else
          {
            Write-Verbose "Slide $($index): already named.";
          }
        }
        Else
        {
          Write-Warning "Slide $($index): no slide number placeholder.";
        }
      };
      Write-Verbose "Finished: $($_.Name) (full name: $($_.FullName))";
    }
  }
}
