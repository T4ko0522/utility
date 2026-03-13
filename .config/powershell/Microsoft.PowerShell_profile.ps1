# ============================================================================
# PowerShell プロファイル
# ============================================================================

# ----------------------------------------------------------------------------
# モジュールのインポート
# install: https://github.com/devblackops/Terminal-Icons
# ----------------------------------------------------------------------------

Import-Module Terminal-Icons

# ----------------------------------------------------------------------------
# https://github.com/antfu-collective/ni とNew-Itemの競合を無効化
# ----------------------------------------------------------------------------
Remove-Item Alias:ni -Force -ErrorAction Ignore

# ----------------------------------------------------------------------------
# PSReadLine設定（入力補完・予測入力）
# ----------------------------------------------------------------------------

Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineOption -MaximumHistoryCount 16384
Set-PSReadLineOption -BellStyle None
Set-PSReadLineOption -Colors @{
    Command              = "Green"
    Error                = "Red"
    InlinePrediction      = "Magenta"
    ListPrediction        = "Magenta"
    ListPredictionSelected = "#e066ff"
}

# ----------------------------------------------------------------------------
# Starship プロンプト初期化
# install: winget install Starship.Starship
# ----------------------------------------------------------------------------
Invoke-Expression (&starship init powershell)
$script:__StarshipPrompt = (Get-Item function:Prompt).ScriptBlock

# 長時間コマンド完了時に WezTerm で通知音（BEL を送る）
$script:__WeztermBellLastPrompt = $null
function Prompt {
    $now = Get-Date
    if ($null -ne $script:__WeztermBellLastPrompt) {
        $sec = ($now - $script:__WeztermBellLastPrompt).TotalSeconds
        if ($sec -ge 5) { Write-Host "`a" -NoNewline }
    }
    $script:__WeztermBellLastPrompt = $now
    return (& $script:__StarshipPrompt)
}

# ----------------------------------------------------------------------------
# カスタムエイリアス・関数
# ----------------------------------------------------------------------------
Set-Alias wh where.exe
Set-Alias vi nvim
Set-Alias open explorer

# 上位ディレクトリへ一気に移動（... = 2階上, .... = 3階上, ..... = 4階上）
function ... { Set-Location ../.. }
function .... { Set-Location ../../.. }
function ..... { Set-Location ../../../.. }

# git init 後に .cursorrules を自動配置
function git {
    if ($args.Count -ge 1 -and $args[0] -eq "init") {
        git.exe @args
        $src = Join-Path $env:USERPROFILE ".git_template/git-secrets/.cursorrules"
        if (Test-Path -LiteralPath $src) {
            Copy-Item -LiteralPath $src -Destination ".cursorrules" -Force
        }
    } else {
        git.exe @args
    }
}

# %USERNAME%/Projectに移動するエイリアス
function cdp {
    Set-Location "$env:USERPROFILE\Project"
}

# %USERNAME%/Project/github.com/T4ko0522に移動するエイリアス
function cdtako {
    Set-Location "$env:USERPROFILE\Project\github.com\T4ko0522"
}

# ghqとpecoを使用してリポジトリに移動する関数
# install: https://github.com/x-motemen/ghq
# install: https://github.com/peco/peco
function ghcd() {
    Set-Location "$(ghq root)/$(ghq list | peco)"
}

# yaziで移動したディレクトリにシェルもcdするラッパー関数
function yz {
    $tmp = [System.IO.Path]::GetTempFileName()
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content -Path $tmp -ErrorAction SilentlyContinue
    if ($cwd -and $cwd -ne $PWD.Path) {
        Set-Location -Path $cwd
    }
    Remove-Item -Path $tmp -ErrorAction SilentlyContinue
}