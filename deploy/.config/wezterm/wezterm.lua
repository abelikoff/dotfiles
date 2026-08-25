-- WezTerm configuration file

local wezterm = require 'wezterm'
local config = wezterm.config_builder()
config.enable_wayland = false

config.initial_cols = 100
config.initial_rows = 45

-- or, changing the font size and color scheme.
config.font = wezterm.font_with_fallback {
    'GeistMono Nerd Font',
    'Berkeley Mono',
    'JetBrainsMono NF',
    'FiraCode Nerd Font',
    'Hack Nerd Font Mono'
}
config.font_size = 11
config.color_scheme = 'Dracula (Official)'

local act = wezterm.action

config.mouse_bindings = {
  -- Disable default single-click opening links and make it select text instead
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = act.CompleteSelection 'ClipboardAndPrimarySelection',
  },
  -- Require holding CTRL and left-clicking to open the link at cursor
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = act.OpenLinkAtMouseCursor,
  },
}

return config
