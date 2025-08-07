-- Pull in the wezterm API
local wezterm = require 'wezterm'
-- Create a new config object using config_builder
local config = wezterm.config_builder()

-- Appearance (optional)
config.font = wezterm.font "Cousine Nerd Font"
config.font_size = 14
config.color_scheme = "Dracula"
config.window_decorations = "RESIZE"
config.enable_tab_bar = true
-- config.hide_tab_bar_if_only_one_tab = true

-- === Background Transparency ===
config.window_background_opacity = 0.9
config.inactive_pane_hsb = {
  saturation = 1.0,
  brightness = 0.5,
} -- This dims the background of inactive panes

-- Key bindings
config.keys = {
  -- Pane splitting
  { key = "v", mods = "ALT", action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" } },
  { key = "s", mods = "ALT", action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" } },

  -- Vim-like pane navigation
  { key = "h", mods = "ALT", action = wezterm.action.ActivatePaneDirection "Left" },
  { key = "j", mods = "ALT", action = wezterm.action.ActivatePaneDirection "Down" },
  { key = "k", mods = "ALT", action = wezterm.action.ActivatePaneDirection "Up" },
  { key = "l", mods = "ALT", action = wezterm.action.ActivatePaneDirection "Right" },

  -- Tab management
  { key = "T", mods = "ALT", action = wezterm.action.SpawnTab "CurrentPaneDomain" },
  { key = "p", mods = "ALT", action = wezterm.action.ActivateTabRelative(-1) },
  { key = "n", mods = "ALT", action = wezterm.action.ActivateTabRelative(1) },

  -- Workspace management
  { key = "1", mods = "ALT", action = wezterm.action.SwitchToWorkspace { name = "default" } },
  { key = "2", mods = "ALT", action = wezterm.action.SwitchToWorkspace { name = "2" } },
  { key = "3", mods = "ALT", action = wezterm.action.SwitchToWorkspace { name = "3" } },
  { key = "4", mods = "ALT", action = wezterm.action.SwitchToWorkspace { name = "4" } },
}

wezterm.on("update-right-status", function(window, _)
  local time = wezterm.strftime("%m/%d %H:%M")
  local workspace = window:active_workspace()
  window:set_right_status(wezterm.format {
    { Text = "    " .. workspace .. "   " },
    { Text = "  " .. time .. "  " },
  })
end)

-- Return the completed config
return config
