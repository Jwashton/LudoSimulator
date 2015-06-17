$ ->
  canvas = document.getElementById("board")
  context = canvas.getContext('2d')
    
  p1 = new Player(0, "Fred")
  p2 = new Player(1, "Fred")
  p3 = new SingleMindedPlayer(2, "Fred")
  p4 = new Player(3, "Fred")
  d = new Die(6)
  b = new Board([p1, p2, p3, p4], d, context)
  view = new CircleView(context, b)
  
  resizeCanvas = ->
    canvas.width  = window.innerWidth
    canvas.height = window.innerHeight
    view.draw()

  window.addEventListener 'resize', resizeCanvas, false
  resizeCanvas()

  window.restart = ->
    b = new Board([p1, p2, p3, p4], d, context)
    view.board = b
    view.draw()
  
  window.move = ->
    b.move(view)
    if b.checkEnd() != -1
      window.win_history[b.checkEnd()]++
      view.draw()
      
      if autorestart
        window.clearInterval(window.autoplay)
        window.autoplay = null
        
        window.setTimeout((->
          restart(); window.autoplay = window.setInterval(move, 20)
        ), 1000)
      else
        window.clearInterval(window.autoplay)
        window.autoplay = null
  
  window.displayHouses = () ->
    console.log b.houses
  
  $(window).on 'keyup', (event) ->
    switch event.which
      when 32
        window.move()
      when 80 # p
        unless window.autoplay?
          window.autoplay = window.setInterval(move, 20)
        else
          window.clearInterval(window.autoplay)
          window.autoplay = null
      when 82 # r
        window.restart()
      when 65 # a
        window.autorestart = !(window.autorestart)
        view.draw()
