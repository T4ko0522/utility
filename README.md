# Dotfiles

## Description
[@mozumasu](https://github.com/mozumasu/)さんのdotfilesを参考につくられたWindows用のdotfilesです。

## Setup (Windows)

### Installation

```powershell
# 1. Clone
git clone https://github.com/t4ko0522/dotfiles
cd dotfiles

# 2. Link config files to your home directory
pwsh -ExecutionPolicy Bypass -File .\.bin\setup_windows.ps1

# 3. Reload shell
pwsh
```

PowerShell profile is linked to `$PROFILE` (for pwsh this is typically `Documents\PowerShell\Microsoft.PowerShell_profile.ps1`).
