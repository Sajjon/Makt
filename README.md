# HoMM3 
This is an open source implementation of classic game Heroes Of Might and Magic III (HoMM3) Complete in Swift.

# H3M Map File structure
Do check out [H3M.md](H3M.md) for map file structure.

## Gotchas
A tile might contain multiple objects! E.g. a Hero has a box of 3x2 and in the same origininating tile (lower left tile) of that 3x2 box, there might be another object, e.g. a resource. This is seen on tile `(x: 25, y: 65)` on vanilla RoE map "Race for Ardintinny.h3m".