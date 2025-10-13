type
    Coordinate* = tuple[x: float, y: float]

    Size* = tuple[w: float, h: float]

    TransformObject* = ref object of RootObj
        loc*: Coordinate = (x: 0.0, y: 0.0)
        parent*: TransformObject

proc `+`*(a: Coordinate, b: Coordinate): Coordinate =
    return (x:a.x + b.x, y:a.y + b.y)

proc getGlobalLocation*(self: TransformObject): Coordinate =
    if self.parent != nil:
        return self.loc + self.parent.getGlobalLocation()
    else:
        return self.loc
