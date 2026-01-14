import gameobj


type
    Enemy* = ref object of GameObject
        health*: int = 1

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
    self.updateCollisionTimer(deltatime)

    if self.health <= 0:
        self.die()
