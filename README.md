# Terminal

このリポジトリには、Windows環境でのWezTermの設定、PowerShellの設定ファイルが含まれています。

WezTermのconfigは [mozumasu様の記事](https://zenn.dev/mozumasu/articles/mozumasu-wezterm-customization) を参考にWindows用に僕が使いやすいように改変したものになります。

## 構成

- `./WezTerm/wezterm.lua` - メイン設定ファイル
- `./WezTerm/keybinds.lua` - キーバインド設定
- `./Microsoft.PowerShell_profile.ps1` - PowerShell 7のカスタムプロファイル設定

#### 必要なツール
- [WezTerm](https://wezterm.org/install/windows.html)
- [ghq](https://github.com/x-motemen/ghq) - Gitリポジトリ管理ツール
- [peco](https://github.com/peco/peco) - インタラクティブなフィルタリングツール
- [Terminal-Icons](https://github.com/devblackops/Terminal-Icons) - PowerShellモジュール

## セットアップ

### PowerShell プロファイルの配置

1. PowerShell プロファイルの場所を確認:
```powershell
$PROFILE
```
デフォルトはこちらにあります。  
`%USERPROFILE%\OneDrive\ドキュメント\PowerShell\Microsoft.PowerShell_profile.ps1`

2. プロファイルディレクトリが存在しない場合は作成:
```powershell
if (!(Test-Path -Path (Split-Path $PROFILE))) {
    New-Item -ItemType Directory -Path (Split-Path $PROFILE) -Force
}
```

3. プロファイルファイルを配置:
```powershell
# このリポジトリのプロファイルをコピー
Copy-Item Microsoft.PowerShell_profile.ps1 $PROFILE

# またはシンボリックリンクを作成（推奨）
New-Item -ItemType SymbolicLink -Path $PROFILE -Target (Resolve-Path Microsoft.PowerShell_profile.ps1)
```

4. 必要なモジュールをインストール:
```powershell
Install-Module Terminal-Icons -Scope CurrentUser
```

### WezTerm 設定の配置

1. WezTermの設定ディレクトリに配置:
`%USERPROFILE%\.config\wezterm\`

2. 設定ファイルを配置:
```powershell
# 設定ファイルをコピー
Copy-Item WezTerm\wezterm.lua $weztermConfig\
Copy-Item WezTerm\keybinds.lua $weztermConfig\
```

3. WezTermを再起動して設定を反映

#### WezTermでの主なキーバインド

**タブ操作**
- `Shift + Tab` / `Alt + Tab`: タブ移動
- `Shift + t`: 新しいタブを作成
- `Shift + w`: 現在のタブを閉じる
- `Shift + {` / `Shift + }`: タブの順序を入れ替え
- `Shift + 1-9`: タブ番号で切り替え

**ペイン操作** (Alt + q を押してから)
- `d`: 縦分割
- `r`: 横分割
- `x`: ペインを閉じる
- `h/j/k/l`: ペイン間を移動
- `z`: ペインをズーム/ズーム解除
- `s`: ペインサイズ調整モード

**その他**
- `Ctrl + j`: コマンドパレット
- `Alt + Enter`: フルスクリーン切り替え
- `Ctrl + q + [`: コピーモード
- `Ctrl + c/v`: コピー/貼り付け
- `Alt + +/-`: フォントサイズ調整
- `Shift + Alt + r`: 設定の再読み込み
