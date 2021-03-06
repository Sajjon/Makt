# βοΈ Makt π‘
This is an open source implementation of classic game *Heroes of Might and Magic III Complete* (HoMM3) "backend" (fully functional (well work in progress) game engine, without graphics) in pure Swift.

# Etymology
"Makt" means "Might" in Swedish πΈπͺ

# Packages

## Package *Common* π 
Unintersting shared utility code stuff.

## Package *Decompressor* π
GZip decompressor package.

## Package *Malm* πͺ¨
Contains all shared game models such as `Hero`, `Creature`, `Spell`, `Artifact` etc, but no logic at all.

### Etymology
"Malm" means "Ore" in Swedish πΈπͺ

## Package *Guld* πͺ¨
Parser of HoMM3 asset files/archives: `.lod`, `.def`, `.pcx`

### Etymology
"Guld" means "Gold" in Swedish πΈπͺ

## Package *Video* π½
Conversion of `.bik` and `.smk` movie files into `.mov`

### Noteable dependency
This package uses [`SwiftFFmpeg`](https://github.com/sunlubo/SwiftFFmpeg) which requires [FFmpeg](http://ffmpeg.org/) (Requires FFmpeg 4.0 or higher). on macOS, you can:

```sh
brew install ffmpeg
```

## Package *H3M* πΊ
HoMM3 map file - `.h3m` - parser.

### H3M Map File structure
Do check out [H3M.md](H3M.md) for map file structure.

#### Gotchas
A tile might contain multiple objects, in fact more than two! E.g. a Hero has a box of 3x2 and in the same origininating tile (lower left tile) of that 3x2 box, there might be another object, e.g. a resource. This is seen on tile `(x: 25, y: 65)` on vanilla RoE map "Race for Ardintinny.h3m". Or on map "Rebellion" at `(x: 52, y: 57)` there is a `mountain`, `rock` and `crystalCavern`.

## Package *H3C* π
HoMM3 campaign file - `.h3c` - parser.

## Package *Laka*
A CLI toolset for extraction of game resources. 

See [README](Sources/Laka/README.md).

### Etymology
"Laka" means "Extract" in Swedish πΈπͺ

## Package *Packa* π¦
Binary tree packing algorithm used by *Laka*, to fit as many images in an as small square as possible.

See [README](Sources/Packa/README.md).


## Package *Makt* βοΈ
The game engine.
