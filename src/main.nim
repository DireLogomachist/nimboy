import std/heapqueue, strformat, dom, sugar, intsets
import jscanvas

from game import Game, Player, Key, processInputs


proc onkeydown(game: Game, e: Event) =
    game.keyboard.incl(e.KeyboardEvent.keyCode)

proc onkeyup(game: Game, e: Event) =
    game.keyboard.excl(e.KeyboardEvent.keyCode)

proc gameUpdate(game: Game, time: float) = 
    # Check for key presses
    processInputs(game)

    # Draw background
    game.canvasContext.fillStyle = game.canvasColor
    game.canvasContext.fillRect(0,0,game.canvasWidth,game.canvasWidth)

    # Draw player
    game.canvasContext.fillStyle = game.player.color
    game.canvasContext.fillRect(game.player.location.x, game.player.location.y, game.player.sprite.w, game.player.sprite.h)


proc onTick(game: Game, time: float) =
    # Schedule next tick
    discard window.requestAnimationFrame((time: float) => onTick(game, time))

    # Game state update
    gameUpdate(game, time)


proc onLoad(event: Event) {.exportc.} =
    # Create game and canvas
    let canvas = document.getElementById("gameCanvas").CanvasElement
    let ctx = canvas.getContext2d()
    var game = Game(player : Player(),
                          canvas : canvas,
                          canvasContext : ctx)

    # Start game loop
    onTick(game, 16)

    # Add keypress listener
    document.addEventListener("keydown", (event: Event) => onkeydown(game, event))
    document.addEventListener("keyup", (event: Event) => onkeyup(game, event))
    echo "Game start"

window.onload = onLoad
