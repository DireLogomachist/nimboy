from math import sqrt, `^`, Pi
import jscanvas except Path

import transform


type
    Collider* = ref object of TransformObject
        drawOutline*: bool = false

    ColliderBox* = ref object of Collider
        size*: Size = (w: 16, h: 16)
    
    ColliderCircle* = ref object of Collider
        radius*: float = 8

method collisionCheck*(a: Collider, b: Collider): bool = 
    discard

method collisionCheck*(a: ColliderBox, b: ColliderBox): bool =
    var a_global = a.getGlobalLocation()
    var b_global = b.getGlobalLocation()
    if ((a_global.x - a.size.w/2 + a.size.w) < (b_global.x - b.size.w/2)):
        return false
    if ((a_global.x - a.size.w/2) > (b_global.x - b.size.w/2 + b.size.w)):
        return false
    if ((a_global.y - a.size.h/2 + a.size.h) < (b_global.y - b.size.h/2)):
        return false
    if ((a_global.y - a.size.h/2) > (b_global.y - b.size.h/2 + b.size.h)):
        return false
    return true

method collisionCheck*(a: ColliderCircle, b: ColliderCircle): bool = 
    var a_global = a.getGlobalLocation()
    var b_global = b.getGlobalLocation()
    var collider_dist = sqrt((a_global.x - b_global.x)^2 + (a_global.y - b_global.y)^2)
    var touch_dist = a.radius + b.radius
    if touch_dist > collider_dist:
        return false
    return true

method collisionCheck*(a: ColliderCircle, b: ColliderBox): bool = 
    discard

method collisionCheck*(a: ColliderBox, b: ColliderCircle): bool = 
    return collisionCheck(b, a)

method draw*(self: Collider, context: CanvasContext) =
    discard

method draw*(self: ColliderBox, context: CanvasContext) =
    var global = self.getGlobalLocation()
    context.beginPath()
    context.strokeRect(global.x - self.size.w/2, global.y - self.size.h/2,
                       self.size.w, self.size.h)
    context.closePath()

method draw*(self: ColliderCircle, context: CanvasContext) =
    var global = self.getGlobalLocation()
    context.beginPath()
    context.arc(global.x, global.y, self.radius, 0, Pi*2)
    context.closePath()
