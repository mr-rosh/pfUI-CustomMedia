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

-- Ordered list of available gryphons for consistent dropdown ordering
local gryphons = {
  {name = "Demon", path = "demon"},
  {name = "Diablo 1", path = "diablo1"},
  {name = "Diablo 2", path = "diablo2"},
  {name = "Diablo 3", path = "diablo3"},
  {name = "Diablo 4", path = "diablo4"},
  {name = "Diablo 3 Crest", path = "diablo3crest"},
  {name = "Dragon", path = "dragon"},
  {name = "Gryphon 2", path = "gryphon2"},
  {name = "New Gryphon", path = "gryphonnew"},
  {name = "Lion 2", path = "lion2"},
  {name = "New Lion", path = "lionnew"},
  {name = "Winged Lion", path = "wingedlion"},
  {name = "Crest", path = "crest"},
  {name = "Dwarf", path = "dwarf"},
  {name = "Ghoul", path = "ghoul"},
  {name = "Gnome", path = "gnome"},
  {name = "Human", path = "human"},
  {name = "Murloc", path = "murloc"},
  {name = "Murloc 2", path = "murloc2"},
  {name = "Murloc 3", path = "murloc3"},
  {name = "Night Elf", path = "nightelf"},
  {name = "Orc", path = "orc"},
  {name = "Skull", path = "skull"},
  {name = "Squid", path = "SquidModDefault"},
  {name = "Tauren", path = "tauren"},
  {name = "Troll", path = "troll"},
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

