$ ->
  class Board
    constructor: (@players, @die, @context) ->
      @currentPlayer = 3
      @again = false
      @track = (null for i in [0..51])
      @doors = [50, 24, 11, 37]
      @starts = [0, 26, 13, 39]
      @houses = [[null, null, null, null, null]
                 [null, null, null, null, null]
                 [null, null, null, null, null]
                 [null, null, null, null, null]]
      @reserves = [4, 4, 4, 4]
      @goals    = [0, 0, 0, 0]
      @colors = ["#FF0000", "#00FF00", "#00AAFF", "#FFFF00"]
    
    drawCircle: (x, y, radius, color) ->
      @context.fillStyle = color
      @context.beginPath()
      @context.arc(x, y, radius, 0, Math.PI * 2)
      @context.fill()
    
    draw: ->
      context.font = "12pt serif"
      
      context.fillStyle = "#FFFFFF"
      context.fillRect(0, 0, window.innerWidth, window.innerHeight)
      
      # Draw Track
      for i in [0..51]
        @drawCircle(i * 25 + 20, 20, 10, "#000000")
      
      # Draw Reserves
      for i, j in @starts
        @drawCircle(i * 25 + 20, 40, 10, @colors[j])
        context.fillStyle = "#000000"
        context.fillText(@reserves[j], i * 25 + 16, 45)
      
      # Draw Houses
      for location, player in @doors
        for i, j in @houses[player]
          @drawCircle(location * 25 + 20, j * 20 + 40, 10, @colors[player])
          if i?
            color = @colors[i]
          else
            color = "#FFFFFF"
          @drawCircle(location * 25 + 20, j * 20 + 40, 8, color)
        
        context.strokeStyle = @colors[player]
        context.strokeRect(location * 25, 140, 40, 30)
        context.fillStyle = "#000000"
        context.fillText(@goals[player], location * 25 + 16, 160)
      
      for i, j in @track
        if i?
          color = @colors[i]
          @drawCircle(j * 25 + 20, 20, 8, color)
      
      currentColor = @colors[@currentPlayer]
      @drawCircle(34, window.innerHeight - 35, 10, currentColor)
      roll = @die.history.splice(-1)
      context.fillStyle = "#000000"
      y = window.innerHeight - 30
      context.fillText(roll, 30, y)
      context.fillText("Space to move, p to toggle play", 60, y)
      
      todolist = [
        "Program win condition"
        "Find all current active pieces"
        "Expose Decision Points"
        "Create Strategies"
        "Highlight last move (arrows maybe?)"
      ]
      
      x = window.innerWidth - 400
      y = window.innerHeight - (60 + todolist.length * 20)
      context.fillText("Todo List:", x - 20, y)
      for i, j in todolist
        y = window.innerHeight - (40 + todolist.length * 20) + j * 20
        context.fillText(i, x, y)
      
    move: ->
      unless @again
        @currentPlayer = (@currentPlayer + 1) % 4
      @again = false
      @players[@currentPlayer].move this
      @draw()
    
    goAgain: ->
      @again = true
    
    returnPiece: (location) ->
      player = @track[location]
      @reserves[player]++
      @track[location] = null
    
    deliverPiece: (player) ->
      @goals[player]++
    
  class Die
    constructor: (@numSides) ->
      @history = []
    
    roll: ->
      result = Math.floor(Math.random() * @numSides) + 1
      @history.push result
      result
    
    recentRolls: ->
      @history.slice(-20, -1)

  class Player
    constructor: (@id, @name) ->
    
    hasStart: (board) ->
      board.reserves[@id] > 0
    
    hasExposed: (board) ->
      board.track.indexOf(@id) != -1
    
    hasHoused: (board) ->
      board.houses[@id].indexOf(@id) != -1
    
    start: (board) ->
      if @hasStart(board)
        board.reserves[@id] -= 1
        if board.track[board.starts[@id]]?
          board.returnPiece board.starts[@id]
        board.track[board.starts[@id]] = @id
    
    advance: (board, source, steps, house) ->
      destination = source + steps
      
      if house
        console.log("Moving from #{source} to #{destination} in house!")
        if destination == 5
          board.deliverPiece(@id)
          board.houses[@id][source] = null
        else if destination < 5
          unless board.houses[@id][destination]?
            board.houses[@id][source] = null
            board.houses[@id][destination] = @id
      # If the piece we are trying to move is really our own
      if board.track[source] == @id
        # if we can enter home
        door = board.doors[@id]
        if source == door or (source < door and source + steps > door)
          # enter door
          interiorSteps = steps - (door - source) - 1
          
          unless board.houses[@id][interiorSteps]?
            board.track[source] = null
            board.houses[@id][interiorSteps] = @id
          
        else
          destination = (source + steps) % 52
          
          unless board.track[destination] == @id
            if board.track[destination]?
              board.returnPiece destination
            
            board.track[source] = null
            board.track[destination] = @id
      
    move: (board) ->
      num = board.die.roll()
      console.log "rolled a #{num}"
      if num == 6
        @start(board)
        board.goAgain()
      else if @hasExposed(board)
        current = board.track.indexOf(@id)
        @advance(board, current, num, false)
      else if @hasHoused(board)
        current = board.houses[@id].indexOf(@id)
        @advance(board, current, num, true)
      else
        console.log "Do Nothing"
    
  canvas = document.getElementById("board")
  context = canvas.getContext('2d')
    
  p1 = new Player(0, "Fred")
  p2 = new Player(1, "Fred")
  p3 = new Player(2, "Fred")
  p4 = new Player(3, "Fred")
  d = new Die(6)
  b = new Board([p1, p2, p3, p4], d, context)
  autoplay = null
  
  resizeCanvas = ->
    canvas.width  = window.innerWidth
    canvas.height = window.innerHeight
    b.draw()

  window.addEventListener 'resize', resizeCanvas, false
  resizeCanvas()

  window.move = () ->
    b.move()
  
  window.displayHouses = () ->
    console.log b.houses
  
  $(window).on 'keyup', (event) ->
    if event.which == 32
      window.move()
    else if event.which == 80
      console.log('p pressed')
      unless autoplay?
        autoplay = window.setInterval(move, 100)
      else
        window.clearInterval(autoplay)
        autoplay = null
