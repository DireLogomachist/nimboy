import std/heapqueue, strformat
import jscanvas

from dom import Event, KeyboardEvent

from utils import normalize

type
    Coordinate* = tuple[x: float, y: float]

    Game* = ref object
        player*: Player
        canvas*: CanvasElement
        canvasContext*: CanvasContext
        inputQueue*: HeapQueue[Event]
    
    Player* = ref object
        location*: Coordinate = (x: 250, y: 250)
        sprite* = (w: 10, h: 10)
        color* = "black"
        speed*: float = 3
    
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

    # Loop through input queue
    for evt in game.inputQueue:
        case Key(evt.KeyboardEvent.keyCode):
        of Key.LeftArrow:
            xMove = -1
        of Key.RightArrow:
            xMove = 1
        of Key.UpArrow:
            yMove = -1
        of Key.DownArrow:
            yMove = 1
        else:
            discard
    
    # Clear input queue
    game.inputQueue.clear()

    # Move player
    var direction: (float, float) = normalize(xMove, yMove)
    if direction[0] != 0:
        game.player.location.x += game.player.speed*direction[0]
    if direction[1] != 0:
        game.player.location.y += game.player.speed*direction[1]

    echo fmt"x:{game.player.location.x} y:{game.player.location}"
