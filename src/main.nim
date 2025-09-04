import std/heapqueue, strformat, dom, sugar

import jscanvas

from game import Game, Player, Key, processInputs

proc onkeydown(game: Game, e: Event) =
    let event = e.KeyboardEvent
    
    for keyCode in Key.low..Key.high:
        if keyCode.ord() == event.keyCode:
            game.inputQueue.push(event)
            return
    echo fmt"Unhandled key {event.key}"

proc gameUpdate(game: Game, time: float) = 
    # Process input queue
    processInputs(game)

    # Draw background
    game.canvasContext.fillStyle = "grey"
    game.canvasContext.fillRect(0,0,500,500)

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
    var game = Game(player : Player(location : (250, 250),
                                          sprite : (10, 10)),
                          canvas : canvas,
                          canvasContext : ctx)

    # Start game loop
    onTick(game, 16)

    # Add keypress listener
    document.addEventListener("keydown", (event: Event) => onkeydown(game, event))
    echo "Game start"

window.onload = onLoad
