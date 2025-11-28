from math import sqrt, `^`, Pi
import jscanvas except Path

import transform
from utils import normalize, magnitude

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
    var touch_min_dist = a.radius + b.radius
    if collider_dist < touch_min_dist:
        return true
    return false

method collisionCheck*(circle: ColliderCircle, box: ColliderBox): bool = 
    var box_global = box.getGlobalLocation()
    var circle_global = circle.getGlobalLocation()

    # Check first if too far away vertically or horizontally to work
    var dist_to_centers = utils.magnitude(circle_global - box_global)
    if dist_to_centers > circle.radius + utils.magnitude(box.size.w/2, box.size.h/2):
        return false

    # Check if center is completely within box
    var dist_to_centersX = utils.magnitude((circle_global - box_global).x)
    var dist_to_centersY = utils.magnitude((circle_global - box_global).y)
    if dist_to_centersX <= box.size.w/2 and dist_to_centersY <= box.size.h/2:
        return true

    # Check if radius can reach up/down, left/right into the box from the sides
    if dist_to_centersX <= box.size.w/2:
        # check if y +/- radius is in box
        if dist_to_centersY - circle.radius <= box.size.h/2:
            return true
    elif dist_to_centersY <= box.size.h:
        # check if x +/- radius is in box
        if dist_to_centersX - circle.radius <= box.size.w/2:
            return true

    # Check if distance of each corner to circle center is less than radius * 2
    if (utils.magnitude(circle_global - box_global - (box.size.w/2, box.size.h/2)) < circle.radius):
        return true
    elif (utils.magnitude(circle_global - box_global - (box.size.w/2, -box.size.h/2)) < circle.radius):
        return true
    elif (utils.magnitude(circle_global - box_global - (-box.size.w/2, -box.size.h/2)) < circle.radius):
        return true
    elif (utils.magnitude(circle_global - box_global - (-box.size.w/2, box.size.h/2)) < circle.radius):
        return true
    return false

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
    context.stroke()
    context.closePath()
