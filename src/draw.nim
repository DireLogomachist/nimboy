import jscanvas


type
    Coordinate* = tuple[x: float, y: float]

    Drawable* = ref object of RootObj
        location*: Coordinate = (x: 256, y: 256)
        size* = (w: 32, h: 32)
        color* = "#39594a"

proc draw*(self: Drawable, context: CanvasContext) = 
    context.fillStyle = self.color
    context.fillRect(self.location.x - self.size.w/2, self.location.y - self.size.h/2, self.size.w, self.size.h)
