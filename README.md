# ⚔️ Makt 🛡
This is an open source implementation of classic game *Heroes of Might and Magic III Complete* (HoMM3) "backend" (fully functional (well work in progress) game engine, without graphics) in pure Swift.

# Etymology
"Makt" means "Might" in Swedish 🇸🇪

# Packages

## Util 🛠
Unintersting utility code stuff.

## Malm 🪨
Contains all shared game models such as `Hero`, `Creature`, `Spell`, `Artifact` etc, but no logic at all.

## H3M 🗺
HoMM3 map file - `.h3m` - parser.

### H3M Map File structure
Do check out [H3M.md](H3M.md) for map file structure.

#### Gotchas
A tile might contain multiple objects, in fact more than two! E.g. a Hero has a box of 3x2 and in the same origininating tile (lower left tile) of that 3x2 box, there might be another object, e.g. a resource. This is seen on tile `(x: 25, y: 65)` on vanilla RoE map "Race for Ardintinny.h3m". Or on map "Rebellion" at `(x: 52, y: 57)` there is a `mountain`, `rock` and `crystalCavern`.

## Makt ⚔️
The game engine.
