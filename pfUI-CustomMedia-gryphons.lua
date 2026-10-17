if not pfUI then return end

local addonpath
local tocs = { "", "-master", "-tbc", "-wotlk" }
for _, name in ipairs(tocs) do
  local current = string.format("pfUI-CustomMedia%s", name)
  local _, title = GetAddOnInfo(current)
  if title then
    addonpath = "Interface\\AddOns\\" .. current
    break
  end
end

if type(pfUI.gui) == "table" and type(pfUI.gui.dropdowns) == "table" and type(pfUI.gui.dropdowns.gryphons) ~= "table" then
  pfUI.gui.dropdowns.gryphons = {}
end

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
  if not addonpath or type(pfUI.gryphons) ~= "table" or type(pfUI.gryphons.textures) ~= "table" then return end
  if type(pfUI.gui) ~= "table" or type(pfUI.gui.dropdowns) ~= "table" then return end
  if type(pfUI.gui.dropdowns.gryphons) ~= "table" then pfUI.gui.dropdowns.gryphons = {} end
  local dropdown = pfUI.gui.dropdowns.gryphons

  for _, gryphon in ipairs(gryphons) do
    local fullpath = string.format("%s\\gryphons\\%s.tga", addonpath, gryphon.path)
    pfUI.gryphons.textures[gryphon.name] = fullpath
    local option = string.format("%s:%s", gryphon.name, gryphon.name)
    local exists = false
    for _, entry in ipairs(dropdown) do
      if entry == option then
        exists = true
        break
      end
    end
    if not exists then table.insert(dropdown, option) end
  end
  -- Force update the gryphons if they're already configured
  if type(pfUI.gryphons.UpdateConfig) == "function" then
    pfUI.gryphons.UpdateConfig()
  end
end

-- Hook into pfUI's module registration system
if type(pfUI.RegisterModule) == "function" then
  pfUI:RegisterModule("custom-gryphons", "vanilla:tbc", function()
    AddCustomGryphons()
  end)
else
  -- Fallback: try to add immediately and on events
  AddCustomGryphons()
  
  local frame = CreateFrame("Frame")
  frame:RegisterEvent("ADDON_LOADED")
  frame:SetScript("OnEvent", function()
    if event == "ADDON_LOADED" and arg1 == "pfUI" then
      AddCustomGryphons()
      this:UnregisterEvent("ADDON_LOADED")
    end
  end)
end

