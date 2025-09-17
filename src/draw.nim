import dom, strformat
from math import round
import jscanvas


type
    Coordinate* = tuple[x: float, y: float]

    Drawable* = ref object of RootObj
        location*: Coordinate = (x: 128, y: 128)
        rotation*: float = 0
        size* = (w: 32, h: 32)
        color* = "#294139"
    
    SpriteDrawable* = ref object of Drawable
        spriteFile*: string = "src/assets/plummet_player.png"
        spriteImage*: ImageElement

# The dom ImageElement class for some reason does not behave like a full HTML5 ImageElement
# It has the data, but never loads its source image
# Here we just wrap an import around the JS Image class directly
proc newImageElement*(): ImageElement {.importcpp: "new Image()", constructor.}

proc draw*(self: Drawable, context: CanvasContext) = 
    context.fillStyle = self.color
    context.fillRect(round(self.location.x - self.size.w/2), round(self.location.y - self.size.h/2),
                           self.size.w, self.size.h)

proc draw*(self: SpriteDrawable, context: CanvasContext) =
    context.imageSmoothingEnabled = false
    if self.spriteImage.complete:
        context.drawImage(self.spriteImage,
                          round(self.location.x - self.size.w/2), round(self.location.y - self.size.h/2))

proc loadImage*(self: SpriteDrawable) =
    self.spriteImage.width = self.size.w
    self.spriteImage.height = self.size.h
    self.spriteImage.src = self.spriteFile

