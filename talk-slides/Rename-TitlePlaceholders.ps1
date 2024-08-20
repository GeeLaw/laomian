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
          $pht = $_.PlaceholderFormat.Type;
          If ($pht -eq 1 <# ppPlaceholderTitle #> -or $pht -eq 3)
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
          If ($targets[0].Name -eq '!!PresentationTitle')
          {
            Write-Warning "Slide $($index): skipping !!PresentationTitle.";
          }
          ElseIf ($targets[0].Name -ne '!!Title')
          {
            Write-Verbose "Slide $($index): renaming $($targets[0].Name).";
            $targets[0].Name = '!!Title';
          }
          Else
          {
            Write-Verbose "Slide $($index): already named.";
          }
        }
        Else
        {
          Write-Warning "Slide $($index): no title placeholder.";
        }
      };
      Write-Verbose "Finished: $($_.Name) (full name: $($_.FullName))";
    }
  }
}
