import std/heapqueue
import jscanvas

from dom import Event

type
    Game* = ref object
        player*: Player
        canvas*: CanvasElement
        canvasContext*: CanvasContext
        inputQueue*: HeapQueue[Event]
    
    Player* = ref object
        location* = (x: 250, y: 250)
        sprite* = (w: 10, h: 10)
        color* = "black"
    
    Projectile* = ref object
        location* = (x: 0, y: 0)
        radius* = 2
        speed* = 1
