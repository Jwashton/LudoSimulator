$ ->
  canvas = document.getElementById("board")
  context = canvas.getContext('2d')
    
  p1 = new Player(0, "Fred")
  p2 = new Player(1, "Fred")
  p3 = new Player(2, "Fred")
  p4 = new Player(3, "Fred")
  d = new Die(6)
  b = new Board([p1, p2, p3, p4], d, context)
  view = new CircleView(context, b)
  autoplay = null
  
  resizeCanvas = ->
    canvas.width  = window.innerWidth
    canvas.height = window.innerHeight
    view.draw()

  window.addEventListener 'resize', resizeCanvas, false
  resizeCanvas()

  window.move = () ->
    b.move(view)
    if b.checkEnd()
      window.clearInterval(autoplay)
      autoplay = null
  
  window.displayHouses = () ->
    console.log b.houses
  
  $(window).on 'keyup', (event) ->
    if event.which == 32
      window.move()
    else if event.which == 80
      console.log('p pressed')
      unless autoplay?
        autoplay = window.setInterval(move, 20)
      else
        window.clearInterval(autoplay)
        autoplay = null
