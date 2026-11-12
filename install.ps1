# Copies chrome\userChrome.css into the Firefox profile and enables userChrome.css support.
# Works on any Windows machine: auto-detects the profile unless -ProfileDir is given.
param(
  [string]$ProfileDir,
  [string]$ProfileName = 'default-release'
)
$ErrorActionPreference = 'Stop'

if (-not $ProfileDir) {
  $root = Join-Path $env:APPDATA 'Mozilla\Firefox'
  $ini  = Get-Content (Join-Path $root 'profiles.ini')
  $sections = @(); $cur = $null
  foreach ($line in $ini) {
    if ($line -match '^\[(.+)\]$') { $cur = @{ Section = $Matches[1] }; $sections += $cur }
    elseif ($cur -and $line -match '^([^=]+)=(.*)$') { $cur[$Matches[1]] = $Matches[2] }
  }
  $p = $sections | Where-Object { $_.Name -eq $ProfileName } | Select-Object -First 1
  if (-not $p) { throw "Profile '$ProfileName' not found in profiles.ini. Pass -ProfileDir or -ProfileName." }
  $ProfileDir = if ($p.IsRelative -eq '1') { Join-Path $root ($p.Path -replace '/', '\') } else { $p.Path }
}

$target = Join-Path $ProfileDir 'chrome'
New-Item -ItemType Directory -Force -Path $target | Out-Null
Copy-Item -Force (Join-Path $PSScriptRoot 'chrome\userChrome.css') $target

$userJs = Join-Path $ProfileDir 'user.js'
$pref = 'user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);'
if (-not (Test-Path $userJs) -or -not (Select-String -Path $userJs -SimpleMatch $pref -Quiet)) {
  Add-Content -Path $userJs -Value $pref
}

Write-Host "Installed to $target. Restart Firefox to apply."
