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

-- Keep the familiar gryphons first, then list the remaining options alphabetically.
local gryphons = {
  {name = "Gryphon2", path = "gryphonnew"},
  {name = "Lion2", path = "lionnew"},
  {name = "Crest", path = "crest"},
  {name = "Demon", path = "demon"},
  {name = "Diablo 1", path = "diablo1"},
  {name = "Diablo 2", path = "diablo2"},
  {name = "Diablo 3", path = "diablo3"},
  {name = "Diablo 4", path = "diablo4"},
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
  {name = "Winged Lion", path = "wingedlion"},
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

local moverNames = {
  left = "pfUICustomMediaGryphonLeft",
  right = "pfUICustomMediaGryphonRight",
}

local function HasSavedMoverPosition(name)
  local positions = pfUI_config and pfUI_config.position
  return type(positions) == "table" and type(positions[name]) == "table" and positions[name].xpos ~= nil
end

local function CopyFramePosition(source, target)
  local point, relative, relativePoint, x, y = source:GetPoint()
  target:ClearAllPoints()
  local relativeIsTarget = relative == target or relative == target:GetName() or
    (relative and type(relative) ~= "string" and type(relative) ~= "number" and
      type(relative.GetName) == "function" and relative:GetName() == target:GetName())
  if point and relative and not relativeIsTarget and relative ~= source then
    target:SetPoint(point, relative, relativePoint or point, x or 0, y or 0)
  elseif point then
    -- A gryphon anchor can resolve to this named mover after a reload or
    -- another addon has already reparented the frame. Never create a cycle.
    target:SetPoint(point, UIParent, relativePoint or point, x or 0, y or 0)
  else
    target:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
  end
end

local function InstallMovableGryphons()
  if type(pfUI.gryphons) ~= "table" or type(pfUI.gryphons.frames) ~= "table" then return end
  if type(pfUI.gryphons.UpdateConfig) ~= "function" or type(pfUI.api) ~= "table" or type(pfUI.api.UpdateMovable) ~= "function" then return end
  if pfUI.gryphons.customMediaMoversInstalled then return end

  local originalUpdate = pfUI.gryphons.UpdateConfig
  local movers = {}
  pfUI.gryphons.customMediaMovers = movers
  pfUI.gryphons.customMediaMoversInstalled = true

  local function UpdateMovers()
    -- The core gryphon updater uses SetPoint without clearing prior anchors.
    -- Remove the child-to-mover anchor first so it cannot be mistaken for
    -- pfUI's configured default anchor when resetting or changing settings.
    for _, frame in pairs(pfUI.gryphons.frames) do
      if frame then frame:ClearAllPoints() end
    end
    originalUpdate()
    for position, name in pairs(moverNames) do
      local frame = pfUI.gryphons.frames[position]
      if frame then
        local mover = movers[position]
        if not mover then
          mover = CreateFrame("Frame", name, UIParent)
          mover:SetFrameStrata("MEDIUM")
          CopyFramePosition(frame, mover)
          pfUI.api.UpdateMovable(mover, true)
          movers[position] = mover
        elseif not HasSavedMoverPosition(name) then
          CopyFramePosition(frame, mover)
        end

        mover:SetWidth(frame:GetWidth())
        mover:SetHeight(frame:GetHeight())
        local point = frame:GetPoint()
        point = point or "CENTER"
        frame:SetParent(mover)
        frame:SetFrameStrata("HIGH")
        frame:SetFrameLevel(mover:GetFrameLevel() + 1)
        frame:ClearAllPoints()
        frame:SetPoint(point, mover, point, 0, 0)
      end
    end
  end

  pfUI.gryphons.UpdateConfig = UpdateMovers
  UpdateMovers()
end

local function ResetGryphonPosition()
  local positions = pfUI_config and pfUI_config.position
  if type(positions) == "table" then
    for _, name in pairs(moverNames) do positions[name] = nil end
  end
  if type(C.position) == "table" then
    for _, name in pairs(moverNames) do C.position[name] = nil end
  end
  local movers = pfUI.gryphons and pfUI.gryphons.customMediaMovers
  if type(movers) == "table" then
    for _, mover in pairs(movers) do
      if mover then mover:SetScale(1) end
    end
  end

  if type(pfUI.gryphons.UpdateConfig) == "function" then
    pfUI.gryphons.UpdateConfig()
  end
end

local function ResetGryphonDefaults()
  if not C or type(C.bars) ~= "table" or type(C.bars.gryphons) ~= "table" then return end

  local config = C.bars.gryphons
  config.texture = "Gryphon"
  config.color = ".6,.6,.6,1"
  config.size = "64"
  config.anchor_left = "pfActionBarLeft"
  config.anchor_right = "pfActionBarRight"
  config.offset_h = "-48"
  config.offset_v = "-4"

  ResetGryphonPosition()
end

if type(pfUI.GetEnvironment) == "function" then
  setfenv(ResetGryphonPosition, pfUI:GetEnvironment())
  setfenv(ResetGryphonDefaults, pfUI:GetEnvironment())
end
pfUI.customMedia = pfUI.customMedia or {}
pfUI.customMedia.ResetGryphonDefaults = ResetGryphonDefaults

local function InitializeCustomGryphons()
  AddCustomGryphons()
  InstallMovableGryphons()
end

-- Hook into pfUI's module registration system
if type(pfUI.RegisterModule) == "function" then
  pfUI:RegisterModule("custom-gryphons", "vanilla:tbc", function()
    InitializeCustomGryphons()
  end)
else
  -- Fallback: try to add immediately and on events
  InitializeCustomGryphons()
  
  local frame = CreateFrame("Frame")
  frame:RegisterEvent("ADDON_LOADED")
  frame:SetScript("OnEvent", function()
    if event == "ADDON_LOADED" and arg1 == "pfUI" then
      InitializeCustomGryphons()
      this:UnregisterEvent("ADDON_LOADED")
    end
  end)
end

