-- Add a bounded, scrollable viewport to pfUI's custom dropdown widget.
-- This lives in CustomMedia so the shared pfUI addon files stay untouched.
if not pfUI or type(pfUI.api) ~= "table" or type(pfUI.api.CreateDropDownButton) ~= "function" then return end

local originalCreateDropDownButton = pfUI.api.CreateDropDownButton
if pfUI.api.customMediaDropdownScrollable then return end

local ROW_HEIGHT = 20
local MENU_PADDING = 4
local MAX_VISIBLE_ROWS = 12
local SCROLLBAR_WIDTH = 6

local function SetupScrollableMenu(dropdown)
  if dropdown.customMediaScroll then return end

  local menu = dropdown.menuframe
  if not menu then return end

  local state = { offset = 0, count = 0 }
  dropdown.customMediaScroll = state

  local track = menu:CreateTexture(nil, "OVERLAY")
  track:SetTexture(0, 0, 0, .35)
  track:SetPoint("TOPRIGHT", menu, "TOPRIGHT", -3, -3)
  track:SetPoint("BOTTOMRIGHT", menu, "BOTTOMRIGHT", -3, 3)
  track:SetWidth(SCROLLBAR_WIDTH)
  track:Hide()

  local slider = CreateFrame("Slider", nil, menu)
  slider:SetOrientation("VERTICAL")
  slider:SetFrameStrata("FULLSCREEN")
  slider:SetFrameLevel(menu:GetFrameLevel() + 20)
  slider:SetPoint("TOPLEFT", track, "TOPLEFT", 0, 0)
  slider:SetPoint("BOTTOMRIGHT", track, "BOTTOMRIGHT", 0, 0)
  slider:SetMinMaxValues(0, 0)
  slider:SetValueStep(1)
  slider:SetThumbTexture(pfUI.media["img:col"])
  slider:SetWidth(SCROLLBAR_WIDTH)
  local thumb = slider:GetThumbTexture()
  if thumb then
    thumb:SetTexture(.3, 1, .8, .5)
    thumb:SetWidth(SCROLLBAR_WIDTH)
  end
  slider:Hide()
  state.slider = slider

  local function RefreshRows()
    local visibleRows = state.visibleRows or 0
    local itemRight = state.count > visibleRows and -(SCROLLBAR_WIDTH + 4) or -2

    for _, entry in pairs(menu.elements or {}) do
      local index = entry.id
      if index and index >= 1 and index <= state.count then
        entry:ClearAllPoints()
        entry:SetPoint("TOPLEFT", menu, "TOPLEFT", 2, -(index - state.offset - 1) * ROW_HEIGHT - 2)
        entry:SetPoint("TOPRIGHT", menu, "TOPRIGHT", itemRight, -(index - state.offset - 1) * ROW_HEIGHT - 2)
        entry:SetHeight(ROW_HEIGHT)
        if index > state.offset and index <= state.offset + visibleRows then
          entry:Show()
        else
          entry:Hide()
        end
      end
    end

    slider:SetValue(state.offset)
  end
  state.RefreshRows = RefreshRows

  slider:SetScript("OnValueChanged", function()
    state.offset = math.floor((this:GetValue() or 0) + .5)
    RefreshRows()
  end)

  menu:EnableMouseWheel(1)
  menu:SetScript("OnMouseWheel", function()
    -- arg1 is the wheel delta; capture it into a local (Classic 1.12-safe).
    local delta = arg1 or 0
    local maxOffset = math.max(0, state.count - (state.visibleRows or 0))
    state.offset = math.max(0, math.min(maxOffset, state.offset - delta))
    slider:SetValue(state.offset)
    RefreshRows()
  end)

  local originalShowMenu = dropdown.ShowMenu
  dropdown.ShowMenu = function(self)
    if type(originalShowMenu) ~= "function" then return end
    originalShowMenu(self)

    state.count = #(self.menu or {})
    state.visibleRows = math.min(state.count, MAX_VISIBLE_ROWS)
    state.offset = math.min(state.offset, math.max(0, state.count - state.visibleRows))

    -- Cache screen height once per open instead of querying every frame.
    local screenHeight = GetScreenHeight and GetScreenHeight() or 768
    local maxMenuHeight = math.max(ROW_HEIGHT + MENU_PADDING, screenHeight - 80)
    state.visibleRows = math.min(state.visibleRows, math.max(1, math.floor((maxMenuHeight - MENU_PADDING) / ROW_HEIGHT)))

    local visibleHeight = state.visibleRows * ROW_HEIGHT + MENU_PADDING
    self.menuframe:SetHeight(visibleHeight)
    state.slider:SetMinMaxValues(0, math.max(0, state.count - state.visibleRows))

    if state.count > state.visibleRows then
      track:Show()
      slider:Show()
      local thumb = slider:GetThumbTexture()
      if thumb then
        thumb:SetTexture(.3, 1, .8, .5)
        thumb:SetWidth(SCROLLBAR_WIDTH)
        thumb:SetHeight(math.max(18, visibleHeight * state.visibleRows / state.count))
      end
      state.offset = math.min(state.offset, math.max(0, state.count - state.visibleRows))
    else
      track:Hide()
      slider:Hide()
      state.offset = 0
    end

    -- Flip upward if opening below the control would run off the screen.
    local buttonBottom = self:GetBottom()
    local buttonTop = self:GetTop()
    if buttonBottom and buttonBottom < visibleHeight and buttonTop and buttonTop + visibleHeight < screenHeight then
      self.menuframe:ClearAllPoints()
      self.menuframe:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 2)
      self.menuframe:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, 2)
    else
      self.menuframe:ClearAllPoints()
      self.menuframe:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -2)
      self.menuframe:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, 2)
    end

    RefreshRows()
  end

  local originalUpdateMenu = dropdown.UpdateMenu
  dropdown.UpdateMenu = function(self)
    if type(originalUpdateMenu) ~= "function" then return end
    originalUpdateMenu(self)
    if self.menuframe:IsShown() then
      state.count = #(self.menu or {})
      state.visibleRows = math.min(state.count, MAX_VISIBLE_ROWS)
      state.offset = math.min(state.offset, math.max(0, state.count - state.visibleRows))
      self.menuframe:SetHeight(state.visibleRows * ROW_HEIGHT + MENU_PADDING)
      state.slider:SetMinMaxValues(0, math.max(0, state.count - state.visibleRows))
      if state.count > state.visibleRows then track:Show(); slider:Show() else track:Hide(); slider:Hide() end
      RefreshRows()
    end
  end
end

local function CreateScrollableDropDown(name, parent)
  local dropdown = originalCreateDropDownButton(name, parent)
  SetupScrollableMenu(dropdown)
  return dropdown
end

pfUI.api.CreateDropDownButton = CreateScrollableDropDown
pfUI.api.customMediaDropdownScrollable = true
-- pfUI exposes API functions in its environment for unqualified calls in modules.
if type(pfUI.env) == "table" then
  pfUI.env.CreateDropDownButton = CreateScrollableDropDown
end

-- pfUI builds its configuration window while its own addon is loading, before
-- this dependent addon is loaded. Retrofit those already-created dropdowns.
local function PatchExistingDropdowns(frame)
  if not frame then return end

  if type(frame.SetMenu) == "function" and type(frame.ShowMenu) == "function" and frame.menuframe then
    SetupScrollableMenu(frame)
  end

  local children = { frame:GetChildren() }
  for _, child in pairs(children) do
    PatchExistingDropdowns(child)
  end
end

if pfUI.gui then
  PatchExistingDropdowns(pfUI.gui)
end
