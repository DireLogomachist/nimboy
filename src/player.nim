import tables
from dom import ImageElement
import jscanvas except Path

from gameobj import GameObject, addCollider
from collision import ColliderBox, ColliderCircle, draw
from draw import Drawable, SpriteDrawable, load, draw
import transform


type
    Player* = ref object of GameObject
        speed*: float = 0.2

proc newPlayer*(): Player = 
    var player = Player()
    player.id = 0
    player.loc.x = 78
    player.loc.y = 78
    player.sprite = SpriteDrawable()
    player.sprite.parent = player
    
    var col: ColliderBox = ColliderBox(size:(w:25, h:25))
    col.drawOutline = true
    player.addCollider(col)
    return player

method draw*(self: Player, context: CanvasContext, assetCache: Table[string, ImageElement]) = 
    if self.sprite.loaded != true:
        self.sprite.load(assetCache)
    self.sprite.draw(context)

    for collider in self.colliders:
        if collider.drawOutline:
            collider.draw(context)
