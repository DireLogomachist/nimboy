from math import sqrt, `^`

from draw import Coordinate, Size


type
    ColliderBox* = ref object of RootObj
        loc*: Coordinate = (x: 0, y: 0)
        size*: Size = (w: 16, l: 16)
    
    ColliderCircle* = ref object of RootObj
        loc*: Coordinate = (x: 0, y: 0)
        radius*: float = 8

proc collisionCheck*(a: ColliderBox, b: ColliderBox): bool = 
    if (a.loc.x + a.size.w < b.loc.x):
        return false
    if (a.loc.x > b.loc.x + b.size.w):
        return false
    if (a.loc.y + a.size.l < b.loc.y):
        return false
    if (a.loc.y > b.loc.y + b.size.l):
        return false
    return true

proc collisionCheck*(a: ColliderCircle, b: ColliderCircle): bool = 
    var collider_dist = sqrt((a.loc.x - b.loc.x)^2 + (a.loc.y - b.loc.y)^2)
    var touch_dist = a.radius + b.radius
    if touch_dist > collider_dist:
        return false
    return true

proc collisionCheck*(a: ColliderCircle, b: ColliderBox): bool = 
    discard

proc collisionCheck*(a: ColliderBox, b: ColliderCircle): bool = 
    return collisionCheck(b, a)
