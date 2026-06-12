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
    # disable collisions
    # change sprite, death particles
    # after wait, disable and destroy
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

## Exploder

type
    Exploder* = ref object of Enemy
        speed*: float = 0.08f
        targetPos*: (float, float)
        reachedTarget*: bool = false
        detonationTimer*: float = 0.0f
        detonationDuration*: float = 0.5f
        isDetonating*: bool = false

proc newExploder*(x: float, y: float, targetX: float, targetY: float): Exploder =
    var e = Exploder()
    e.loc = (x: x, y: y)
    e.targetPos = (x: targetX, y: targetY)
    e.sprite = Drawable(loc: (x: 0, y: 0), size: (w: 8, h: 8))
    e.sprite.parent = e
    
    var col: ColliderBox = ColliderBox(size: (w: 8, h: 8))
    e.addCollider(col)

    return e

method update*(self: Exploder, deltatime: float) =
    procCall self.GameObject.update(deltatime)

    if not self.isDetonating:
        # Approach target position
        if not self.reachedTarget:
            let dx = self.targetPos[0] - self.loc.x
            let dy = self.targetPos[1] - self.loc.y
            let dist = math.sqrt(dx * dx + dy * dy)
            
            if dist > 2.0f:
                let dirX = dx / dist
                let dirY = dy / dist
                self.loc.x += dirX * self.speed * deltatime
                self.loc.y += dirY * self.speed * deltatime
            else:
                self.reachedTarget = true
        
        # Wait at target, then detonate
        if self.reachedTarget and self.lifeTimer > 1.0f:
            self.isDetonating = true
            self.detonationTimer = 0.0f
            # Swap to large explosion collider and sprite
            self.colliders.setLen(0)
            var explosionCol: ColliderBox = ColliderBox(size: (w: 40, h: 40))
            self.addCollider(explosionCol)
            self.sprite.size = (w: 40, h: 40)
    else:
        # Detonation active—count down
        self.detonationTimer += deltatime / 1000.0f
        if self.detonationTimer > self.detonationDuration:
            self.die()

    if self.health <= 0:
        self.die()

## GridBomb

type
    GridBomb* = ref object of Enemy
        detonationTimer*: float = 2.0f
        detonationDuration*: float = 0.5f

proc newGridBomb*(x: float, y: float): GridBomb =
    var g = GridBomb()
    g.loc = (x: x, y: y)
    g.sprite = SpriteDrawable(loc: (x: 0, y: 0), spriteFile: "gridbomb.png")
    g.sprite.parent = g

    var col: ColliderBox = ColliderBox(size: (w: 39, h: 39))
    col.enabled = false
    g.addCollider(col)

    return g

method update*(self: GridBomb, deltatime: float) =
    procCall self.GameObject.update(deltatime)

    # Countdown
    if self.detonationTimer > 0.0:
        self.detonationTimer -= deltatime / 1000.0
        if self.detonationTimer < 0.0:
            self.sprite.size = (w: 39, h: 39)
            for collider in self.colliders:
                collider.enabled = true
    else:
        self.detonationDuration -= deltatime / 1000.0
        if self.detonationDuration < 0.0:
            self.die()
