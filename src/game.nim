import strformat, intsets
import std/times
from dom import Event, KeyboardEvent
import jscanvas

from utils import normalize

type
    Coordinate* = tuple[x: float, y: float]

    Game* = ref object
        keyboard*: IntSet
        player*: Player
        canvas*: CanvasElement
        canvasContext*: CanvasContext
        canvasColor* = "#7b8210"
        canvasWidth* = 512
        deltaTime*: int64
        lastUpdate*: Time
    
    Player* = ref object
        location*: Coordinate = (x: 256, y: 256)
        sprite* = (w: 32, h: 32)
        color* = "#39594a"
        speed*: float = 0.3
    
    Projectile* = ref object
        location* = (x: 0, y: 0)
        radius* = 2
        speed* = 1

    Key* {.pure.} = enum
        LeftArrow = 37, UpArrow = 38, RightArrow = 39,
        DownArrow = 40

proc processInputs*(game: Game) = 
    # Player movement
    var xMove = 0
    var yMove = 0

    # Check keys against keyboard state
    if ord(Key.LeftArrow) in game.keyboard:
        xMove = -1
    if ord(Key.RightArrow) in game.keyboard:
        xMove = 1
    if ord(Key.UpArrow) in game.keyboard:
        yMove = -1
    if ord(Key.DownArrow) in game.keyboard:
        yMove = 1

    # Move player
    var direction: (float, float) = normalize(xMove, yMove)
    if direction[0] != 0:
        game.player.location.x += game.player.speed * float(game.deltaTime) * direction[0]
    if direction[1] != 0:
        game.player.location.y += game.player.speed * float(game.deltaTime) * direction[1]

    #echo fmt"x:{game.player.location.x} y:{game.player.location}"
    echo fmt"{game.deltaTime}"
