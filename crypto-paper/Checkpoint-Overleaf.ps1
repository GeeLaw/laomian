#Requires -Version 5.1

<#

.SYNOPSIS
  Creates a commit to attribute authorship.

.DESCRIPTION
  Creates a commit to attribute authorship.
  Run this script after manually recreating the changes
  an author has made on Overleaf.
  After all the changes in a commit created by Overleaf
  are correctly attributed, run "Merge-Overleaf.ps1".

.PARAMETER Author
  The author of the committed changes.
  This should be one of the "CodeNames" in "laomian.json".
  Edit "laomian.json" to supply the information of the authors.
  The null at the end of "Authors" array is for trailing comma.

.PARAMETER Message
  The commit message.
  By default, "Attribute authorship."
  Use "m" as an alias of this parameter.

.PARAMETER Date
  The date/time of the commit.
  By default, in UTC and one second after the later of
  the author date and the comitter date of HEAD.
  This value is passed to Git unmodified.

.PARAMETER All
  If specified, passes "--all" to Git.
  Use "a" as an alias of this switch.

.PARAMETER Amend
  If specified, passes "--amend" to Git.

.PARAMETER Edit
  If specified, passes "--edit" to Git.
  Use "e" as an alias of this switch.

#>
[CmdletBinding(PositionalBinding=$False, SupportsShouldProcess)]
Param
(
  [Parameter(Mandatory, Position=0)]
  [ArgumentCompleter({
    Try
    {
      $local:PatternToMatch = "$($args[2])*";
      $local:Config = Get-Content -LiteralPath ([System.IO.Path]::Combine($PSScriptRoot, 'laomian.json')) -Encoding 'UTF8' -Raw | ConvertFrom-Json | Write-Output;
      $local:Results = [System.Collections.Generic.List[string]]::new();
      ForEach ($local:Person in $local:Config.Authors)
      {
        If ($local:Person -eq $null)
        {
          Continue;
        }
        ForEach ($local:PersonId in $local:Person.CodeNames)
        {
          If ($local:PersonId -like $local:PatternToMatch)
          {
            $local:Results.Add($local:PersonId);
          }
        }
      }
      $local:Results | ForEach-Object { $_ };
    }
    Catch { }
  })]
  [string]$Author,
  [Parameter()]
  [Alias('m')]
  [string]$Message = 'Attribute authorship.',
  [Parameter()]
  [string]$Date = '?',
  [Parameter()]
  [Alias('a')]
  [switch]$All,
  [Parameter()]
  [switch]$Amend,
  [Parameter()]
  [Alias('e')]
  [switch]$Edit
)

