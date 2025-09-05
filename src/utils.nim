from math import sqrt


proc normalize*(x: float = 0, y: float = 0): (float, float) =     
    if x == 0 and y == 0:
        result = (0, 0)
    else:
        let mag = sqrt(x*x + y*y)
        result = (x/mag, y/mag)

proc normalize*(x: int = 0, y: int = 0): (float, float) = 
    normalize(float(x), float(y))
