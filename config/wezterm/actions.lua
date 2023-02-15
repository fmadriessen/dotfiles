local actions = {}

---Close all other panes in the current tab
function actions.close_other_panes(window, pane)
   local wezterm = require("wezterm")

   local tab = pane:tab()
   local panes = tab:panes_with_info()

   for _, p in pairs(panes) do
      if p.pane:pane_id() ~= pane:pane_id() then
         window:perform_action(wezterm.action.ActivatePaneByIndex(p.index), p.pane)
         window:perform_action(wezterm.action.CloseCurrentPane({ confirm = false }), p.pane)
      end
   end
end

return actions
