-- WezTerm configuration file

local wezterm = require 'wezterm'
local config = wezterm.config_builder()


config.initial_cols = 100
config.initial_rows = 45

-- or, changing the font size and color scheme.
config.font = wezterm.font_with_fallback {
    'JetBrainsMono NF',
    'FiraCode Nerd Font',
    'Hack Nerd Font Mono'
}
config.font_size = 12
config.color_scheme = 'Dracula (Official)'

return config
