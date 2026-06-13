import tables
from dom import ImageElement


var assetCache*: Table[string, ImageElement]

var assetList*: seq[string] = @[
    "src/assets/plummet_player.png",
    "src/assets/diver.png",
    "src/assets/gridbomb.png",
]
