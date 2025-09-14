import dom, sugar, intsets
import jscanvas

from game import Game, Player, update
from draw import SpriteDrawable, loadImage, newImageElement


proc onkeydown(game: Game, e: Event) =
    game.keyboard.incl(e.KeyboardEvent.keyCode)

proc onkeyup(game: Game, e: Event) =
    game.keyboard.excl(e.KeyboardEvent.keyCode)

proc onTick(game: Game, time: float) =
    # Schedule next tick
    discard window.requestAnimationFrame((time: float) => onTick(game, time))

    # Update game state
    game.update()

proc onLoad(event: Event) {.exportc.} =
    # Create game and canvas
    let canvas = document.getElementById("gameCanvas").CanvasElement
    let ctx = canvas.getContext2d()
    var game = Game(player : Player(),
                          canvas : canvas,
                          canvasContext : ctx,
                          testSprite : SpriteDrawable(spriteImage : newImageElement()))

    # Load test image
    game.testSprite.loadImage()

    # Start game loop
    onTick(game, 16)

    # Add keypress listener
    document.addEventListener("keydown", (event: Event) => onkeydown(game, event))
    document.addEventListener("keyup", (event: Event) => onkeyup(game, event))
    echo "Game start"

window.onload = onLoad
