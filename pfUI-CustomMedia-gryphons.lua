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

if not pfUI.gui.dropdowns.gryphons then pfUI.gui.dropdowns.gryphons = {} end

-- Ordered list of gryphons for consistent dropdown ordering
local gryphons = {
  {name = "Demon", path = "demon"},
  {name = "Diablo 1", path = "diablo1"},
  {name = "Diablo 2", path = "diablo2"},
  {name = "Diablo 3", path = "diablo3"},
  {name = "Diablo 4", path = "diablo4"},
  {name = "Dragon", path = "dragon"},
  {name = "New Gryphon", path = "gryphonnew"},
  {name = "New Lion", path = "lionnew"},
  {name = "Winged Lion", path = "wingedlion"},
}

-- Function to add custom textures
local function AddCustomGryphons()
  if pfUI and pfUI.gryphons and pfUI.gryphons.textures then
    for i, gryphon in ipairs(gryphons) do
      local fullpath = string.format("%s\\gryphons\\%s.tga", addonpath, gryphon.path)
      pfUI.gryphons.textures[gryphon.name] = fullpath
      table.insert(pfUI.gui.dropdowns.gryphons, string.format("%s:%s", gryphon.name, gryphon.name))
    end
    -- Force update the gryphons if they're already configured
    if pfUI.gryphons.UpdateConfig then
      pfUI.gryphons.UpdateConfig()
    end
  end
end

-- Hook into pfUI's module registration system
if pfUI and pfUI.RegisterModule then
  pfUI:RegisterModule("custom-gryphons", "vanilla:tbc", function()
    AddCustomGryphons()
  end)
else
  -- Fallback: try to add immediately and on events
  AddCustomGryphons()
  
  local frame = CreateFrame("Frame")
  frame:RegisterEvent("ADDON_LOADED")
  frame:SetScript("OnEvent", function(self, event, addonName)
    if addonName == "pfUI" then
      AddCustomGryphons()
    end
  end)
end

