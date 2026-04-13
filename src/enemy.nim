import gameobj
import draw
import collision
import math

## Base Enemy

type
    Enemy* = ref object of GameObject
        health*: int = 1

proc newEnemy*(x: float, y: float): Enemy =
    var newEnemy = Enemy()
    newEnemy.loc = (x: x, y: y)
    newEnemy.sprite = Drawable(loc: (x: 0, y: 0), size: (w: 20, h: 20))
    newEnemy.sprite.parent = newEnemy

    var col: ColliderBox = ColliderBox(size: (w: 20, h: 20))
    newEnemy.addCollider(col)
    return newEnemy

method onCollide*(self: Enemy) = 
    if not self.onCollisionCooldown:
        self.collisionTimer = self.collisionCooldown
        self.onCollisionCooldown = true
        self.health -= 1

method destroy*(self: Enemy) = 
    self.enabled = false
    self.dead = true
    self.parent = nil

method die*(self: Enemy) = 
    self.destroy()

method update*(self: Enemy, deltatime: float) =
    procCall self.GameObject.update(deltatime)

    if self.health <= 0:
        self.die()

## Diver

type
    Diver* = ref object of Enemy
        speed*: float = - 0.2f

proc newDiver*(x: float, y: float): Diver =
    var d = Diver()
    d.loc = (x: x, y: y)
    d.sprite = Drawable(loc: (x: 0, y: 0), size: (w: 10, h: 10))
    d.sprite.parent = d
    
    var col: ColliderBox = ColliderBox(size: (w: 10, h: 10))
    d.addCollider(col)

    return d

method update*(self: Diver, deltatime: float) =
    procCall self.GameObject.update(deltatime)

    # Wait 1 second, then dive
    if self.lifeTimer > 1.0f:
        self.loc.y += self.speed * deltatime

    if self.loc.y < 0.0f:
        self.die()

    if self.health <= 0:
        self.die()
