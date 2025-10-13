import tables
from dom import ImageElement
import jscanvas except Path

from gameobj import GameObject
from draw import Drawable, SpriteDrawable, load, draw


type
    Player* = ref object of GameObject
        speed*: float = 0.2

proc newPlayer*(): Player = 
    var player = Player()
    player.loc.x = 78
    player.loc.y = 78
    player.sprite = SpriteDrawable()
    player.sprite.parent = player
    return player

method draw*(self: Player, context: CanvasContext, assetCache: Table[string, ImageElement]) = 
    if self.sprite.loaded != true:
        self.sprite.load(assetCache)
    self.sprite.draw(context)
