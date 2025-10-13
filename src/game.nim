import intsets, tables, sugar
from dom import ImageElement, Event, window, requestAnimationFrame
from std/paths import Path, extractFilename
import std/times
import jscanvas except Path

from draw import Drawable, SpriteDrawable, draw, newImageElement
from gameobj import GameObject, update, draw
import player
from utils import normalize


type
    Game* = ref object
        keyboard*: IntSet
        assetCache*: Table[string, ImageElement]
        assetCounter: int
        player*: Player
        gameObjectList*: seq[GameObject]
        canvas*: CanvasElement
        canvasContext*: CanvasContext
        canvasColor* = cstring("#7b8210")
        canvasWidth* = 512
        deltaTime*: int64
        lastUpdate*: Time

    Key* {.pure.} = enum
        LeftArrow = 37, UpArrow = 38,
        RightArrow = 39, DownArrow = 40

const assetList = [
    "src/assets/plummet_player.png"
]

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
        self.player.loc.x += self.player.speed * float(self.deltaTime) * direction[0]
    if direction[1] != 0:
        self.player.loc.y += self.player.speed * float(self.deltaTime) * direction[1]

proc drawAll(self: Game) = 
    # Draw background
    self.canvasContext.fillStyle = self.canvasColor
    self.canvasContext.fillRect(0, 0, self.canvasWidth, self.canvasWidth)

    # Draw game objects
    for gameObject in self.gameObjectList:
        gameObject.draw(self.canvasContext)

    # Draw player
    self.player.draw(self.canvasContext, self.assetCache)

proc update*(self: Game) = 
    # Calculate deltatime
    var currentTime = getTime()
    self.deltaTime = inMilliseconds(currentTime - self.lastUpdate)
    self.lastUpdate = currentTime

    # Check for key presses
    self.processInputs()

    # Game object updates
    for gameObject in self.gameObjectList:
        gameObject.update()

    # Draw scene
    self.drawAll()

proc tick(self: Game, time: float) =
    # Schedule next tick
    discard window.requestAnimationFrame((time: float) => tick(self, time))

    # Update game state
    self.update()

proc assetReady(self: Game, asset: string, image: ImageElement, e: Event) =
    self.assetCounter += 1
    self.assetCache[string(extractFilename(Path(asset)))] = image
    # Once all loaded, start game tick
    if len(assetList) == self.assetCounter:
        self.tick(16)

proc loadAssetsAndStart*(self: Game) = 
    for assetFile in assetList:
        var assetImage: ImageElement = newImageElement()
        assetImage.onload = (event: Event) => self.assetReady(assetFile, assetImage, event)
        assetImage.src = cstring(assetFile)
