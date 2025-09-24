from math import sqrt, `^`

from draw import Coordinate


type
    ColliderBox* = ref object of RootObj
        location*: Coordinate = (x: 0, y: 0)
        size* = (w: 16, h: 16)
    
    ColliderCircle* = ref object of RootObj
        location*: Coordinate = (x: 0, y: 0)
        radius*: float = 8

proc collisionCheck*(a: ColliderBox, b: ColliderBox): bool = 
    discard

proc collisionCheck*(a: ColliderCircle, b: ColliderCircle): bool = 
    var collider_dist = sqrt((a.location.x - b.location.x)^2 + (a.location.y - b.location.y)^2)
    var touch_dist = a.radius + b.radius
    if touch_dist > collider_dist:
        return false
    return true

proc collisionCheck*(a: ColliderCircle, b: ColliderBox): bool = 
    discard

proc collisionCheck*(a: ColliderBox, b: ColliderCircle): bool = 
    return collisionCheck(b, a)
