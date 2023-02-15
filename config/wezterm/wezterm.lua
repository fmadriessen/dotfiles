local wezterm = require("wezterm")
local u = require("utils")

local config = {
   color_scheme = u.set_color_scheme("tokyonight_moon", "tokyonight_day"),
   font = u.font("JetBrains Mono"),
   font_size = 12.0,
   leader = { mods = "CTRL", key = "a", timeout_milliseconds = 1000 },
   set_environment_variables = {},
   term = "wezterm",
   check_for_updates = false,
   force_reverse_video_cursor = false,
   tab_bar_at_bottom = true,
   tab_max_width = 50,
   use_fancy_tab_bar = false,
   hide_tab_bar_if_only_one_tab = true,
   ssh_domains = u.populate_ssh_hosts(),
   window_padding = { left = 5, top = 0, bottom = 0, right = 5 },
   hyperlink_rules = {
      -- see https://wezfurlong.org/wezterm/hyperlinks.html
      -- Linkify things that look like URLs and the host has a TLD name.
      { regex = "\\b\\w+://[\\w.-]+\\.[a-z]{2,15}\\S*\\b", format = "$0" },
      -- linkify email addresses
      { regex = [[\b\w+@[\w-]+(\.[\w-]+)+\b]], format = "mailto:$0" },
      -- file:// URI
      { regex = [[\bfile://\S*\b]], format = "$0" },
      -- Linkify things that look like URLs with numeric addresses as hosts.
      -- E.g. http://127.0.0.1:8000 for a local development server,
      -- or http://192.168.1.1 for the web interface of many routers.
      { regex = [[\b\w+://(?:[\d]{1,3}\.){3}[\d]{1,3}\S*\b]], format = "$0" },
      -- Make task numbers clickable
      -- The first matched regex group is captured in $1.
      { regex = [[\b[tT](\d+)\b]], format = "https://example.com/tasks/?t=$1" },
      -- Make username/project paths clickable. This implies paths like the following are for GitHub.
      -- ( "nvim-treesitter/nvim-treesitter" | wbthomason/packer.nvim | wez/wezterm | "wez/wezterm.git" )
      -- As long as a full URL hyperlink regex exists above this it should not match a full URL to
      -- GitHub or GitLab / BitBucket (i.e. https://gitlab.com/user/project.git is still a whole clickable URL)
      { regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]], format = "https://www.github.com/$1/$3" },
   },
   keys = require("keymaps"),
}

wezterm.on("format-tab-title", function(tab)
   -- see https://wezfurlong.org/wezterm/config/lua/window-events/format-tab-title.html
   return {
      { Attribute = { Intensity = "Half" } },
      { Text = string.format(" %s ", tab.tab_index + 1) },
      "ResetAttributes",
      { Text = tab.active_pane.title },
      { Text = "▕" },
   }
end)

return config
