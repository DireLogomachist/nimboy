import dom, sugar, intsets

from game import Game, GameInstance, loadAssetsAndStart, registerGameObject


proc onkeydown(game: Game, e: Event) =
    game.keyboard.incl(e.KeyboardEvent.keyCode)

proc onkeyup(game: Game, e: Event) =
    game.keyboard.excl(e.KeyboardEvent.keyCode)

proc onLoad(event: Event) {.exportc.} =
    # Create game
    var game = GameInstance()

    # Load assets, start game once done
    game.loadAssetsAndStart()

    # Add keypress listener
    document.addEventListener("keydown", (event: Event) => onkeydown(game, event))
    document.addEventListener("keyup", (event: Event) => onkeyup(game, event))
    echo "Game start"

window.onload = onLoad
