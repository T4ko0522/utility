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
# カスタムプロンプト関数
# ----------------------------------------------------------------------------

function Prompt {
    $currentPath = Get-Location
    $Host.UI.RawUI.WindowTitle = Split-Path -Leaf $currentPath

    Write-Host ""

    # 現在のパスを表示
    Write-Host "[" -NoNewline -ForegroundColor White
    Write-Host $currentPath -NoNewline -ForegroundColor DarkYellow
    Write-Host "]" -NoNewline -ForegroundColor White

    # Gitブランチを表示（存在する場合）
    $branch = Get-GitBranch
    if ($branch) {
        Write-Host " [" -NoNewline -ForegroundColor White
        Write-Host $branch -NoNewline -ForegroundColor DarkCyan
        Write-Host "]" -NoNewline -ForegroundColor White
    }

    # 現在の日時を表示
    $now = Get-Date -Format "yyyy/MM/dd HH:mm"
    Write-Host "`n$now" -ForegroundColor White

    return " > "
}