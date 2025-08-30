import dom, jscanvas

proc onLoad(event: Event) {.exportc.} =
    let canvas = document.getElementById("gameCanvas").CanvasElement
    let ctx = canvas.getContext2d()
    ctx.fillStyle = "green"
    ctx.fillRect(0,0,500,500)
    ctx.fillStyle = "black"
    ctx.strokeText("Hello s",10,50)

window.onload = onLoad
