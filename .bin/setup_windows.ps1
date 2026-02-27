$ErrorActionPreference = "Stop"

$repo = Split-Path -Parent $PSScriptRoot
$homeDir = [Environment]::GetFolderPath("UserProfile")
$binDir = Join-Path $repo ".bin"

$targets = @(
  ".gitconfig",
  ".config/jgit",
  ".config/lazygit",
  ".config/mise",
  ".config/nvim",
  ".config/starship.toml",
  ".config/stylua.toml",
  ".config/vim",
  ".config/vde",
  ".config/wezterm",
  ".config/claude",
  ".config/yazi"
)

function Remove-ExistingPath($path) {
  if (-not (Test-Path -LiteralPath $path)) {
    return $true
  }

  # Replace any existing path (file/dir/link) so setup always converges
  Remove-Item -LiteralPath $path -Force -Recurse
  return $true
}

function New-Link($src, $dst, $isDir) {
  if ($isDir) {
    # Use junction for directories on Windows to avoid symlink privilege requirements.
    New-Item -ItemType Junction -Path $dst -Target $src | Out-Null
    return
  }

  try {
    New-Item -ItemType SymbolicLink -Path $dst -Target $src | Out-Null
  } catch {
    Write-Host "SymbolicLink failed, fallback to HardLink: $dst"
    New-Item -ItemType HardLink -Path $dst -Target $src | Out-Null
  }
}

foreach ($rel in $targets) {
  $src = Join-Path $repo $rel
  if (-not (Test-Path $src)) {
    Write-Host "Skip missing source: $src"
    continue
  }

  $dst = Join-Path $homeDir $rel
  $dstParent = Split-Path -Parent $dst
  if (-not (Test-Path $dstParent)) {
    New-Item -ItemType Directory -Path $dstParent -Force | Out-Null
  }

  if (-not (Remove-ExistingPath -path $dst)) {
    continue
  }

  $srcItem = Get-Item $src -Force
  New-Link -src $src -dst $dst -isDir $srcItem.PSIsContainer
  Write-Host "Linked: $dst -> $src"
}

# PowerShell profile is loaded from Documents/PowerShell, not ~/.config/powershell.
$profileSrc = Join-Path $repo ".config/powershell/Microsoft.PowerShell_profile.ps1"
if (Test-Path -LiteralPath $profileSrc) {
  $documentsDir = [Environment]::GetFolderPath("MyDocuments")
  $profileDst = Join-Path $documentsDir "PowerShell\\Microsoft.PowerShell_profile.ps1"
  $profileParent = Split-Path -Parent $profileDst
  if (-not (Test-Path -LiteralPath $profileParent)) {
    New-Item -ItemType Directory -Path $profileParent -Force | Out-Null
  }

  if (Remove-ExistingPath -path $profileDst) {
    New-Link -src $profileSrc -dst $profileDst -isDir $false
    Write-Host "Linked profile: $profileDst -> $profileSrc"
  }
} else {
  Write-Host "Skip missing PowerShell profile source: $profileSrc"
}

# Ensure git-init template includes .cursorrules so new repos get it automatically.
$cursorRulesSrc = Join-Path $repo ".cursorrules"
if (Test-Path -LiteralPath $cursorRulesSrc) {
  $gitTemplateDir = Join-Path $homeDir ".git_template/git-secrets"
  if (-not (Test-Path -LiteralPath $gitTemplateDir)) {
    New-Item -ItemType Directory -Path $gitTemplateDir -Force | Out-Null
  }

  $cursorRulesDst = Join-Path $gitTemplateDir ".cursorrules"
  Copy-Item -LiteralPath $cursorRulesSrc -Destination $cursorRulesDst -Force
  Write-Host "Installed git template file: $cursorRulesDst"
} else {
  Write-Host "Skip missing source: $cursorRulesSrc"
}

Write-Host "Git template setup completed."

# Ensure dotfiles .bin is available from PATH in all shells.
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
$pathItems = @()
if (-not [string]::IsNullOrWhiteSpace($userPath)) {
  $pathItems = $userPath -split ";"
}

if ($pathItems -notcontains $binDir) {
  if ([string]::IsNullOrWhiteSpace($userPath)) {
    $newUserPath = $binDir
  } else {
    $newUserPath = "$userPath;$binDir"
  }
  [Environment]::SetEnvironmentVariable("Path", $newUserPath, "User")
  $env:Path = "$env:Path;$binDir"
  Write-Host "Added to user PATH: $binDir"
} else {
  Write-Host "Already in user PATH: $binDir"
}

Write-Host "Windows setup completed."
