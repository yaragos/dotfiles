-- Load wezterm API and get config object
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-------------------- appearance --------------------
-- config.default_cursor_style = 'BlinkingBlock'
config.enable_scroll_bar = true
config.color_scheme = 'tokyonight_moon'
-- config.color_scheme = 'Nord (Gogh)'
-- window transparency
config.window_background_opacity = 0.9
config.macos_window_background_blur = 10
-- config.background = {
--   {
--     source = {
--       File = '~/path/to/wallpaper.png',
--     },
--   }
-- }
config.window_decorations = "TITLE | RESIZE"
config.use_fancy_tab_bar = false
config.enable_tab_bar = true
config.show_tab_index_in_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.8,
}


-- font and window
config.font = wezterm.font("CaskaydiaCove Nerd Font")
config.font_size = 13
config.initial_cols = 130
config.initial_rows = 35

-- default shell
config.set_environment_variables = {
  -- COMSPEC = 'C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe',
  COMSPEC = 'zsh',
}

-------------------- utils --------------------
local function is_found(str, pattern)
   return string.find(str, pattern) ~= nil
end
local function what_platform()
   local is_win = is_found(wezterm.target_triple, 'windows')
   local is_linux = is_found(wezterm.target_triple, 'linux')
   local is_mac = is_found(wezterm.target_triple, 'apple')
   local os = is_win and 'windows' or is_linux and 'linux' or is_mac and 'mac' or 'unknown'
   return {
      os = os,
      is_win = is_win,
      is_linux = is_linux,
      is_mac = is_mac,
   }
end

-------------------- keybindings --------------------
local mod = {}
local platform = what_platform()
if platform.is_mac then
   mod.SUPER = 'SUPER'
   mod.SUPER_REV = 'SUPER|CTRL'
elseif platform.is_win or platform.is_linux then
   mod.SUPER = 'ALT' -- to not conflict with Windows key shortcuts
   mod.SUPER_REV = 'ALT|CTRL'
end

local act = wezterm.action
config.leader = { key = 'Space', mods = mod.SUPER_REV, timeout_milliseconds = 1000 }
config.keys = {
  { key = 'q',          mods = 'LEADER',         action = act.QuitApplication },
  { key = 'F11',        mods = 'NONE',           action = act.ToggleFullScreen },
  { key = 'h',          mods = mod.SUPER,        action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'v',          mods = mod.SUPER,        action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'q',          mods = mod.SUPER,        action = act.CloseCurrentPane { confirm = false } },
  { key = 'LeftArrow',  mods = 'SHIFT|CTRL',     action = act.ActivatePaneDirection 'Left' },
  { key = 'RightArrow', mods = 'SHIFT|CTRL',     action = act.ActivatePaneDirection 'Right' },
  { key = 'UpArrow',    mods = 'SHIFT|CTRL',     action = act.ActivatePaneDirection 'Up' },
  { key = 'DownArrow',  mods = 'SHIFT|CTRL',     action = act.ActivatePaneDirection 'Down' },
  { key = '[',          mods = mod.SUPER,        action = act.ActivateTabRelative(-1) },
  { key = ']',          mods = mod.SUPER,        action = act.ActivateTabRelative(1) },
  { key = '[',          mods = mod.SUPER_REV,    action = act.MoveTabRelative(-1) },
  { key = ']',          mods = mod.SUPER_REV,    action = act.MoveTabRelative(1) },
  -- CTRL+SHIFT+T to create new Tab.
  { key = 't',          mods = 'CTRL|SHIFT',     action = act.SpawnTab 'DefaultDomain' },
  -- CTRL+SHIFT+W to close current Tab.
  { key = 'w',          mods = 'CTRL|SHIFT',     action = act.CloseCurrentTab { confirm = false } },
  -- CTRL+SHIFT+N to create new window.
  { key = 'n',          mods = 'SHIFT|CTRL',     action = act.SpawnWindow },
}

-- Quickly jump between tabs
for i = 1, 8 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = mod.SUPER,
    action = act.ActivateTab(i - 1),
  })
end

-------------------- mouse actions --------------------
config.mouse_bindings = {
  -- copy the selection
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = mod.SUPER,
    action = act.CompleteSelection 'ClipboardAndPrimarySelection',
  },

  -- Open HyperLink
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = act.OpenLinkAtMouseCursor,
  },
}

-- and finally, return the configuration to wezterm
return config
