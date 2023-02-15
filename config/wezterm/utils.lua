local utils = {}
function utils.populate_ssh_hosts(domains)
   domains = domains or {}
   for host, _ in pairs(require("wezterm").enumerate_ssh_hosts()) do
      table.insert(domains, {
         name = host,
         remote_address = host,
      })
   end
   return domains
end

---Set font
---@param spec string|table
-- see https://wezfurlong.org/wezterm/config/font
-- see https://wezfurlong.org/wezterm/config/font-shaping
function utils.font(spec)
   return require("wezterm").font_with_fallback({
      spec,
      "Noto Color Emoji",
      "Symbols Nerd Font Mono",
   })
end

---@private
---@return boolean
local function is_dark_system_theme() return require("wezterm").gui.get_appearance():find("Dark") end

---@param dark string Colorscheme to be used when dark, or when it is the only colorscheme
---@param light? string Light colorscheme, optional
---@return string
function utils.set_color_scheme(dark, light)
   assert(type(dark) == "string", "Not a colorscheme")
   if not light then return dark end

   return is_dark_system_theme() and dark or light
end

function utils.convert_to_keys(keys)
   for i, map in pairs(keys) do
      keys[i] = { mods = map[1], key = map[2], action = map[3] }
   end

   return keys
end

---@param specs table[] specification list in the following order mods, streak, button, direction, action
function utils.convert_to_mouse(specs)
   for i, map in pairs(specs) do
      specs[i] = {
         mods = map[1],
         event = {
            [map[4]] = {
               streak = map[2],
               button = map[3],
            },
         },
         action = map[5],
      }
   end
end

return utils
