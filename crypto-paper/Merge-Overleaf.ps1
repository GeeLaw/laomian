#Requires -Version 5.1

<#

.SYNOPSIS
  Creates a merge commit with Overleaf after attributing authorship.

.DESCRIPTION
  Creates a merge commit with Overleaf after attributing authorship.
  This makes the history with correct authorship the mainline history,
  hence "git blame" will find the correct authors for each line.

.PARAMETER OverleafCommit
  The commit to merge.
  By default, "overleaf/master".

.PARAMETER Message
  The commit message.
  By default, "Attribute authorship."
  Use "m" as an alias of this parameter.

.PARAMETER Date
  The date/time of the merge commit.
  By default, in UTC and one second after the latest of
  - the author date of HEAD,
  - the committer date of HEAD,
  - the author date of $OverleafCommit,
  - the committer date of $OverleafCommit.
  This value is passed to Git unmodified.

.PARAMETER Edit
  If specified, passes "--edit" to Git.
  Use "e" as an alias of this switch.

.PARAMETER NoTreeCheck
  If specified, skips the check that the two commits have the same tree.

#>
[CmdletBinding(PositionalBinding=$False, SupportsShouldProcess)]
Param
(
  [Parameter(Position=0)]
  [string]$OverleafCommit = 'overleaf/master',
  [Parameter()]
  [Alias('m')]
  [string]$Message = 'Attribute authorship.',
  [Parameter()]
  [string]$Date = '?',
  [Parameter()]
  [Alias('e')]
  [switch]$Edit,
  [Parameter()]
  [switch]$NoTreeCheck
)

