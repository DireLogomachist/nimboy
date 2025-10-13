import jscanvas except Path

import transform
from draw import Drawable, SpriteDrawable, draw
import collision


type
    GameObject* = ref object of TransformObject
        sprite*: Drawable
        colliders*: seq[Collider]
        onCollide*: proc()

proc update*(self: GameObject) = 
    discard

proc draw*(self: GameObject, context: CanvasContext) = 
    if self.sprite != nil:
        self.sprite.draw(context)

    for collider in self.colliders:
        if collider.drawOutline:
            collider.draw(context)

proc addCollider*(self: GameObject, collider: Collider) = 
    collider.parent = self
    self.colliders.add(collider)
