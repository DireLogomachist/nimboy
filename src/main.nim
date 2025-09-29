import dom, sugar, intsets
import jscanvas

from game import Game, Player, loadAssetsAndStart


proc onkeydown(game: Game, e: Event) =
    game.keyboard.incl(e.KeyboardEvent.keyCode)

proc onkeyup(game: Game, e: Event) =
    game.keyboard.excl(e.KeyboardEvent.keyCode)

proc onLoad(event: Event) {.exportc.} =
    # Create game and canvas
    let canvas = document.getElementById("gameCanvas").CanvasElement
    let ctx = canvas.getContext2d()
    var game = Game(player : Player(),
                          canvas : canvas,
                          canvasContext : ctx)

    # Load assets, start game once done
    game.loadAssetsAndStart()

    # Add keypress listener
    document.addEventListener("keydown", (event: Event) => onkeydown(game, event))
    document.addEventListener("keyup", (event: Event) => onkeyup(game, event))
    echo "Game start"

window.onload = onLoad
