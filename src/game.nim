import strformat, intsets
import std/times
import jscanvas

from draw import Drawable, draw
from utils import normalize


type
    Game* = ref object
        keyboard*: IntSet
        player*: Player
        canvas*: CanvasElement
        canvasContext*: CanvasContext
        canvasColor* = "#7b8210"
        canvasWidth* = 512
        deltaTime*: int64
        lastUpdate*: Time
    
    Player* = ref object of Drawable
        speed*: float = 0.3

    Key* {.pure.} = enum
        LeftArrow = 37, UpArrow = 38,
        RightArrow = 39, DownArrow = 40

proc processInputs(self: Game) = 
    # Player movement
    var xMove = 0
    var yMove = 0

    # Check keys against keyboard state
    if ord(Key.LeftArrow) in self.keyboard:
        xMove = -1
    if ord(Key.RightArrow) in self.keyboard:
        xMove = 1
    if ord(Key.UpArrow) in self.keyboard:
        yMove = -1
    if ord(Key.DownArrow) in self.keyboard:
        yMove = 1

    # Move player
    var direction: (float, float) = normalize(xMove, yMove)
    if direction[0] != 0:
        self.player.location.x += self.player.speed * float(self.deltaTime) * direction[0]
    if direction[1] != 0:
        self.player.location.y += self.player.speed * float(self.deltaTime) * direction[1]

proc drawAll(self: Game) = 
    # Draw background
    self.canvasContext.fillStyle = self.canvasColor
    self.canvasContext.fillRect(0, 0, self.canvasWidth, self.canvasWidth)

    # Draw player
    self.player.draw(self.canvasContext)

proc update*(self: Game) = 
    # Calculate deltatime
    var currentTime = getTime()
    self.deltaTime = inMilliseconds(currentTime - self.lastUpdate)
    self.lastUpdate = currentTime

    # Check for key presses
    self.processInputs()

    # Draw scene
    self.drawAll()
