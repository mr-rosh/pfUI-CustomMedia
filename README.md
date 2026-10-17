# pfUI-CustomMedia

<img src="https://i.imgur.com/CuRkjdU.jpeg" width="512">

**pfUI-CustomMedia** is a lightweight plugin for [pfUI](https://github.com/shagu/pfUI). Provides a selection of custom textures to be used on your unitframes, castbar, xpbar, etc. New fonts, new button backgrounds, new gryphons.

## Installation (Vanilla, 1.12)
1. Download **[Latest Version](https://github.com/mr-rosh/pfUI-CustomMedia/archive/master.zip)**
2. Unpack the Zip file
3. Rename the folder "pfUI-CustomMedia-master" to "pfUI-CustomMedia"
4. Copy "pfUI-CustomMedia" into Wow-Directory\Interface\AddOns
5. Restart Wow

## Installation (The Burning Crusade, 2.4.3)
1. Download **[Latest Version](https://github.com/mr-rosh/pfUI-CustomMedia/archive/master.zip)**
2. Unpack the Zip file
3. Rename the folder "pfUI-CustomMedia-master" to "pfUI-CustomMedia-tbc"
4. Copy "pfUI-CustomMedia-tbc" into Wow-Directory\Interface\AddOns
5. Restart Wow

## Changelog

### 2.3.7 (2026-10-18)
- Remove Dragon, Diablo 3 Crest, Gryphon 2, and Lion 2 textures from the dropdown; rename the New variants and alphabetize the remaining options.

### 2.3.6 (2026-10-18)
- Replace the separate gryphon reset controls with one Reset gryphons button that restores fresh-install settings.

### 2.3.5 (2026-10-18)

### 2.3.4 (2026-10-18)

### 2.3.3 (2026-10-18)
- Give the gryphon reset control its own section heading and a concise "Reset position" button label.

### 2.3.2 (2026-10-18)
- Reset gryphons to the active pfUI anchors and offsets instead of overriding the profile with global defaults.

### 2.3.1 (2026-10-18)
- Add a button to reset gryphons to their configured pfUI position and size in Thirdparty > CustomMedia.
- Allow both gryphons to be repositioned with pfUI's Unlock Mode and save their positions.

### 2.3.0 (2026-10-17)
### 2.2.0 (2026-10-17)
- Removed menu entries for the missing Karla font and Sword button background.
- Apply custom backgrounds to pfUI buttons even when they are currently hidden.
- Guard optional pfUI menus and GUI methods so missing interfaces do not cause Lua errors.
- Prevent duplicate gryphon entries and keep font menu ordering stable.
