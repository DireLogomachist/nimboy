import jscanvas except Path

import transform
from draw import Drawable, SpriteDrawable, draw
import collision


type
    GameObject* = ref object of TransformObject
        id*: int
        sprite*: Drawable
        enabled*: bool = true
        dead*: bool = false

        colliders*: seq[Collider]
        onCollisionCooldown*: bool = false
        collisionCooldown*: float = 0.5f
        collisionTimer*: float = 0.0f

method update*(self: GameObject, deltatime: float) {.base.} = 
    discard

method onCollide*(self: GameObject) {.base.} = 
    discard

proc draw*(self: GameObject, context: CanvasContext) = 
    if self.sprite != nil:
        self.sprite.draw(context)

    for collider in self.colliders:
        if collider.drawOutline:
            collider.draw(context)

proc updateCollisionTimer*(self: GameObject, deltatime: float) = 
    if self.onCollisionCooldown:
        self.collisionTimer -= deltatime/1000
        if self.collisionTimer < 0.0f:
            self.collisionTimer = 0.0f
            self.onCollisionCooldown = false

proc addCollider*(self: GameObject, collider: Collider) = 
    collider.parent = self
    self.colliders.add(collider)

proc checkCollisions*(self: GameObject, target: GameObject): bool =
    for collider in self.colliders:
        for targetCollider in target.colliders:
            if collider.collisionCheck(targetCollider):
                target.onCollide()
                self.onCollide()
                return true
    return false
