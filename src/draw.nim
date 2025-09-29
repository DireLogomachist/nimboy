import dom, tables
from math import round
import jscanvas


type
    Coordinate* = tuple[x: float, y: float]

    Size* = tuple[w: float, l: float]

    Drawable* = ref object of RootObj
        loc*: Coordinate = (x: 64, y: 64)
        rot*: float = 0
        size* = (w: 16, h: 16)
        color* = "#294139"
    
    SpriteDrawable* = ref object of Drawable
        spriteFile*: string = "plummet_player.png"
        spriteImage*: ImageElement

# The dom ImageElement class for some reason does not behave like a full HTML5 ImageElement
# It has the data, but never loads its source image
# Here we just wrap an import around the JS Image class directly
proc newImageElement*(): ImageElement {.importcpp: "new Image()", constructor.}

proc draw*(self: Drawable, context: CanvasContext) = 
    context.fillStyle = self.color
    context.fillRect(round(self.loc.x - self.size.w/2), round(self.loc.y - self.size.h/2),
                           self.size.w, self.size.h)

proc draw*(self: SpriteDrawable, context: CanvasContext) =
    context.imageSmoothingEnabled = false
    if self.spriteImage.complete:
        context.drawImage(self.spriteImage,
                          round(self.loc.x - self.size.w/2), round(self.loc.y - self.size.h/2))

proc loadImage*(self: SpriteDrawable, assetCache: Table[string, ImageElement]) =
    self.spriteImage = assetCache[self.spriteFile]
    self.spriteImage.width = self.size.w
    self.spriteImage.height = self.size.h
