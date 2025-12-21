import dom, sugar, intsets
import jscanvas

from draw import Drawable
from game import Game, GameInstance, loadAssetsAndStart, registerGameObject
from gameobj import GameObject, addCollider
import player
import collision


proc onkeydown(game: Game, e: Event) =
    game.keyboard.incl(e.KeyboardEvent.keyCode)

proc onkeyup(game: Game, e: Event) =
    game.keyboard.excl(e.KeyboardEvent.keyCode)

proc onLoad(event: Event) {.exportc.} =
    # Create game
    var game = GameInstance()

    var testEnemy = GameObject()
    testEnemy.loc = (x:125, y:125)
    testEnemy.sprite = Drawable(loc:(x:0, y:0), size:(w:20, h:20))
    testEnemy.sprite.parent = testEnemy

    var col: ColliderBox = ColliderBox(size:(w:50, h:50))
    col.drawOutline = true

    testEnemy.addCollider(col)
    game.registerGameObject(testEnemy)

    # Load assets, start game once done
    game.loadAssetsAndStart()

    # Add keypress listener
    document.addEventListener("keydown", (event: Event) => onkeydown(game, event))
    document.addEventListener("keyup", (event: Event) => onkeyup(game, event))
    echo "Game start"

window.onload = onLoad
