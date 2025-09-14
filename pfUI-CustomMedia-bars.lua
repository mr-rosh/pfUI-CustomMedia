if not pfUI then return end

local addonpath
local tocs = { "", "-master", "-tbc", "-wotlk" }
for _, name in pairs(tocs) do
  local current = string.format("pfUI-CustomMedia%s", name)
  local _, title = GetAddOnInfo(current)
  if title then
    addonpath = "Interface\\AddOns\\" .. current
    break
  end
end

if addonpath then
  local barNames = {
    "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y"
  }
  for _, name in ipairs(barNames) do
    table.insert(pfUI.gui.dropdowns.uf_bartexture, string.format("%s\\statusbars\\pfUI-%s.tga:pfUI-%s", addonpath, name, name))
  end
end
