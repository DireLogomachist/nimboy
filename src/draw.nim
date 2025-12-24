import transform

import dom, tables
from math import round
import jscanvas


type
    Drawable* = ref object of TransformObject
        size* = (w: 16, h: 16)
        color* = "#294139"
        loaded* = false
        enabled* = true
    
    SpriteDrawable* = ref object of Drawable
        spriteFile*: string = "plummet_player.png"
        spriteImage*: ImageElement

# The dom ImageElement class for some reason does not behave like a full HTML5 ImageElement
# It has the data, but never loads its source image
# Here we just wrap an import around the JS Image class directly
proc newImageElement*(): ImageElement {.importcpp: "new Image()", constructor.}

method draw*(self: Drawable, context: CanvasContext) {.base.} = 
    if self.enabled:
        var global = self.getGlobalLocation()
        context.fillStyle = self.color
        context.fillRect(round(global.x - self.size.w/2), round(global.y - self.size.h/2),
                            self.size.w, self.size.h)

method draw*(self: SpriteDrawable, context: CanvasContext) =
    if self.enabled:
        var global = self.getGlobalLocation()
        context.imageSmoothingEnabled = false
        if self.spriteImage.complete:
            context.drawImage(self.spriteImage,
                            round(global.x - self.size.w/2), round(global.y - self.size.h/2))

method load*(self: Drawable, assetCache: Table[string, ImageElement]) {.base.} =
    self.loaded = true

method load*(self: SpriteDrawable, assetCache: Table[string, ImageElement]) =
    self.spriteImage = assetCache[self.spriteFile]
    self.spriteImage.width = self.size.w
    self.spriteImage.height = self.size.h
    self.loaded = true
