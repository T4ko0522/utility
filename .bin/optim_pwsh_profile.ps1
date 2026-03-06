# リポジトリのプロファイルを読み、コメント・空行を削除して $PROFILE のコピー先に書き出す。
# setup_windows.ps1 から呼ばれる。出力先は呼び出し元で指定（Documents\PowerShell\Microsoft.PowerShell_profile.ps1 等）。

param(
  [Parameter(Mandatory = $false)]
  [string]$SourcePath,
  [Parameter(Mandatory = $false)]
  [string]$OutputPath
)

$ErrorActionPreference = "Stop"

if (-not $SourcePath) {
  $repo = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
  $SourcePath = Join-Path $repo ".config/powershell/Microsoft.PowerShell_profile.ps1"
}
if (-not $OutputPath) {
  $OutputPath = $PROFILE
}

if (-not (Test-Path -LiteralPath $SourcePath)) {
  Write-Error "Source profile not found: $SourcePath"
}

$content = Get-Content -LiteralPath $SourcePath -Raw
$content = $content -replace '(?s)<#.*?#>', ''
$lines = $content -split "`r?`n"
$kept = $lines | ForEach-Object {
  $t = $_.Trim()
  if ($t -eq '') { return $null }
  if ($t.StartsWith('#')) { return $null }
  $_
} | Where-Object { $null -ne $_ }
$output = ($kept -join "`n").Trim()
Set-Content -LiteralPath $OutputPath -Value $output -Encoding UTF8
Write-Host "Wrote cleaned profile: $OutputPath"
