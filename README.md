# dotfiles

## Description

[@mozumasu](https://github.com/mozumasu/)さんのdotfilesを参考につくられたWindows用のdotfilesです。

## Dependency

| アプリ | 用途 | インストール |
| ------ | ---- | ------------ |
| **PowerShell 7** | シェル・セットアップ実行 | [PowerShell](https://github.com/PowerShell/PowerShell#get-powershell) |
| **Git** | リポジトリ clone・設定 | [git-scm.com](https://git-scm.com/) |
| **WezTerm** | ターミナル | [wezterm.com](https://wezterm.com/#Installation) |
| **Starship** | プロンプト | [starship.rs](https://starship.rs/guide/#%F0%9F%9A%80-installation) |
| **Terminal-Icons** | PowerShell アイコン表示 | [Terminal-Icons](https://github.com/devblackops/Terminal-Icons) |
| **Neovim** | エディタ | [neovim.io](https://neovim.io/) |
| **Lazygit** | TUI Git クライアント | [Lazygit](https://github.com/jesseduffield/lazygit#installation) |
| **ghq** | リポジトリ一元管理 | [ghq](https://github.com/x-motemen/ghq) |
| **peco** | インタラクティブフィルタ (ghcd 用) | [peco](https://github.com/peco/peco) |
| **yazi** | TUI ファイルマネージャ | [yazi](https://github.com/sxyazi/yazi) |
  
`ni` と PowerShell の `New-Item` のエイリアス競合を避けるため、プロファイルで `ni` を無効化しています。

## Setup

### Installation

```powershell
# 1. Clone
git clone https://github.com/T4ko0522/dotfiles
cd dotfiles

# 2. Link config files to your home directory
pwsh -ExecutionPolicy Bypass -File .\.bin\setup_windows.ps1

# 3. Reload shell
pwsh
```