End
{
  <# Validate script arguments. #>
  If ([string]::IsNullOrWhiteSpace($OverleafCommit))
  {
    Write-Error -Category 'InvalidArgument' -Message '$OverleafCommit cannot be null or whitespace.';
    Return;
  }
  If ($OverleafCommit.Contains('..'))
  {
    Write-Error -Category 'InvalidArgument' -Message '$OverleafCommit cannot be a range.';
    Return;
  }
  If ([string]::IsNullOrWhiteSpace($Message))
  {
    Write-Error -Category 'InvalidArgument' -Message '$Message cannot be null or whitespace.';
    Return;
  }
  <# Retrieve and validate configuration. #>
  $script:Config = Get-Content -LiteralPath ([System.IO.Path]::Combine($PSScriptRoot, 'laomian.json')) -Encoding 'UTF8' -Raw | ConvertFrom-Json | Write-Output;
  $script:AuthorName = $script:Config.ScriptAuthor.Name;
  $script:AuthorEmail = $script:Config.ScriptAuthor.Email;
  If ($script:AuthorName -isnot [string] -or
    [string]::IsNullOrWhiteSpace($script:AuthorName) -or
    $script:AuthorName.Contains('<') -or
    $script:AuthorName.Contains('>') -or
    $script:AuthorEmail -isnot [string] -or
    $script:AuthorEmail.Contains('<') -or
    $script:AuthorEmail.Contains('>'))
  {
    Write-Error -Category 'MetadataError' -Message 'Invalid author information for scripts in laomian.json.';
    Return;
  }
  <# Validate and retrieve the commit hash of HEAD. #>
  $script:CurrentCommit = & 'git' 'rev-parse' '--verify' '--end-of-options' 'HEAD^{commit}';
  $script:CurrentCommit = ($script:CurrentCommit -join ' ').Trim();
  If (-not ($script:CurrentCommit -cmatch '^[0-9a-f]{40}$'))
  {
    Write-Error -Category 'ObjectNotFound' -Message 'Could not retrieve the commit hash of HEAD.';
    Return;
  }
  <# Validate and retrieve the commit hash of $OverleafCommit. #>
  $script:IncomingCommit = & 'git' 'rev-parse' '--verify' '--end-of-options' ($OverleafCommit + '^{commit}');
  $script:IncomingCommit = ($script:IncomingCommit -join ' ').Trim();
  If (-not ($script:IncomingCommit -cmatch '^[0-9a-f]{40}$'))
  {
    Write-Error -Category 'ObjectNotFound' -Message 'Could not retrieve the commit hash of $OverleafCommit.';
    Return;
  }
  <# Check trees of the two commits. #>
  If (-not $NoTreeCheck)
  {
    <# Retrieve the tree hash of HEAD. #>
    $script:CurrentTree = & 'git' 'rev-parse' '--verify' '--end-of-options' ($script:CurrentCommit + '^{tree}');
    $script:CurrentTree = ($script:CurrentTree -join ' ').Trim();
    If (-not ($script:CurrentTree -cmatch '^[0-9a-f]{40}$'))
    {
      Write-Error -Category 'ObjectNotFound' -Message 'Could not retrieve the tree hash of HEAD.';
      Return;
    }
    <# Retrieve the tree hash of $OverleafCommit. #>
    $script:IncomingTree = & 'git' 'rev-parse' '--verify' '--end-of-options' ($script:IncomingCommit + '^{tree}');
    $script:IncomingTree = ($script:IncomingTree -join ' ').Trim();
    If (-not ($script:IncomingTree -cmatch '^[0-9a-f]{40}$'))
    {
      Write-Error -Category 'ObjectNotFound' -Message 'Could not retrieve the tree hash of $OverleafCommit.';
      Return;
    }
    <# Verify that they are the same tree. #>
    If ($script:CurrentTree -ne $script:IncomingTree)
    {
      Write-Error -Category 'InvalidData' -Message "HEAD and `$OverleafCommit has different trees.`nUse `"git diff`" to check the difference.";
      Return;
    }
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
    $script:IncomingAT = & 'git' 'show' '--no-patch' '--pretty=format:%at' $script:IncomingCommit;
    If (-not [uint64]::TryParse(($script:IncomingAT -join ' ').Trim(),
      [System.Globalization.NumberStyles]::None,
      [cultureinfo]::InvariantCulture,
      [ref]$script:IncomingAT
    ))
    {
      Write-Error -Category 'ObjectNotFound' -Message 'Could not retrieve the author date of $OverleafCommit.';
      Return;
    }
    $script:IncomingCT = & 'git' 'show' '--no-patch' '--pretty=format:%ct' $script:IncomingCommit;
    If (-not [uint64]::TryParse(($script:IncomingCT -join ' ').Trim(),
      [System.Globalization.NumberStyles]::None,
      [cultureinfo]::InvariantCulture,
      [ref]$script:IncomingCT
    ))
    {
      Write-Error -Category 'ObjectNotFound' -Message 'Could not retrieve the committer date of $OverleafCommit.';
      Return;
    }
    $script:FinalTime = [System.Math]::Max(
      [System.Math]::Max($script:CurrentAT, $script:CurrentCT),
      [System.Math]::Max($script:IncomingAT, $script:IncomingCT)
    ) + [uint64]1;
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
  $script:ActionDesc = "`nMerge with: $OverleafCommit (commit $script:IncomingCommit)`n    Author: $script:AuthorName <$script:AuthorEmail>`n      Date: $script:FinalTimeUI`n   Message: $Message`n";
  If ($Edit)
  {
    $script:ActionDesc = $script:ActionDesc + "    Switch: --edit`n";
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
  If ($Edit)
  {
    & 'git' 'merge' '--edit' '--message' ($Message) '--no-ff' $script:IncomingCommit;
  }
  Else
  {
    & 'git' 'merge' '--message' ($Message) '--no-ff' $script:IncomingCommit;
  }
  Remove-Item -Force -LiteralPath 'Env:\GIT_AUTHOR_NAME';
  Remove-Item -Force -LiteralPath 'Env:\GIT_AUTHOR_EMAIL';
  Remove-Item -Force -LiteralPath 'Env:\GIT_AUTHOR_DATE';
  Remove-Item -Force -LiteralPath 'Env:\GIT_COMMITTER_DATE';
}
