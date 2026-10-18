# pfUI-CustomMedia

<img src="https://i.imgur.com/CuRkjdU.jpeg" width="512">

**pfUI-CustomMedia** is a lightweight plugin for [pfUI](https://github.com/shagu/pfUI). It adds custom textures for unitframes, castbars, experience bars, action buttons, and gryphons, along with additional fonts and button backgrounds.

## Installation (Vanilla, 1.12)

1. Download the [latest version](https://github.com/mr-rosh/pfUI-CustomMedia/archive/master.zip).
2. Unpack the archive and rename `pfUI-CustomMedia-master` to `pfUI-CustomMedia`.
3. Copy the folder into `Wow-Directory/Interface/AddOns`.
4. Restart WoW.

## Installation (The Burning Crusade, 2.4.3)

1. Download the [latest version](https://github.com/mr-rosh/pfUI-CustomMedia/archive/master.zip).
2. Unpack the archive and rename `pfUI-CustomMedia-master` to `pfUI-CustomMedia-tbc`.
3. Copy the folder into `Wow-Directory/Interface/AddOns`.
4. Restart WoW.

## OctoWoW pfUI No Anchor fix

pfUI loads its gryphon module before this addon. Its built-in **No Anchor** value can therefore crash on startup before CustomMedia can handle it. When using **No Anchor**, apply [the pfUI patch](patches/pfUI-no-anchor.patch) to `Interface/AddOns/pfUI/modules/gryphons.lua`.

## Changelog

### 2.3.8 (2026-10-18)

- Fix gryphon positioning, dragging, and anchor handling.
- Add a position reset option that preserves gryphon appearance and anchor settings.
- Clean up gryphon texture options and dropdown behavior.
- Simplify gryphon reset controls and improve their layout.

### 2.2.0 (2026-10-17)

- Remove menu entries for the missing Karla font and Sword button background.
- Apply custom backgrounds to pfUI buttons even when they are hidden.
- Guard optional pfUI menus and GUI methods against Lua errors.
- Prevent duplicate gryphon entries and keep font menu ordering stable.