if not pfUI or type(pfUI.gui) ~= "table" or type(pfUI.gui.dropdowns) ~= "table" then return end

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
  if type(dropdown) == "table" then
    for _, font in ipairs(fonts) do
      table.insert(dropdown, string.format("%s\\fonts\\%s:%s", addonpath, font[1], font[2]))
    end
    -- Register the additional font files present in this addon.
    local extraFonts = [[
Accidental Presidency.ttf	Accidental Presidency
ActionMan.ttf	ActionMan
Aladin.ttf	Aladin
ALBAS___.ttf	ALBAS___
AnonymousPro-Regular.ttf	AnonymousPro-Regular
ArmWrestler.ttf	ArmWrestler
AtkinsonHyperlegibleNext-Regular.ttf	AtkinsonHyperlegibleNext-Regular
AugmentedNeo-Eorzean-Regular.ttf	AugmentedNeo-Eorzean-Regular
AugmentedNorvrandt-Regular.ttf	AugmentedNorvrandt-Regular
AugmentedPostulatedProto-Alphabet-Regular.ttf	AugmentedPostulatedProto-Alphabet-Regular
AvantGarde_LT_Book_Regular.ttf	AvantGarde_LT_Book_Regular
BAARS___.TTF	BAARS___
Bazooka.ttf	Bazooka
Beyond Wonderland.ttf	Beyond Wonderland
Blazed.ttf	Blazed
BorisBlackBloxx.ttf	BorisBlackBloxx
BorisBlackBloxxDirty.ttf	BorisBlackBloxxDirty
Cabin-Regular.ttf	Cabin-Regular
CelestiaMediumRedux1.55.ttf	CelestiaMediumRedux1.55
centurygothic.ttf	centurygothic
COLLEGIA.ttf	COLLEGIA
ContinuumMedium.ttf	ContinuumMedium
coolinbi.ttf	coolinbi
DejaVuSans-Bold.ttf	DejaVuSans-Bold
DejaVuSans.ttf	DejaVuSans
Demon Stars.ttf	Demon Stars
DieDieDie.ttf	DieDieDie
DIOGENES.ttf	DIOGENES
Disko.ttf	Disko
expressway rg.otf	expressway rg
Expressway-Bold.ttf	Expressway-Bold
FiraSans-Regular.ttf	FiraSans-Regular
FRAKS___.ttf	FRAKS___
Gemini.ttf	Gemini
GothamNarrow-Ultra.ttf	GothamNarrow-Ultra
Homespun.ttf	Homespun
impact.ttf	impact
JetBrainsMono-Regular.ttf	JetBrainsMono-Regular
Lexend-Regular.ttf	Lexend-Regular
LiberationSans-Regular.ttf	LiberationSans-Regular
LiberationSerif-Regular.ttf	LiberationSerif-Regular
Medusa Gothic.otf	Medusa Gothic
MystikOrbs.ttf	MystikOrbs
NanumGothic-Regular.ttf	NanumGothic-Regular
NeonSky-Stencil-Rg.ttf	NeonSky-Stencil-Rg
Nunito-Regular.ttf	Nunito-Regular
OpenDyslexic3-Regular.ttf	OpenDyslexic3-Regular
Owbeirak Serif.otf	Owbeirak Serif
Pokemon Solid.ttf	Pokemon Solid
Poppins-Regular.ttf	Poppins-Regular
Prototype.ttf	Prototype
PTSansNarrow-Bold.ttf	PTSansNarrow-Bold
Rock Show Whiplash.ttf	Rock Show Whiplash
SF Diego Sans.ttf	SF Diego Sans
Solange.ttf	Solange
starcine.ttf	starcine
Starlight Rune.ttf	Starlight Rune
trashco.ttf	trashco
Ubuntu-C.ttf	Ubuntu-C
Ubuntu-L.ttf	Ubuntu-L
Verdana.ttf	Verdana
waltographUI.ttf	waltographUI
X360.ttf	X360
YanoneKaffeesatz-Regular.ttf	YanoneKaffeesatz-Regular
    ]]
    for entry in string.gfind(extraFonts, "[^\n]+") do
      entry = string.gsub(entry, "\r", "")
      local separator = string.find(entry, "\t", 1, true)
      if separator then
        local filename = string.sub(entry, 1, separator - 1)
        local label = string.sub(entry, separator + 1)
        table.insert(dropdown, string.format("%s\\fonts\\%s:%s", addonpath, filename, label))
      end
    end
  end
end
