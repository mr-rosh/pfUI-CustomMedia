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
  local fonts = {
    { "Acme-Regular.ttf", "Acme" },
    { "AtkinsonHyperlegible-Regular.ttf", "AtkinsonHyperlegible" },
    { "Alegreya-Medium.ttf", "Alegreya" },
    { "AlegreyaSansSC-Bold.ttf", "AlegreyaSansSC" },
    { "Bangers-Regular.ttf", "Bangers" },
    { "BarlowCondensed-Medium.ttf", "BarlowCondensed" },
    { "Cinzel-Regular.ttf", "Cinzel" },
    { "EBGaramond-Regular.ttf", "EBGaramond" },
    { "FjallaOne-Regular.ttf", "FjallaOne" },
    { "FTY.ttf", "FTY" },
    { "im-fell-english-sc.ttf", "IMFellSC" },
    { "Karla-Regular.ttf", "Karla" },
    { "Kingthings Foundation.ttf", "Kingthings" },
    { "LibreBaskerville-Regular.ttf", "LibreBaskerville" },
    { "Marcellus-Regular.ttf", "Marcellus" },
    { "MarcellusSC-Regular.ttf", "MarcellusSC" },
    { "PathwayGothicOne-Regular.ttf", "PathwayGothicOne" },
    { "RoadRage-Regular.ttf", "RoadRage" },
    { "US101.ttf", "US101" },
    { "AveriaLibre-Regular.ttf", "AveriaLibre" },
    { "BubblegumSans-Regular.ttf", "BubblegumSans" },
    { "Grandstander-Regular.ttf", "Grandstander" },
    { "Pangolin-Regular.ttf", "Pangolin" },
    { "itcquorum_bold.ttf", "ITCQuorum" },
    { "NiceDamage.ttf", "NiceDamage" }
  }
  
  local dropdown = pfUI.gui.dropdowns.fonts
  for _, font in pairs(fonts) do
    table.insert(dropdown, string.format("%s\\fonts\\%s:%s", addonpath, font[1], font[2]))
  end
end