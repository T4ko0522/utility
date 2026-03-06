# ============================================================================
# PowerShell プロファイル
# ============================================================================

# ----------------------------------------------------------------------------
# カスタムエイリアス・関数
# install: https://github.com/x-motemen/ghq
# install: https://github.com/peco/peco
# ----------------------------------------------------------------------------

# ghqとpecoを使用してリポジトリに移動する関数
function ghcd() {
    Set-Location "$(ghq root)/$(ghq list | peco)"
}

# ----------------------------------------------------------------------------
# PSReadLine設定（入力補完・予測入力）
# ----------------------------------------------------------------------------

Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

# ----------------------------------------------------------------------------
# Starship プロンプト
# install: winget install Starship.Starship
# ----------------------------------------------------------------------------
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}

# ----------------------------------------------------------------------------
# モジュールのインポート
# install: https://github.com/devblackops/Terminal-Icons
# ----------------------------------------------------------------------------

Import-Module Terminal-Icons

# ----------------------------------------------------------------------------
# Git関連の関数
# ----------------------------------------------------------------------------

# 現在のGitブランチ名を取得する関数
function Get-GitBranch {
    try {
        $branch = git symbolic-ref --short HEAD 2>$null
        return $branch
    }
    catch {
        return $null
    }
}

# ----------------------------------------------------------------------------
# https://github.com/antfu-collective/ni とNew-Itemの競合を無効化
# ----------------------------------------------------------------------------
if (-not (Test-Path $profile)) {
    New-Item -ItemType File -Path (Split-Path $profile) -Force -Name (Split-Path $profile -Leaf)
}

$profileEntry = 'Remove-Item Alias:ni -Force -ErrorAction Ignore'
$profileContent = Get-Content $profile
if ($profileContent -notcontains $profileEntry) {
    ("`n" + $profileEntry) | Out-File $profile -Append -Force -Encoding UTF8
}


# ----------------------------------------------------------------------------
# カスタムエイリアス
# ----------------------------------------------------------------------------
Set-Alias wh where.exe

# %USERNAME%/Projectに移動するエイリアス
function cdp {
    Set-Location "$env:USERPROFILE\Project"
}

# %USERNAME%/Project/github.com/T4ko0522に移動するエイリアス
function cdtako {
    Set-Location "$env:USERPROFILE\Project\github.com\T4ko0522"
}
Remove-Item Alias:ni -Force -ErrorAction Ignore
