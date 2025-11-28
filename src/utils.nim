from math import sqrt
from complex import abs
from transform import Coordinate

proc magnitude*(x: float): (float) =
    return abs(x)

proc magnitude*(x: float, y: float): (float) =
    return sqrt(x*x + y*y)

proc magnitude*(c: (float, float)): (float) =
    return sqrt(c[0]*c[0] + c[1]*c[1])

proc normalize*(x: float = 0, y: float = 0): (float, float) =     
    if x == 0 and y == 0:
        result = (0, 0)
    else:
        let mag = sqrt(x*x + y*y)
        result = (x/mag, y/mag)

proc normalize*(x: int = 0, y: int = 0): (float, float) = 
    normalize(float(x), float(y))

proc normalize*(c: Coordinate): (float, float) = 
    normalize(float(c.x), float(c.y))
