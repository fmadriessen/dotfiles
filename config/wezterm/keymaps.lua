local u = require("utils")
local a = require("actions")
local act = require("wezterm").action

-- see https://wezfurlong.org/wezterm/config/lua/keyassignment/index
-- see https://wezfurlong.org/wezterm/config/key-tables
return u.convert_to_keys({
   { "LEADER|CTRL", "a", act.SendString("\x01") },

   -- Panes
   { "LEADER", "s", act.SplitVertical({ domain = "CurrentPaneDomain" }) },
   { "LEADER", "v", act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
   { "LEADER", "n", act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
   { "LEADER", "h", act.ActivatePaneDirection("Left") },
   { "LEADER", "j", act.ActivatePaneDirection("Down") },
   { "LEADER", "k", act.ActivatePaneDirection("Up") },
   { "LEADER", "l", act.ActivatePaneDirection("Right") },
   { "LEADER", "c", act.CloseCurrentPane({ confirm = true }) },
   { "LEADER", "w", act.PaneSelect },
   { "LEADER", "o", require("wezterm").action_callback(a.close_other_panes) },

   -- Tabs
   { "LEADER", "t", act.SpawnTab("CurrentPaneDomain") },
   { "LEADER", "]", act.ActivateTabRelative(1) },
   { "LEADER", "[", act.ActivateTabRelative(-1) },
   { "LEADER", "1", act.ActivateTab(0) },
   { "LEADER", "2", act.ActivateTab(1) },
   { "LEADER", "3", act.ActivateTab(2) },
   { "LEADER", "4", act.ActivateTab(3) },
   { "LEADER", "5", act.ActivateTab(4) },
   { "LEADER", "6", act.ActivateTab(5) },
   { "LEADER", "7", act.ActivateTab(6) },
   { "LEADER", "8", act.ActivateTab(7) },
   { "LEADER", "9", act.ActivateTab(8) },
   { "LEADER", "0", act.ActivateTab(-1) },
   { "LEADER|SHIFT", "C", act.CloseCurrentTab({ confirm = true }) },
   { "CTRL|SHIFT", "c", act.CopyTo("Clipboard") },
   { "CTRL|SHIFT", "v", act.PasteFrom("Clipboard") },
   { "CTRL|SHIFT", "s", act.PasteFrom("PrimarySelection") },

   { "CTRL", "+", act.IncreaseFontSize },
   { "CTRL", "-", act.DecreaseFontSize },
   { "CTRL", "=", act.ResetFontSize },
   { "CTRL|SHIFT", "k", act.CharSelect({ copy_on_select = true, copy_to = "ClipboardAndPrimarySelection" }) },
})
