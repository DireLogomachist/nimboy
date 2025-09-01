import std/heapqueue
import dom, jscanvas, sugar

import Game

proc onkeydown(game: Game, e: Event) =
  let event = e.KeyboardEvent
  case event.key:
    of "ArrowLeft", "ArrowRight", "ArrowDown", "ArrowUp":
        game.inputQueue.push(event)
        #game.player.location.x -= 3
    else:
      discard

proc gameUpdate(game: Game, time: float) = 
    # Process input queue
    # Physics
    # Draw
    game.canvasContext.fillStyle = "grey"
    game.canvasContext.fillRect(0,0,500,500)

    game.canvasContext.fillStyle = game.player.color
    game.canvasContext.fillRect(game.player.location.x, game.player.location.y, game.player.sprite.w, game.player.sprite.h)


proc onTick(game: Game, time: float) =
    # Schedule next tick
    discard window.requestAnimationFrame((time: float) => onTick(game, time))

    # Game state update
    gameUpdate(game, time)


proc onLoad(event: Event) {.exportc.} =
    let canvas = document.getElementById("gameCanvas").CanvasElement
    let ctx = canvas.getContext2d()
    ctx.fillStyle = "grey"
    ctx.fillRect(0,0,500,500)
    #ctx.fillStyle = "black"
    #ctx.strokeText("Hello s",250,250)

    var game = Game(player : Player(location : (250, 250),
                                          sprite : (10, 10)),
                          canvas : canvas,
                          canvasContext : ctx)
      
    onTick(game, 16)

    document.addEventListener("keydown", (event: Event) => onkeydown(game, event))

window.onload = onLoad
