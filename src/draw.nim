import dom, strformat
import jscanvas


type
    Coordinate* = tuple[x: float, y: float]

    Drawable* = ref object of RootObj
        location*: Coordinate = (x: 256, y: 256)
        size* = (w: 32, h: 32)
        color* = "#39594a"
    
    SpriteDrawable* = ref object of Drawable
        spriteFile*: string = "src/assets/test.png"
        spriteImage*: ImageElement

# The dom ImageElement class for some reason does not behave like a full HTML5 ImageElement
# It has the data, but never loads its source image
# Here we just wrap an import around the JS Image class directly
proc newImageElement*(): ImageElement {.importcpp: "new Image()", constructor.}

proc draw*(self: Drawable, context: CanvasContext) = 
    context.fillStyle = self.color
    context.fillRect(self.location.x - self.size.w/2, self.location.y - self.size.h/2, self.size.w, self.size.h)

proc draw*(self: SpriteDrawable, context: CanvasContext) =
    if self.spriteImage.complete:
        echo "drawing sprite"
        context.drawImage(self.spriteImage, self.size.w, self.size.h)
    else:
        echo "sprite not ready"

proc loadImage*(self: SpriteDrawable) =
    self.spriteImage.width = self.size.w
    self.spriteImage.height = self.size.h
    self.spriteImage.src = self.spriteFile