End
{
  <# Validate $Author and retrieve the information. #>
  $script:Config = Get-Content -LiteralPath ([System.IO.Path]::Combine($PSScriptRoot, 'laomian.json')) -Encoding 'UTF8' -Raw | ConvertFrom-Json | Write-Output;
  $script:AuthorFound = 0;
  $script:AuthorName = '?';
  $script:AuthorEmail = '?';
  ForEach ($script:Person in $script:Config.Authors)
  {
    If ($script:Person -eq $null)
    {
      Continue;
    }
    ForEach ($script:PersonId in $script:Person.CodeNames)
    {
      If ($script:PersonId -eq $Author)
      {
        $script:AuthorFound = $script:AuthorFound + 1;
        $script:AuthorName = $script:Person.Name;
        $script:AuthorEmail = $script:Person.Email;
      }
    }
  }
  If ($script:AuthorFound -lt 1)
  {
    Write-Error -Category 'InvalidArgument' -Message '$Author could not be found in laomian.json.';
    Return;
  }
  If ($script:AuthorFound -gt 1)
  {
    Write-Error -Category 'MetadataError' -Message 'Multiple matches for $Author in laomian.json.';
    Return;
  }
  If ($script:AuthorName -isnot [string] -or
    [string]::IsNullOrWhiteSpace($script:AuthorName) -or
    $script:AuthorName.Contains('<') -or
    $script:AuthorName.Contains('>') -or
    $script:AuthorEmail -isnot [string] -or
    $script:AuthorEmail.Contains('<') -or
    $script:AuthorEmail.Contains('>'))
  {
    Write-Error -Category 'MetadataError' -Message 'Invalid author information for $Author in laomian.json.';
    Return;
  }
  $script:AuthorInfo = "$script:AuthorName <$script:AuthorEmail>";
  <# Validate $Message. #>
  If ([string]::IsNullOrWhiteSpace($Message))
  {
    Write-Error -Category 'InvalidArgument' -Message '$Message cannot be null or whitespace.';
    Return;
  }
  <# Retrieve $Date if necessary. #>
  $script:FinalTime = $Date;
  $script:FinalTimeUI = $Date;
  If ([string]::IsNullOrWhiteSpace($script:FinalTime) -or $script:FinalTime -eq '?')
  {
    $script:CurrentAT = & 'git' 'show' '--no-patch' '--pretty=format:%at';
    If (-not [uint64]::TryParse(($script:CurrentAT -join ' ').Trim(),
      [System.Globalization.NumberStyles]::None,
      [cultureinfo]::InvariantCulture,
      [ref]$script:CurrentAT
    ))
    {
      Write-Error -Category 'ObjectNotFound' -Message 'Could not retrieve the author date of HEAD.';
      Return;
    }
    $script:CurrentCT = & 'git' 'show' '--no-patch' '--pretty=format:%ct';
    If (-not [uint64]::TryParse(($script:CurrentCT -join ' ').Trim(),
      [System.Globalization.NumberStyles]::None,
      [cultureinfo]::InvariantCulture,
      [ref]$script:CurrentCT
    ))
    {
      Write-Error -Category 'ObjectNotFound' -Message 'Could not retrieve the committer date of HEAD.';
      Return;
    }
    $script:FinalTime = [System.Math]::Max($script:CurrentAT, $script:CurrentCT) + [uint64]1;
    $script:FinalTimeUI = [datetime]::new(
      1970, 1, 1, 0, 0, 0,
      [System.DateTimeKind]::Utc
      <# The following addition loses precision, but it's fine
      <# because this data only used for informational display. #>
    ).AddSeconds($script:FinalTime).ToLocalTime().ToString(
      "yyyy'-'MM'-'dd'T'HH':'mm':'ssK",
      [cultureinfo]::InvariantCulture
    );
    $script:FinalTime = $script:FinalTime.ToString([cultureinfo]::InvariantCulture) + ' +0000';
    $script:FinalTimeUI = "$script:FinalTime (local $script:FinalTimeUI)";
  }
  <# Prepare a description and take care of -WhatIf -Confirm -Verbose. #>
  $script:ActionDesc = "`n Author: $script:AuthorName <$script:AuthorEmail>`n   Date: $script:FinalTimeUI`nMessage: $Message`n";
  If ($All -or $Amend -or $Edit)
  {
    $script:ActionDesc = $script:ActionDesc + ' Switch:';
    If ($All) { $script:ActionDesc = $script:ActionDesc + ' --all'; }
    If ($Amend) { $script:ActionDesc = $script:ActionDesc + ' --amend'; }
    If ($Edit) { $script:ActionDesc = $script:ActionDesc + ' --edit'; }
    $script:ActionDesc = $script:ActionDesc + "`n";
  }
  If (-not $PSCmdlet.ShouldProcess($script:ActionDesc))
  {
    Return;
  }
  <# Ensure that the assignment of $Env:GIT_AUTHOR_EMAIL is not discarded. #>
  If ([string]::IsNullOrWhiteSpace($script:AuthorEmail))
  {
    $script:AuthorEmail = ' ';
  }
  $Env:GIT_AUTHOR_NAME = $script:AuthorName;
  $Env:GIT_AUTHOR_EMAIL = $script:AuthorEmail;
  $Env:GIT_AUTHOR_DATE = $script:FinalTime;
  $Env:GIT_COMMITTER_DATE = $script:FinalTime;
  If ($All)
  {
    If ($Amend)
    {
      If ($Edit)
      {
        <# It's necessary to specify "--author" here because
        <# "--amend" by default takes author from the amended commit. #>
        & 'git' 'commit' '--all' '--amend' '--edit' '--author' ($script:AuthorInfo) '--date' ($script:FinalTime) '--message' ($Message);
      }
      Else
      {
        & 'git' 'commit' '--all' '--amend' '--author' ($script:AuthorInfo) '--date' ($script:FinalTime) '--message' ($Message);
      }
    }
    Else
    {
      If ($Edit)
      {
        & 'git' 'commit' '--all' '--edit' '--author' ($script:AuthorInfo) '--date' ($script:FinalTime) '--message' ($Message);
      }
      Else
      {
        & 'git' 'commit' '--all' '--author' ($script:AuthorInfo) '--date' ($script:FinalTime) '--message' ($Message);
      }
    }
  }
  Else
  {
    If ($Amend)
    {
      If ($Edit)
      {
        & 'git' 'commit' '--amend' '--edit' '--author' ($script:AuthorInfo) '--date' ($script:FinalTime) '--message' ($Message);
      }
      Else
      {
        & 'git' 'commit' '--amend' '--author' ($script:AuthorInfo) '--date' ($script:FinalTime) '--message' ($Message);
      }
    }
    Else
    {
      If ($Edit)
      {
        & 'git' 'commit' '--edit' '--author' ($script:AuthorInfo) '--date' ($script:FinalTime) '--message' ($Message);
      }
      Else
      {
        & 'git' 'commit' '--author' ($script:AuthorInfo) '--date' ($script:FinalTime) '--message' ($Message);
      }
    }
  }
  Remove-Item -Force -LiteralPath 'Env:\GIT_AUTHOR_NAME';
  Remove-Item -Force -LiteralPath 'Env:\GIT_AUTHOR_EMAIL';
  Remove-Item -Force -LiteralPath 'Env:\GIT_AUTHOR_DATE';
  Remove-Item -Force -LiteralPath 'Env:\GIT_COMMITTER_DATE';
}
