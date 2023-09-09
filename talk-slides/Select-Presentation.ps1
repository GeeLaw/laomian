[CmdletBinding(
  DefaultParameterSetName = 'ByIndex',
  PositionalBinding = $False,
  SupportsShouldProcess = $True,
  ConfirmImpact = 'High'
)]
Param
(
  [Parameter(Mandatory = $False, Position = 0, ParameterSetName = 'ByIndex')]
  [int]$Index = 0,
  [Parameter(Mandatory = $True, ParameterSetName = 'ByName')]
  [string]$Name,
  [Parameter(Mandatory = $False, ParameterSetName = 'ByIndex')]
  [Parameter(Mandatory = $False, ParameterSetName = 'ByName')]
  [switch]$Force
)

$ppt = New-Object -ComObject PowerPoint.Application;
$pptx = $null;
$choiceKeys = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
$reason = [System.Management.Automation.ShouldProcessReason]::None;
$reasonWhatIf = [System.Management.Automation.ShouldProcessReason]::WhatIf;
<# Non-positive index means select interactively. #>
If ($PSCmdlet.ParameterSetName -eq 'ByIndex')
{
  If ($Index -gt 0)
  {
    If ($Index -gt $ppt.Presentations.Count)
    {
      Throw ([System.IndexOutOfRangeException]::new('Index is greater than the number of open PowerPoint Presentations.'));
      Return;
    }
    $pptx = $ppt.Presentations[$Index];
    If ($Force -or $PSCmdlet.ShouldProcess(
      'Select ' + $pptx.FullName,
      'Do you want to select ' + $pptx.FullName,
      'Select-PowerPointPresentation',
      [ref]$reason))
    {
      <# Allow the procedure to continue. #>
    }
    Else
    {
      $pptx = $null;
      <# ShouldProcess returned false not because of WhatIf. #>
      If (($reason -band $reasonWhatIf) -ne $reasonWhatIf)
      {
        Throw ([System.OperationCanceledException]::new('User canceled the operation.'));
        Return;
      }
    }
  }
  ElseIf ($ppt.Presentations.Count -eq 1)
  {
    $pptx = $ppt.Presentations[1];
    If ($Force -or $PSCmdlet.ShouldProcess(
      'Select ' + $pptx.FullName,
      'Do you want to select ' + $pptx.FullName,
      'Select-PowerPointPresentation',
      [ref]$reason))
    {
      <# Allow the procedure to continue. #>
    }
    Else
    {
      $pptx = $null;
      <# ShouldProcess returned false not because of WhatIf. #>
      If (($reason -band $reasonWhatIf) -ne $reasonWhatIf)
      {
        Throw ([System.OperationCanceledException]::new('User canceled the operation.'));
        Return;
      }
    }
  }
  ElseIf ($ppt.Presentations.Count -eq 0)
  {
    Throw ([System.InvalidOperationException]::new('There is no open PowerPoint Presentation.'));
    Return;
  }
  ElseIf ($ppt.Presentations.Count -lt $choiceKeys.Length)
  {
    $choices = [System.Collections.ObjectModel.Collection[System.Management.Automation.Host.ChoiceDescription]]::new();
    $choices.Add([System.Management.Automation.Host.ChoiceDescription]::new(
      "[&$($choiceKeys[0])] Cancel",
      'Cancel the action.'
    ));
    $ppt.Presentations | ForEach-Object { $choices.Add(
      [System.Management.Automation.Host.ChoiceDescription]::new(
        "[&$($choiceKeys[$choices.Count])] $($_.Name)",
        $_.FullName)
    ); };
    $choice = $Host.UI.PromptForChoice('Select-PowerPointPresentation',
      'Choose a PowerPoint Presentation',
      $choices,
      -1);
    If ($choice -gt 0 -and $choice -le $ppt.Presentations.Count)
    {
      $pptx = $ppt.Presentations[$choice];
      If ("[&$($choiceKeys[$choice])] $($pptx.Name)" -ne $choices[$choice].Label -or $pptx.FullName -ne $choices[$choice].HelpMessage)
      {
        $pptx = $null;
        Throw ([System.InvalidOperationException]::new('The set of PowerPoint Presentations has changed.'));
        Return;
      }
      ElseIf ($WhatIfPreference -and -not $PSCmdlet.ShouldProcess(
        'Select ' + $pptx.FullName,
        'Do you want to select ' + $pptx.FullName,
        'Select-PowerPointPresentation',
        [ref]$reason))
      {
        <# In case this is a selection in the presence of WhatIf. #>
        $pptx = $null;
        <# Mysterious case... Should never happen. #>
        If (($reason -band $reasonWhatIf) -ne $reasonWhatIf)
        {
          Throw ([System.OperationCanceledException]::new('User canceled the operation.'));
          Return;
        }
      }
    }
    ElseIf ($choice -gt 0)
    {
      Throw ([System.InvalidOperationException]::new('The set of PowerPoint Presentations has changed.'));
      Return;
    }
    Else
    {
      Throw ([System.OperationCanceledException]::new('User canceled the operation.'));
      Return;
    }
  }
  Else
  {
    Write-Host 'List of open PowerPoint Presentations:';
    $ppt.Presentations | ForEach-Object -Begin { $i = 1 } -Process {
      Write-Host "[$i] $($_.Name) (full name: $($_.FullName))";
      $i = $i + 1;
    };
    Throw ([System.NotSupportedException]::new('Too many open PowerPoint Presentations.'));
    Return;
  }
}
Else
{
  <# ParameterSetName is 'ByName' #>
  $candidates = @($ppt.Presentations | Where-Object { $_.Name -like $Name });
  If ($candidates.Count -eq 0)
  {
    Throw ([System.InvalidOperationException]::new("No open PowerPoint Presentation matches $Name"));
    Return;
  }
  ElseIf ($candidates.Count -eq 1)
  {
    $pptx = $candidates[0];
    If ($Force -or $PSCmdlet.ShouldProcess(
      "Select $($pptx.Name) (full name: $($pptx.FullName)).",
      "Do you want to select $($pptx.Name) (full name: $($pptx.FullName))?",
      'Select-PowerPointPresentation',
      [ref]$reason))
    {
      <# Allow the procedure to continue. #>
    }
    Else
    {
      $pptx = $null;
      <# ShouldProcess returned false not because of WhatIf. #>
      If (($reason -band $reasonWhatIf) -ne $reasonWhatIf)
      {
        Throw ([System.OperationCanceledException]::new('User canceled the operation.'));
        Return;
      }
    }
  }
  ElseIf ($candidates.Count -lt $choiceKeys.Length)
  {
    $choices = [System.Collections.ObjectModel.Collection[System.Management.Automation.Host.ChoiceDescription]]::new();
    $choices.Add([System.Management.Automation.Host.ChoiceDescription]::new(
      "[&$($choiceKeys[0])] Cancel",
      'Cancel the action.'
    ));
    $candidates | ForEach-Object { $choices.Add(
      [System.Management.Automation.Host.ChoiceDescription]::new(
        "[&$($choiceKeys[$choices.Count])] $($_.Name)",
        $_.FullName)
    ); };
    $choice = $Host.UI.PromptForChoice('Select-PowerPointPresentation',
      'Choose a PowerPoint Presentation',
      $choices,
      -1);
    If ($choice -gt 0)
    {
      $pptx = $candidates[$choice - 1];
      <# In case this is a selection in the presence of WhatIf. #>
      If ($WhatIfPreference -and -not $PSCmdlet.ShouldProcess(
        "Select $($pptx.Name) (full name: $($pptx.FullName)).",
        "Do you want to select $($pptx.Name) (full name: $($pptx.FullName))?",
        'Select-PowerPointPresentation',
        [ref]$reason))
      {
        $pptx = $null;
        <# Mysterious case... Should never happen. #>
        If (($reason -band $reasonWhatIf) -ne $reasonWhatIf)
        {
          Throw ([System.OperationCanceledException]::new('User canceled the operation.'));
          Return;
        }
      }
    }
    Else
    {
      Throw ([System.OperationCanceledException]::new('User canceled the operation.'));
      Return;
    }
  }
  Else
  {
    Write-Host 'List of candidate PowerPoint Presentations:';
    $candidates | ForEach-Object -Begin { $i = 1 } -Process {
      Write-Host "[$i] $($_.Name) (full name: $($_.FullName))";
      $i = $i + 1;
    };
    Throw ([System.NotSupportedException]::new('Too many candidate PowerPoint Presentations.'));
    Return;
  }
}

If ($pptx -ne $null)
{
  $pptx;
}
