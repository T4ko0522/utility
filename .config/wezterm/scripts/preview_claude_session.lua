#!/usr/bin/env lua

-- コマンドライン引数
local sessions_file = arg[1]
local selected_line = arg[2]

-- 色定義
local PURPLE = '\x1b[38;5;141m'
local BLUE = '\x1b[38;5;117m'
local WHITE = '\x1b[38;5;255m'
local GRAY = '\x1b[38;5;240m'
local GREEN = '\x1b[38;5;114m'
local YELLOW = '\x1b[38;5;214m'
local RESET = '\x1b[0m'

-- 簡易JSONパーサー（フラットな文字列値のみ対応）
local function parse_json_line(line)
  local obj = {}
  for key, value in line:gmatch('"([^"]+)"%s*:%s*"([^"]*)"') do
    obj[key] = value
  end
  return obj
end

-- pane_idを抽出
local pane_id = selected_line:match("|([^|]+)$")

if not pane_id then
  print("Error: Could not extract pane_id")
  os.exit(1)
end

-- JSONLファイルを読み込み、pane_idにマッチする行を検索
local workspace = ""
local project = ""
local cwd = ""
local content = ""
local tab_title = ""
local status = "idle"

local file = io.open(sessions_file, "r")
if not file then
  print("Error: Failed to open sessions file")
  os.exit(1)
end

for line in file:lines() do
  if line:find('"pane_id"') and line:find(pane_id, 1, true) then
    local obj = parse_json_line(line)
    if obj.pane_id == pane_id then
      workspace = obj.workspace or ""
      project = obj.project or ""
      cwd = obj.cwd or ""
      content = obj.content or ""
      tab_title = obj.tab_title or ""
      status = obj.status or "idle"
      break
    end
  end
end
file:close()

-- ヘッダー表示
print(GRAY .. "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" .. RESET)
print(PURPLE .. "🤖 Claude Code Session" .. RESET)
print(GRAY .. "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" .. RESET)
print("")

-- ステータス表示
local status_display
if status == "running" then
  status_display = GREEN .. "● running" .. RESET
elseif status == "waiting" then
  status_display = YELLOW .. "◐ waiting" .. RESET
else
  status_display = GRAY .. "○ idle" .. RESET
end

-- セッション詳細
print(WHITE .. "Status:   " .. RESET .. " " .. status_display)
print(WHITE .. "Workspace:" .. RESET .. " " .. PURPLE .. workspace .. RESET)
print(WHITE .. "Project:  " .. RESET .. " " .. BLUE .. project .. RESET)
print(WHITE .. "Tab:      " .. RESET .. " " .. GRAY .. tab_title .. RESET)
print(WHITE .. "Path:     " .. RESET .. " " .. GRAY .. cwd .. RESET)
print("")

-- セッション内容
if content ~= "" and content ~= "null" then
  print(WHITE .. "Session Content:" .. RESET)
  print("  " .. content)
  print("")
end

-- 最新出力
print(GRAY .. "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" .. RESET)
print(WHITE .. "Recent Output" .. RESET)
print(GRAY .. "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" .. RESET)
print("")

-- wezterm cliでペイン出力取得（末尾20行をLuaで切り出し）
local wezterm_cmd = string.format("wezterm cli get-text --pane-id %s 2>NUL", pane_id)
local wezterm_handle = io.popen(wezterm_cmd)
if wezterm_handle then
  local lines = {}
  for line in wezterm_handle:lines() do
    lines[#lines + 1] = line
  end
  wezterm_handle:close()

  -- 末尾20行を取得
  local start = math.max(1, #lines - 19)
  local has_output = false
  for i = start, #lines do
    print(lines[i])
    has_output = true
  end

  if not has_output then
    print(GRAY .. "(Could not retrieve pane output)" .. RESET)
  end
else
  print(GRAY .. "(wezterm cli not available)" .. RESET)
end
