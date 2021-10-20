#  Laka

A set of CLI tools for extracting/exporting/converting orignal game resources from *Heroes of Might and Magic III Complete* (HoMM3) needed to play the Swift rewrite of the game named [Tritium](https://github.com/Sajjon/Tritium)

## Run

> ❗️You MUST have access to the game resources of the original game.

Place the original game resources in a directory, maybe `~/Library/Application Support/Tritium/Original`. Lets refer to this directory as `inputPath`. In this directory, place the two original directories:
* Maps
* Data

The "Maps" directory SHOULD contain the original `*.h3m` map files that will be converted to `*.json` format.

The "Data" directory MUST contain these files:
* H3ab_ahd.snd  
* H3ab_ahd.vid  
* H3ab_bmp.lod  
* H3ab_spr.lod  
* H3bitmap.lod  
* H3sprite.lod  
* Heroes3.snd  
* VIDEO.VID  

### Help
```sh
swift run Laka --help
```

### All
```sh
swift run all -i <inputPath> -o <outputPath> -l info
```

For example:
```sh
swift run all -i ~/Library/Application\ Support/Tritium/Original -o ~/Library/Application\ Support/Tritium/Extracted
```

## Etymology
"Laka" means "Extract" in Swedish 🇸🇪

## Acknowledgments
This toolset is greatly inspiried by the amazing [HoMM3-map-viewer toolset](https://github.com/srg-kostyrko/hoom3-map-viewer/tree/master/scripts) (TypeScript).

## Copyright
All rights for the original game and its resources belong to former [The 3DO Company](https://en.wikipedia.org/wiki/The_3DO_Company). These rights were transferred to [Ubisoft](https://www.ubisoft.com/). We do not encourage and do not support any form of illegal usage of the original game. We strongly advise to purchase the original game on [Ubisoft Store](https://store.ubi.com/eu/game?pid=575ffd9ba3be1633568b4d8c) or [GOG](https://www.gog.com/game/heroes_of_might_and_magic_3_complete_edition).
