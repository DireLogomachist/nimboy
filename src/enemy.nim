from gameobj import GameObject


type
    Enemy* = ref object of GameObject

method update*(self: Enemy) =
    discard